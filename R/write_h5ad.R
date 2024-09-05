#' Write .h5ad-formatted hdf5 file.
#'
#' Generally, if you have sparse data that are stored as a dense matrix, you can
#' dramatically improve performance and reduce disk space by converting to a csr_matrix:
#'
#' @param anndata An [AnnData()] object
#' @param filename Filename of data file. Defaults to backing file.
#' @param compression See the h5py [filter pipeline](http://docs.h5py.org/en/latest/high/dataset.html#dataset-compression).
#'   Options are `"gzip"`, `"lzf"` or `NULL`.
#' @param compression_opts See the h5py [filter pipeline](http://docs.h5py.org/en/latest/high/dataset.html#dataset-compression).
#' @param as_dense Sparse in AnnData object to write as dense. Currently only supports `"X"` and `"raw/X"`.
#'
#' @export
#'
#' @examples
#' \dontrun{
#' ad <- AnnData(
#'   X = matrix(c(0, 1, 2, 3), nrow = 2, byrow = TRUE),
#'   obs = data.frame(group = c("a", "b"), row.names = c("s1", "s2")),
#'   var = data.frame(type = c(1L, 2L), row.names = c("var1", "var2")),
#'   varm = list(
#'     ones = matrix(rep(1L, 10), nrow = 2),
#'     rand = matrix(rnorm(6), nrow = 2),
#'     zeros = matrix(rep(0L, 10), nrow = 2)
#'   ),
#'   uns = list(a = 1, b = 2, c = list(c.a = 3, c.b = 4))
#' )
#'
#' write_h5ad(ad, "output.h5ad")
#'
#' file.remove("output.h5ad")
#' }
write_h5ad <- function(anndata, filename, compression = NULL, compression_opts = NULL, as_dense = list()) {
  invisible(py_to_r_ifneedbe(anndata$write_h5ad(
    filename = filename,
    compression = compression,
    compression_opts = compression_opts,
    as_dense = as_dense
  )))
}
