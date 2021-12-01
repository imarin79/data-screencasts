#' Full text of the papers in the CORD-19 dataset, separated into paragraphs.
#'
#' Full text of the papers in one-observation-per-paragraph form. Includes only the one in \code\link{cord19_paper}
#' (this deduplicated and filtered).
#' @format A tibble with variables:
#'\describe{paper_id} {unique identifier that can link to metadata and citations.
#'SHA of the paper PDF.}
#'\item{paragraph}{Index of the paragraph within the paper (1,2,3)}
#'\item{ section}{Section (e.g. Introduction, Results, Discussion)}
#'\item{text}{Full text}
#'}
#'
#'
#'#'@examples
#'
#'# What are the most common titles?
#' cord19_parahraphs %>%
#'   count(section, str_to_lower(section), sort=TRUE)
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
#' @seealso  | url{https:/www.kaggle.com/allen-institute-for-ai/CORD-19-research-challenge}
#' "cord19_paragraphs"
