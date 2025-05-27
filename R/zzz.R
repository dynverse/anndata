# Based on https://rstudio.github.io/reticulate/articles/package.html
.onLoad <- function(libname, pkgname) {
  reticulate::py_require("anndata")
}
