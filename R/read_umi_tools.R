#' @title read_umi_tools
#'
#' @description Read a gzipped condensed count matrix from umi_tools.
#'
#' @param filename File name to read from.
#' @param dtype Numpy data type.
#'
#' @export
#'
#' @examples
#' \dontrun{
#' ad <- read_umi_tools("...")
#' }
read_umi_tools <- function(filename, dtype = "float32") {
  python_anndata <- reticulate::import("anndata", convert = FALSE)
  filename <- normalizePath(filename, mustWork = FALSE)
  py_to_r_ifneedbe(python_anndata$read_umi_tools(
    filename = filename,
    dtype = dtype
  ))
}
