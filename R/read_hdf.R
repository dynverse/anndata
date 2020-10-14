#' @title read_hdf
#'
#' @description Read `.h5` (hdf5) file.
#'
#' @details Note: Also looks for fields `row_names` and `col_names`. Parameters
#' ----------
#' filename Filename of data file.
#' key Name of dataset in the file.
#'
#' @param filename filename
#' @param key key
#'
#' @export
read_hdf <- function(filename, key) {
  python_function_result <- python_anndata$read_hdf(
    filename = filename,
    key = key
  )
}
