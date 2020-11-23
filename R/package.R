#' anndata - Annotated Data
#'
#' `anndata` provides a scalable way of keeping track of data
#' and learned annotations, and can be used to read from and write to the h5ad
#' file format. `AnnData()` stores a data matrix `X` together with annotations
#' of observations `obs` (`obsm`, `obsp`), variables `var` (`varm`, `varp`),
#' and unstructured annotations `uns`.
#'
#' This package is, in essense, an R wrapper for the similarly named Python package
#' [`anndata`](https://anndata.readthedocs.io/en/latest/), with some added functionality
#' to support more R-like syntax.
#' The version number of the anndata R package is synced
#' with the version number of the python version.
#'
#' Check out `?anndata` for a full list of the functions provided by this package.
#'
#' @name anndata-package
#' @aliases anndata-package anndata
#' @docType package
#'
#' @importFrom reticulate py_module_available import import_builtins r_to_py py_to_r py_del_item py_del_attr py_get_item py_set_item
#' @importFrom assertthat assert_that
#'
#' @section Creating an AnnData object:
#'
#' * [AnnData()]
#'
#' @section Concatenating two or more AnnData objects:
#'
#' * [concat()]
#'
#' @section Reading an AnnData object from a file:
#'
#' * [read_csv()]
#' * [read_excel()]
#' * [read_h5ad()]
#' * [read_hdf()]
#' * [read_loom()]
#' * [read_mtx()]
#' * [read_text()]
#' * [read_umi_tools()]
#'
#' @section Writing an AnnData object to a file:
#'
#' * [write_csvs()]
#' * [write_h5ad()]
#' * [write_loom()]
#'
#' @section Install the `anndata` Python package:
#'
#' * [install_anndata()]
#'
#'
#' @examples
#' \dontrun{
#' ad <- AnnData(
#'   X = matrix(1:6, nrow = 2),
#'   obs = data.frame(group = c("a", "b"), row.names = c("s1", "s2")),
#'   var = data.frame(type = c(1L, 2L, 3L), row.names = c("var1", "var2", "var3")),
#'   layers = list(
#'     spliced = matrix(4:9, nrow = 2),
#'     unspliced = matrix(8:13, nrow = 2)
#'   ),
#'   obsm = list(
#'     ones = matrix(rep(1L, 10), nrow = 2),
#'     rand = matrix(rnorm(6), nrow = 2),
#'     zeros = matrix(rep(0L, 10), nrow = 2)
#'   ),
#'   varm = list(
#'     ones = matrix(rep(1L, 12), nrow = 3),
#'     rand = matrix(rnorm(6), nrow = 3),
#'     zeros = matrix(rep(0L, 12), nrow = 3)
#'   ),
#'   uns = list(
#'     a = 1,
#'     b = data.frame(i = 1:3, j = 4:6, value = runif(3)),
#'     c = list(c.a = 3, c.b = 4)
#'   )
#' )
#'
#' ad$X
#'
#' ad$obs
#' ad$var
#'
#' ad$obsm["ones"]
#' ad$varm["rand"]
#'
#' ad$layers["unspliced"]
#' ad$layers["spliced"]
#'
#' ad$uns["b"]
#'
#' ad[,c("var1", "var2")]
#' ad[-1, , drop = FALSE]
#' ad[, 2] <- 10
#' }
NULL
