#' @title read_text
#'
#' @description Read `.txt`, `.tab`, `.data` (text) file.
#'
#' @details Same as [read_csv()] but with default delimiter `NULL`.
#'
#' @param filename Data file, filename or stream.
#' @param delimiter Delimiter that separates data within text file.
#'   If `NULL`, will split at arbitrary number of white spaces, which is different
#'    from enforcing splitting at single white space `' '`.
#' @param first_column_names Assume the first column stores row names.
#' @param dtype Numpy data type.
#'
#' @export
#'
#' @examples
#' \dontrun{
#' ad <- read_text("matrix.tab")
#' }
read_text <- function(filename, delimiter = NULL, first_column_names = NULL, dtype = "float32") {
  python_anndata <- reticulate::import("anndata", convert = FALSE)
  py_to_r(python_anndata$read_text(
    filename = filename,
    delimiter = delimiter,
    first_column_names = first_column_names,
    dtype = dtype
  ))
}
