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
#'
#' @examples
#' \dontrun{
#' ad <- read_hdf("file.h5")
#' }
read_hdf <- function(filename, key) {
  python_anndata <- reticulate::import("anndata")
  ad <- AnnData()
  ad$.__enclos_env__$private$.anndata <- python_anndata$read_hdf(
    filename = filename,
    key = key
  )
  ad
}
