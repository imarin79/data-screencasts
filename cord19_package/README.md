
# cord19


<!-- badges: start -->
<!-- badges: end -->

The goal of cord19 is to share the COVID-19 Open Research Dataset in a form that is easily analized within R in a tidy form.

## Installation

You can install the released version of cord19 from [CRAN](https://CRAN.R-project.org) with:

``` r
remote::install_github("dgrtwo/cord19")
```

## Example

The package includes datasets around the CORD-19 papers. The paper metadata is stored in `cord19_papers`

``` r
library(cord19)

cord19_papers

# Learn how many papers came from each journal:
cord19_papers %>% 
count(journal, sort=TRUE)

## basic example code
```

#Most usefully, it has the full text of the papers, along with which in `cord19_paragraphs`

```{r}
cord19_paragraphs

```

This allows for some mining with a package like tidytext

```{r}
library(tidytext)

cord19_paragraphs %>% 
                 sample_n(1000) %>% 
                 unnest_tokens(word, text) %>% 
                 count(word, sort=TRUE) %>% 
                 anti_join(stop_words, by = "word")

```

### Citations

This also includes the articles cited by each paper.
```{r}
# What are the most commonly cited articles?

cord19_paper_citations %>% 
count(title, sort=TRUE)

```
