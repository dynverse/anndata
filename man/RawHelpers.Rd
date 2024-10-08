% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/class_raw.R
\name{dimnames.RawR6}
\alias{dimnames.RawR6}
\alias{dim.RawR6}
\alias{as.matrix.RawR6}
\alias{r_to_py.RawR6}
\alias{py_to_r.anndata._core.raw.Raw}
\alias{[.RawR6}
\title{Raw Helpers}
\usage{
\method{dimnames}{RawR6}(x)

\method{dim}{RawR6}(x)

\method{as.matrix}{RawR6}(x, ...)

\method{r_to_py}{RawR6}(x, convert = FALSE)

\method{py_to_r}{anndata._core.raw.Raw}(x)

\method{[}{RawR6}(x, ...)
}
\arguments{
\item{x}{An AnnData object.}

\item{...}{Parameters passed to the underlying function.}

\item{convert}{Not used.}
}
\description{
Raw Helpers
}
\examples{
\dontrun{
ad <- AnnData(
  X = matrix(c(0, 1, 2, 3, 4, 5), nrow = 2),
  obs = data.frame(group = c("a", "b"), row.names = c("s1", "s2")),
  var = data.frame(type = c(1L, 2L, 3L), row.names = c("var1", "var2", "var3")),
  layers = list(
    spliced = matrix(c(4, 5, 6, 7, 8, 9), nrow = 2),
    unspliced = matrix(c(8, 9, 10, 11, 12, 13), nrow = 2)
  ),
  obsm = list(
    ones = matrix(rep(1L, 10), nrow = 2),
    rand = matrix(rnorm(6), nrow = 2),
    zeros = matrix(rep(0L, 10), nrow = 2)
  ),
  varm = list(
    ones = matrix(rep(1L, 12), nrow = 3),
    rand = matrix(rnorm(6), nrow = 3),
    zeros = matrix(rep(0L, 12), nrow = 3)
  ),
  uns = list(a = 1, b = 2, c = list(c.a = 3, c.b = 4))
)
ad$raw <- ad

dimnames(ad$raw)
dim(ad$raw)
as.matrix(ad$raw)
ad$raw[2, , drop = FALSE]
ad$raw[, -1]
ad$raw[, c("var1", "var2")]
}
}
