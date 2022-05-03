#' @title read_h5ad
#'
#' @description Read `.h5ad`-formatted hdf5 file.
#'
#' @param filename File name of data file.
#' @param backed If `'r'`, load `~anndata.AnnData` in `backed` mode instead of fully loading it into memory (`memory` mode). If you want to modify backed attributes of the AnnData object, you need to choose `'r+'`.
#'
#' @export
#'
#' @examples
#' \dontrun{
#' ad <- read_h5ad("example_formats/pbmc_1k_protein_v3_processed.h5ad")
#' }
read_h5ad <- function(
  filename,
  backed = NULL
) {
  python_anndata <- reticulate::import("anndata", convert = FALSE)
  filename <- normalizePath(filename, mustWork = FALSE)
  py_to_r_ifneedbe(python_anndata$read_h5ad(
    filename = filename,
    backed = backed
  ))
}
