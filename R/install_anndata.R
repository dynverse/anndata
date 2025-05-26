#' Install anndata
#'
#' @description
#' `r lifecycle::badge('deprecated')`
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
  lifecycle::deprecate_warn(
    "0.8.0",
    "install_anndata()",
    details = cli::format_message(
      "Using the package should automatically install the required Python packages.",
    )
  )

  reticulate::py_install("anndata>=0.7.5", method = method, conda = conda)
}
