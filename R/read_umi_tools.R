#' @title read_umi_tools
#'
#' @description Read a gzipped condensed count matrix from umi_tools.
#'
#' @param filename File name to read from.
#' @param dtype Numpy data type.
#'
#' @export
read_umi_tools <- function(filename, dtype = "float32") {
  python_anndata$read_umi_tools(
    filename = filename,
    dtype = dtype
  )
}
