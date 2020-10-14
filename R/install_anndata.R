#' @export
install_anndata <- function(method = "auto", conda = "auto") {
  reticulate::py_install("anndata", method = method, conda = conda)
}
