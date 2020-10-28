#' @title read_mtx
#'
#' @description Read `.mtx` file.
#'
#' @param filename The filename.
#' @param dtype Numpy data type.
#'
#' @export
#'
#' @examples
#' \dontrun{
#' ad <- read_mtx("matrix.mtx")
#' }
read_mtx <- function(filename, dtype = "float32") {
  python_anndata <- reticulate::import("anndata")
  ad <- AnnData()
  ad$.__enclos_env__$private$.anndata <- python_anndata$read_mtx(
    filename = filename,
    dtype = dtype
  )
  ad
}
