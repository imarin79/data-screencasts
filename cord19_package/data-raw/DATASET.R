# code to prepare "DATASET" dataset goes here:

library(tidyverse)
library(tidytext)
library(jsonlite)
library(janitor)
library(purr)
library(readr)
library(stringr)
library(janitor)


# Download the dataset from Kaggle here (requires account), then decompress
infolder <- "~/Downloads/kgarrett-covid-19-open-research-dataset"

setwd("~/Downloads/kgarrett-covid-19-open-research-dataset")


#Read in and remove duplicates:
cord19_papers <- read_csv(paste0("all_sources_metadata_2020-03-13.csv")) %>%
  clean_names() %>% #this is to make the column names lower case and remove spaces between names
  rename(paper_id = sha, #this is to rename column names to these ones.
         source = source_x) %>%
  filter(!is.na(paper_id), !is.na(title)) %>%
  arrange(is.na(title), is.na(abstract), is.na(authors), is.na(journal)) %>%
  # filter(!is.na(paper_id), !is.na(title)) %>%
  distinct(paper_id, .keep_all =TRUE) %>% #from the duplicate papers, just keep the first one.
  # distinct(title, .keep_all=TRUE) %>% #this way, we only keep the first one and remove all repeated titles.
  distinct(lower_title = str_to_lower(title), .keep_all=TRUE) %>%
  distinct(doi, .keep_all=TRUE) %>%
  # distinct(lower_title = str_to_lower(title), .keep_all=TRUE) %>%
  select(-lower_title)

#To be able to run this code, go to your description file and remove any space between lines (there should not be any space).
usethis::use_data(cord19_papers,overwrite = TRUE)

# There is duplication in the cord19 data:
# cord19_papers %>%
#   filter(!is.na(paper_id), !is.na(title)) %>%
#   arrange(is.na(title), is.na(abstract), is.na(authors), is.na(journal)) %>%
#   # filter(!is.na(paper_id), !is.na(title)) %>%
#   distinct(paper_id, .keep_all =TRUE) %>% #from the duplicate papers, just keep the first one.
#   # distinct(title, .keep_all=TRUE) %>% #this way, we only keep the first one and remove all repeated titles.
#   distinct(lower_title = str_to_lower(title), .keep_all=TRUE) %>%
#   distinct(doi, .keep_all=TRUE) %>%
#   # distinct(lower_title = str_to_lower(title), .keep_all=TRUE) %>%
#   select(-lower_title)
#   # count(str_to_lower(title), sort=TRUE) %>% # here we do two things: 1) we make all titles lower case; 2) and count them.
#
#   #
#   # count(pubmed_id, sort=TRUE)
#   # distinct(pubmed_id, .keep_all = TRUE) %>%

  # count(paper_id, sort=TRUE) %>%  #in here we can see that there are papers that are repeated.
  # distinct(paper_id) %>%
  # filter(pubmed_id == 30408032) %>%
  # View()


# Read in all the JSON objects as well.
# dir() with recursive= TRUE allows us to get a full vector of filenames:
json_objects <- dir(infolder, #here we specify the directory or folder
                    pattern= "*.json", #the pattern of files we want to extract.
                    full.names = TRUE, #to get the fullnames
                    recursive = TRUE) %>%  #this is to get a full vector of filenames.
  head(100) %>%
  map(read_json)

# Here we pull the articles and the text inside like sections.
articles_hoisted <- tibble(json = json_objects) %>%
  hoist(json,
        paper_id = "paper_id",
        section = c("body_text", function(.) map_chr(., "section")),
        text = c("body_text", function(.) map_chr(., "text")),
        citations = c("body_text", function(.) map(., "cite_spans")),
        bib_entries = "bib_entries") %>%
  select(-json)



# This is to get the paragraphs of those papers. Here we order the paragraphs in rows, so one row per paragraph.
# Here we only include the body of the paper.

paragraphs <- articles_hoisted %>%
  select(-bib_entries) %>%
  unnest(cols = c(text, section, citations)) %>%
  group_by(paper_id) %>%
  mutate(paragraph = row_number()) %>%
  ungroup() %>%
  select(paper_id, paragraph, everything())

# Here we are going to pull out the citations per paragraph, such that we will determine which citations go into each paragraph.
# Knowing the citation per paragraph can provide useful information about what the paragraph is about.

paragraph_citations <- paragraphs %>%
  select(paper_id, paragraph, citations) %>%
  unnest(citations) %>%
  hoist(citations, start = "start", end = "end", text = "text", ref_id = "ref_id")

object.size(paragraphs)/1e6

# Now that citations are pulled out, remove it. For some reason, the number of rows is much lower than the one from David Robinson screencast example (?), probably something missing.
cord19_paragraphs <- paragraphs %>%
  select(-citations) %>%
  semi_join(cord19_papers, by = "paper_id")

cord19_paragraph_citations <- paragraph_citations %>%
  filter(!is.na(ref_id)) %>%
  semi_join(cord19_papers, by ="paper_id") %>%
  mutate(ref_id = str_replace(ref_id, "BIBREF", "b" )) #we do this, so we can join my citations togethe late on.

citations <- articles_hoisted %>%
  select(paper_id, bib_entries) %>%
  unnest(bib_entries) %>%
  hoist(bib_entries,
        ref_id= "ref_id",
        title = "title",
        venue = "venue",
        volume = "volume",
        issn = "issn",
        pages = "pages",
        year = "year",
        doi = list("others_ids", "DOI", 1)) %>%
  select(-bib_entries)


cord19_paper_citations <- citations
citations %>% semi_join(cord19_papers, by = "paper_id") -> citations

usethis::use_data(cord19_paper_citations, overwrite = TRUE)
usethis::use_data(cord19_paragraph_citations,overwrite = TRUE)
usethis::use_package("usethis", type="Suggests")

#To load the package, you have to be in the right directory. In this case, setwd("~/Downloads/cord19")
devtools::load_all(".")
devtools::document()
usethis::use_readme_md()
?cord19_paragraphs



