#' @title Raw
#'
#' @description
#'
#' @details
#'
#' @param adata adata
#' @param X X
#' @param var var
#' @param varm varm
#'
#' @export
Raw <- function(adata, X = NULL, var = NULL, varm = NULL) {
  python_function_result <- python_anndata$Raw(
    adata = adata,
    X = X,
    var = var,
    varm = varm
  )
}
