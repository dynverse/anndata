#' @title read_mtx
#'
#' @description Read `.mtx` file.
#'
#' @details Parameters
#' ----------
#' filename The filename.
#' dtype Numpy data type.
#'
#' @param filename filename
#' @param dtype dtype
#'
#' @export
read_mtx <- function(filename, dtype = "float32") {
  python_function_result <- python_anndata$read_mtx(
    filename = filename,
    dtype = dtype
  )
}
