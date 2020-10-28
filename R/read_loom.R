#' @title read_loom
#'
#' @description Read `.loom`-formatted hdf5 file.
#'
#' @details This reads the whole file into memory. Beware that you have to explicitly state when you want to read the file as
#' sparse data.
#'
#' @param filename The filename.
#' @param sparse Whether to read the data matrix as sparse.
#' @param cleanup Whether to collapse all obs/var fields that only store one unique value into `.uns['loom-.']`.
#' @param X_name Loompy key with which the data matrix `AnnData.X` is initialized.
#' @param obs_names Loompy key where the observation/cell names are stored.
#' @param obsm_names Loompy keys which will be constructed into observation matrices
#' @param var_names Loompy key where the variable/gene names are stored.
#' @param varm_names Loompy keys which will be constructed into variable matrices
#' @param dtype Numpy data type.
#' @param ... Arguments to loompy.connect
#'
#' @export
#'
#' @examples
#' \dontrun{
#' ad <- read_loom("dataset.loom")
#' }
read_loom <- function(
  filename,
  sparse = TRUE,
  cleanup = FALSE,
  X_name = "spliced",
  obs_names = "CellID",
  obsm_names = NULL,
  var_names = "Gene",
  varm_names = NULL,
  dtype = "float32",
  ...
) {
  python_anndata <- reticulate::import("anndata")
  ad <- AnnData()
  ad$.__enclos_env__$private$.anndata <- python_anndata$read_loom(
    filename = filename,
    sparse = sparse,
    cleanup = cleanup,
    X_name = X_name,
    obs_names = obs_names,
    obsm_names = obsm_names,
    var_names = var_names,
    varm_names = varm_names,
    dtype = dtype,
    ...
  )
  ad
}
