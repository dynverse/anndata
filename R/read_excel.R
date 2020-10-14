#' @title read_excel
#'
#' @description Read `.xlsx` (Excel) file.
#'
#' @details Assumes that the first columns stores the row names and the first row the
#' column names. Parameters
#' ----------
#' filename File name to read from.
#' sheet Name of sheet in Excel file.
#'
#' @param filename filename
#' @param sheet sheet
#' @param dtype dtype
#'
#' @export
read_excel <- function(filename, sheet, dtype = "float32") {
  python_function_result <- python_anndata$read_excel(
    filename = filename,
    sheet = sheet,
    dtype = dtype
  )
}
