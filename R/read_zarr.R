#' Read from a hierarchical Zarr array store.
#'
#' `r lifecycle::badge('superseded')`
#'
#' @section Superseded:
#' This function is superseded. Please use [anndataR](https://anndataR.scverse.org)
#' for reading and working with `AnnData` objects in R.
#' See `vignette("migration_to_anndataR", package = "anndata")` for migration guidance.
#'
#' @param store The filename, a MutableMapping, or a Zarr storage class.
#'
#' @export
#'
#' @examples
#' \dontrun{
#' ad <- read_zarr("...")
#' }
read_zarr <- function(store) {
  read_zarr(
    store = store
  )
}
