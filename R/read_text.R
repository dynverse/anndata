#' @title read_text
#'
#' @description Read `.txt`, `.tab`, `.data` (text) file.
#'
#' @details Same as :func:`~anndata.read_csv` but with default delimiter `NULL`. Parameters
#' ----------
#' filename Data file, filename or stream.
#' delimiter Delimiter that separates data within text file. If `NULL`, will split at arbitrary number of white spaces, which is different from enforcing splitting at single white space `' '`.
#' first_column_names Assume the first column stores row names.
#' dtype Numpy data type.
#'
#' @param filename filename
#' @param delimiter delimiter
#' @param first_column_names first_column_names
#' @param dtype dtype
#'
#' @export
read_text <- function(filename, delimiter = NULL, first_column_names = NULL, dtype = "float32") {
  python_function_result <- python_anndata$read_text(
    filename = filename,
    delimiter = delimiter,
    first_column_names = first_column_names,
    dtype = dtype
  )
}
