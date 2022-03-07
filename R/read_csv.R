#' @title read_csv
#'
#' @description Read `.csv` file.
#'
#' @details Same as [read_text()] but with default delimiter `','`.
#'
#' @param filename Data file.
#' @param delimiter Delimiter that separates data within text file. If `NULL`, will split at arbitrary number of white spaces, which is different from enforcing splitting at single white space `' '`.
#' @param first_column_names Assume the first column stores row names.
#' @param dtype Numpy data type.
#'
#' @export
#'
#' @examples
#' \dontrun{
#' ad <- read_csv("matrix.csv")
#' }
read_csv <- function(filename, delimiter = ",", first_column_names = NULL, dtype = "float32") {
  python_anndata <- reticulate::import("anndata", convert = FALSE)
  py_to_r_ifneedbe(python_anndata$read_csv(
    filename = filename,
    delimiter = delimiter,
    first_column_names = first_column_names,
    dtype = dtype
  ))
}
