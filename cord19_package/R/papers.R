#' Metadata for papers in the CORD-19 dataset.
#'
#' Metadara such as titles, authors, journal, publication IDs for each articles in the CORD-9 dataset. This comes from
#' the all_sources_metadata_2020-03-13.csv file in the decompressed dataset. This comes from the
#' \code{all_sources_metadata_DATE.csv} file in the decompressed dataset.
#' Note that duplicate papers (based on paper_id, doi, or title) have been deduplicated, and papers without title
#' or paper id have been removed.
#'
#'
#' @format A tibble with one observation for each paper in the following columns:
#'\describe{
#'\item{paper_id} {unique identifier that can link to full text and citations.
#'SHA of the paper PDF.}
#'\item{source}{Source (e.g pubmed, CSZI...)}
#'\item{title}{Title}
#'\item{doi}{Digital Object Identifier}
#'\item{pmcid}{pmcid}
#'\item{pubmed_id}{Pubmed ID}
#'\item{license}{;icense}
#'\item{abstract}{Abstract}
#'\item{publish_time}{Publication year}
#'\item{authors}{Authors}
#'\item{journal}{Journal}
#'\item{microsoft_academic_paper_ID}{Microsoft Academic Paper ID}
#'\item{who}{ConvidenceWHO}
#'\item{has_full_text}{Does it have full text}
#'
#'@examples
#'
#'# What are the most common journals?
#' cord19_papers %>%
#'   count(journal, sort=TRUE)
#'
#'# What are the most commo words in titles?
#' library(tidytext)
#' library(dplyr)
#'
#' cord19_papers %>%
#' unnest_tokens(word, title) %>%
#' count(word, sort=TRUE) %>%
#' anti_join(stop_words, by="word")
#'
#' #Could also look at abstracts
#'
#'
#'
#' @seealso  | url{https:/www.kaggle.com/allen-institute-for-ai/CORD-19-research-challenge}
#' "cord19_papers"
#'
#'
#'
#'
#'
