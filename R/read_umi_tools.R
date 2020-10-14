#' @title read_umi_tools
#'
#' @description Read a gzipped condensed count matrix from umi_tools.
#'
#' @details Parameters
#' ----------
#' filename File name to read from.
#'
#' @param filename filename
#' @param dtype dtype
#'
#' @export
read_umi_tools <- function(filename, dtype = "float32") {
  python_function_result <- python_anndata$read_umi_tools(
    filename = filename,
    dtype = dtype
  )
}
