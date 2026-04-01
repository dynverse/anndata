#' @title read_mtx
#'
#' @description
#' `r lifecycle::badge('superseded')`
#' Read `.mtx` file.
#'
#' @section Superseded:
#' This function is superseded. Please use [anndataR](https://anndataR.scverse.org)
#' for reading and working with `AnnData` objects in R.
#' See `vignette("migration_to_anndataR", package = "anndata")` for migration guidance.
#'
#' @param filename The filename.
#' @param dtype Numpy data type.
#'
#' @export
#'
#' @examples
#' \dontrun{
#' ad <- read_mtx("matrix.mtx")
#' }
read_mtx <- function(filename, dtype = "float32") {
  python_anndata <- reticulate::import("anndata", convert = FALSE)
  filename <- normalizePath(filename, mustWork = FALSE)
  py_to_r_ifneedbe(python_anndata$read_mtx(
    filename = filename,
    dtype = dtype
  ))
}
