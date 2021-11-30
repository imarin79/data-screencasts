#' Link papers and paragraphs within them, to citations
#'
#' Full text of the papers in one-observation-per-paragraph form. Includes only the one in \code\link{cord19_paper}
#' (this deduplicated and filtered).Can be joined with \code{\link{cord19_paper_citations}} with \code{paper_id} and
#' \code{ref_id}, or with \code{cord19_paragraphs} using \code{paper_id} and \code{paragraph}
#'
#' @format A tibble with variables:
#'\item{
#'\describe{paper_id} {unique identifier that can link to metadata and citations.
#'SHA of the paper PDF.}
#'\item{paragraph}{Index of the paragraph within the paper (1,2,3)}
#'\item{start}{Index within the text where this citation starts}
#'\item{end}{Index within the text where this citation ends}
#'\item{text}{Text of the citation (usually a number, or a number with parentheses)}
#'\item{ref_id}{Reference OD, can be used to join to \code{\link{cord19_paper_citations}}}
#'}
#'
#' @seealso  | url{https:/www.kaggle.com/allen-institute-for-ai/CORD-19-research-challenge}
#' "cord19_paragraph_citations"
#'
