#' anndata - Annotated Data
#'
#' An R wrapper for the Python package
#' [`theislab/anndata@58886f`](https://github.com/theislab/anndata/tree/58886f09b2e387c6389a2de20ed0bc7d20d1b843).
#' Provides a scalable way of keeping track of data
#' and learned annotations.
#' Used to read from and write to the h5ad file format.
#'
#' @name anndata-package
#' @aliases anndata-package anndata
#' @docType package
#'
#' @importFrom reticulate py_module_available import import_builtins r_to_py py_to_r py_del_item py_get_item py_set_item
#' @importFrom assertthat assert_that
#'
#' @examples
#' \dontrun{
#' ad <- AnnData(
#'   X = matrix(c(0, 1, 2, 3), nrow = 2, byrow = TRUE),
#'   obs = data.frame(group = c("a", "b"), row.names = c("s1", "s2")),
#'   var = data.frame(type = c(1L, 2L), row.names = c("var1", "var2")),
#'   layers = list(
#'     spliced = matrix(c(4, 5, 6, 7), nrow = 2, byrow = TRUE),
#'     unspliced = matrix(c(8, 9, 10, 11), nrow = 2, byrow = TRUE)
#'   ),
#'   varm = list(
#'     ones = matrix(rep(1L, 10), nrow = 2),
#'     rand = matrix(rnorm(6), nrow = 2),
#'     zeros = matrix(rep(0L, 10), nrow = 2)
#'   ),
#'   uns = list(a = 1, b = 2, c = list(c.a = 3, c.b = 4))
#' )
#'
#' value <- matrix(c(1,2,3,4), nrow = 2)
#' ad$X
#' ad$X <- value
#' ad$X
#'
#' ad$layers
#' ad$layers["spliced"]
#' ad$layers["test"] <- value
#' ad$layers
#'
#' ad$to_df()
#' ad$uns
#' }
NULL

# global reference to umap (will be initialized in .onLoad)
python_anndata <- NULL
python_builtins <- NULL
.onLoad <- function(libname, pkgname) {
  try(
    {
      python_anndata <<- reticulate::import("anndata", delay_load = TRUE)
      python_builtins <<- reticulate::import_builtins()
    },
    silent = TRUE
  )
}
