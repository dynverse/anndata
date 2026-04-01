#' @title read_umi_tools
#'
#' @description
#' `r lifecycle::badge('superseded')`
#' Read a gzipped condensed count matrix from umi_tools.
#'
#' @section Superseded:
#' This function is superseded. Please use [anndataR](https://anndataR.scverse.org)
#' for reading and working with `AnnData` objects in R.
#' See `vignette("migration_to_anndataR", package = "anndata")` for migration guidance.
#'
#' @param filename File name to read from.
#' @param dtype Numpy data type.
#'
#' @export
#'
#' @examples
#' \dontrun{
#' ad <- read_umi_tools("...")
#' }
read_umi_tools <- function(filename, dtype = "float32") {
  python_anndata <- reticulate::import("anndata", convert = FALSE)
  filename <- normalizePath(filename, mustWork = FALSE)
  py_to_r_ifneedbe(python_anndata$read_umi_tools(
    filename = filename,
    dtype = dtype
  ))
}
