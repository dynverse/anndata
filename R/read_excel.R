#' @title read_excel
#'
#' @description Read `.xlsx` (Excel) file.
#'
#' @details Assumes that the first columns stores the row names and the first row the
#' column names.
#'
#' @param filename File name to read from.
#' @param sheet Name of sheet in Excel file.
#' @param dtype Numpy data type.
#'
#' @export
read_excel <- function(filename, sheet, dtype = "float32") {
  python_anndata$read_excel(
    filename = filename,
    sheet = sheet,
    dtype = dtype
  )
}
