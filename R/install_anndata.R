#' Install anndata
#'
#' Needs to be run after installing the anndata R package.
#'
#' @inheritParams reticulate::py_install
#'
#' @export
#'
#' @examples
#' \dontrun{
#' reticulate::conda_install()
#' install_anndata()
#' }
install_anndata <- function(method = "auto", conda = "auto") {
  reticulate::py_install("anndata>=0.7.4", method = method, conda = conda)
}
