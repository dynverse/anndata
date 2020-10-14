#' @title read_loom
#'
#' @description Read `.loom`-formatted hdf5 file.
#'
#' @details This reads the whole file into memory. Beware that you have to explicitly state when you want to read the file as
#' sparse data. Parameters
#' ----------
#' filename The filename.
#' sparse Whether to read the data matrix as sparse.
#' cleanup Whether to collapse all obs/var fields that only store one unique value into `.uns['loom-.']`.
#' X_name Loompy key with which the data matrix `~anndata.AnnData.X` is initialized.
#' obs_names Loompy key where the observation/cell names are stored.
#' obsm_names Loompy keys which will be constructed into observation matrices
#' var_names Loompy key where the variable/gene names are stored.
#' obsm_names Loompy keys which will be constructed into variable matrices
#' **kwargs: Arguments to loompy.connect
#'
#' @param filename filename
#' @param sparse sparse
#' @param cleanup cleanup
#' @param X_name X_name
#' @param obs_names obs_names
#' @param obsm_names obsm_names
#' @param var_names var_names
#' @param varm_names varm_names
#' @param dtype dtype
#'
#' @export
read_loom <- function(filename, sparse = TRUE, cleanup = FALSE, X_name = "spliced", obs_names = "CellID", obsm_names = NULL, var_names = "Gene", varm_names = NULL, dtype = "float32") {
  python_function_result <- python_anndata$read_loom(
    filename = filename,
    sparse = sparse,
    cleanup = cleanup,
    X_name = X_name,
    obs_names = obs_names,
    obsm_names = obsm_names,
    var_names = var_names,
    varm_names = varm_names,
    dtype = dtype
  )
}
