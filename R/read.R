#' @title read
#'
#' @description Read `.h5ad`-formatted hdf5 file.
#'
#' @details Parameters
#' ----------
#' filename File name of data file.
#' backed If `'r'`, load `~anndata.AnnData` in `backed` mode instead of fully loading it into memory (`memory` mode). If you want to modify backed attributes of the AnnData object, you need to choose `'r+'`.
#' as_sparse If an array was saved as dense, passing its name here will read it as a sparse_matrix, by chunk of size `chunk_size`.
#' as_sparse_fmt Sparse format class to read elements from `as_sparse` in as.
#' chunk_size Used only when loading sparse dataset that is stored as dense. Loading iterates through chunks of the dataset of this row size until it reads the whole dataset. Higher size means higher memory consumption and higher (to a point) loading speed.
#'
#' @param filename filename
#' @param backed backed
#'
#' @export
read <- function(filename, backed = NULL) {
  python_function_result <- python_anndata$read(
    filename = filename,
    backed = backed
  )
}
