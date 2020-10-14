#' @title read_mtx
#'
#' @description Read `.mtx` file.
#'
#' @param filename The filename.
#' @param dtype Numpy data type.
#'
#' @export
read_mtx <- function(filename, dtype = "float32") {
  python_anndata$read_mtx(
    filename = filename,
    dtype = dtype
  )
}
