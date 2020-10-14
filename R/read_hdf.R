#' @title read_hdf
#'
#' @description Read `.h5` (hdf5) file.
#'
#' @details Note: Also looks for fields `row_names` and `col_names`.
#'
#' @param filename Filename of data file.
#' @param key Name of dataset in the file.
#'
#' @export
read_hdf <- function(filename, key) {
  python_anndata$read_hdf(
    filename = filename,
    key = key
  )
}
