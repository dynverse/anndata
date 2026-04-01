#' @title read_excel
#'
#' @description
#' `r lifecycle::badge('superseded')`
#' Read `.xlsx` (Excel) file.
#'
#' @section Superseded:
#' This function is superseded. Please use [anndataR](https://anndataR.scverse.org)
#' for reading and working with `AnnData` objects in R.
#' See `vignette("migration_to_anndataR", package = "anndata")` for migration guidance.
#'
#' @details Assumes that the first columns stores the row names and the first row the
#' column names.
#'
#' @param filename File name to read from.
#' @param sheet Name of sheet in Excel file.
#' @param dtype Numpy data type.
#'
#' @export
#'
#' @examples
#' \dontrun{
#' ad <- read_excel("spreadsheet.xls")
#' }
read_excel <- function(filename, sheet, dtype = "float32") {
  python_anndata <- reticulate::import("anndata", convert = FALSE)
  filename <- normalizePath(filename, mustWork = FALSE)
  py_to_r_ifneedbe(python_anndata$read_excel(
    filename = filename,
    sheet = sheet,
    dtype = dtype
  ))
}
