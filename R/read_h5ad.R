#' @title read_h5ad
#'
#' @description Read `.h5ad`-formatted hdf5 file.
#'
#' @param filename File name of data file.
#' @param backed If `'r'`, load `~anndata.AnnData` in `backed` mode instead of fully loading it into memory (`memory` mode). If you want to modify backed attributes of the AnnData object, you need to choose `'r+'`.
#' @param as_sparse If an array was saved as dense, passing its name here will read it as a sparse_matrix, by chunk of size `chunk_size`.
#'
#' @export
#'
#' @examples
#' ad <- read_h5ad("example_formats/pbmc_1k_protein_v3_processed.h5ad")
read_h5ad <- function(
  filename,
  backed = NULL
) {
  python_anndata$read_h5ad(
    filename = filename,
    backed = backed
  )
}
