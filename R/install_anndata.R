#' Install anndata
#'
#' Needs to be run after installing the anndata R package.
#'
#' @inheritParams reticulate::py_install
#'
#' @export
install_anndata <- function(method = "auto", conda = "auto") {
  reticulate::py_install("anndata", method = method, conda = conda)
}
