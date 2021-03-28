#' Create a Raw object
#'
#' @rdname AnnData
#'
#' @param adata An AnnData object.
#' @param X A #observations × #variables data matrix.
#' @param var Key-indexed one-dimensional variables annotation of length #variables.
#' @param varm Key-indexed multi-dimensional variables annotation of length #variables.
#'
#' @export
#'
#' @examples
#' \dontrun{
#' ad <- AnnData(
#'   X = matrix(c(0, 1, 2, 3), nrow = 2),
#'   obs = data.frame(group = c("a", "b"), row.names = c("s1", "s2")),
#'   var = data.frame(type = c(1L, 2L), row.names = c("var1", "var2")),
#'   layers = list(
#'     spliced = matrix(c(4, 5, 6, 7), nrow = 2),
#'     unspliced = matrix(c(8, 9, 10, 11), nrow = 2)
#'   ),
#'   obsm = list(
#'     ones = matrix(rep(1L, 10), nrow = 2),
#'     rand = matrix(rnorm(6), nrow = 2),
#'     zeros = matrix(rep(0L, 10), nrow = 2)
#'   ),
#'   varm = list(
#'     ones = matrix(rep(1L, 10), nrow = 2),
#'     rand = matrix(rnorm(6), nrow = 2),
#'     zeros = matrix(rep(0L, 10), nrow = 2)
#'   ),
#'   uns = list(a = 1, b = 2, c = list(c.a = 3, c.b = 4))
#' )
#' ad$raw <- ad
#'
#' library(reticulate)
#' sc <- import("scanpy")
#' sc$pp$normalize_per_cell(ad)
#'
#' ad[]
#' ad$raw[]
#' }
Raw <- function(
  adata,
  X = NULL,
  var = NULL,
  varm = NULL
) {
  python_anndata <- reticulate::import("anndata", convert = FALSE)

  raw <- python_anndata$Raw(
    adata = adata,
    X = X,
    var = var,
    varm = varm
  )

  RawR6$new(raw)
}

#' @rdname AnnData
#'
#' @importFrom R6 R6Class
#' @export
RawR6 <- R6::R6Class(
  "RawR6",
  private = list(
    .raw = NULL
  ),
  cloneable = FALSE,
  public = list(
    #' @description Create a new Raw object
    #' @param obj A Python Raw object
    initialize = function(obj) {
      private$.raw <- obj
    },

    #' @description Full copy, optionally on disk.
    #'
    #' @param filename Path to filename (default: `NULL`).
    #'
    #' @examples
    #' \dontrun{
    #' ad <- AnnData(
    #'   X = matrix(c(0, 1, 2, 3), nrow = 2)
    #' )
    #' ad$copy()
    #' ad$copy("file.h5ad")
    #' }
    copy = function() {
      py_to_r_ifneedbe(private$.raw$copy())
    },

    #' @description Create a full AnnData object
    #'
    #' @examples
    #' \dontrun{
    #' ad <- AnnData(
    #'   X = matrix(c(0, 1, 2, 3), nrow = 2),
    #'   obs = data.frame(group = c("a", "b"), row.names = c("s1", "s2")),
    #'   var = data.frame(type = c(1L, 2L), row.names = c("var1", "var2")),
    #'   layers = list(
    #'     spliced = matrix(c(4, 5, 6, 7), nrow = 2),
    #'     unspliced = matrix(c(8, 9, 10, 11), nrow = 2)
    #'   )
    #' )
    #' ad$raw <- ad
    #'
    #' ad$raw$to_adata()
    #' }
    to_adata = function() {
      py_to_r_ifneedbe(private$.raw$to_adata())
    },

    #' @description Print Raw object
    #' @param ... optional arguments to print method.
    #'
    #' @examples
    #' \dontrun{
    #' ad <- AnnData(
    #'   X = matrix(c(0, 1, 2, 3), nrow = 2),
    #'   obs = data.frame(group = c("a", "b"), row.names = c("s1", "s2")),
    #'   var = data.frame(type = c(1L, 2L), row.names = c("var1", "var2")),
    #'   layers = list(
    #'     spliced = matrix(c(4, 5, 6, 7), nrow = 2),
    #'     unspliced = matrix(c(8, 9, 10, 11), nrow = 2)
    #'   ),
    #'   obsm = list(
    #'     ones = matrix(rep(1L, 10), nrow = 2),
    #'     rand = matrix(rnorm(6), nrow = 2),
    #'     zeros = matrix(rep(0L, 10), nrow = 2)
    #'   ),
    #'   varm = list(
    #'     ones = matrix(rep(1L, 10), nrow = 2),
    #'     rand = matrix(rnorm(6), nrow = 2),
    #'     zeros = matrix(rep(0L, 10), nrow = 2)
    #'   ),
    #'   uns = list(a = 1, b = 2, c = list(c.a = 3, c.b = 4))
    #' )
    #' ad$raw <- ad
    #'
    #' library(reticulate)
    #' sc <- import("scanpy")
    #' sc$pp$normalize_per_cell(ad)
    #'
    #' ad[]
    #' ad$raw[]
    #'
    #' ad$print()
    #' print(ad)
    #' }
    print = function(...) {
      print(private$.raw, ...)
    },

    #' @description Set internal Python object
    #' @param obj A Python Raw object
    .set_py_object = function(obj) {
      private$.raw <- obj
    },

    #' @description Get internal Python object
    .get_py_object = function() {
      private$.raw
    }
  ),
  active = list(
    #' @field X Data matrix of shape `n_obs` × `n_vars`.
    X = function() {
        py_to_r_ifneedbe(private$.raw$X)
    },
    #' @field n_obs Number of observations.
    n_obs = function() {
      py_to_r_ifneedbe(private$.raw$n_obs)
    },
    #' @field obs_names Names of observations.
    obs_names = function(value) {
      py_to_r_ifneedbe(private$.raw$obs_names)
    },
    #' @field n_vars Number of variables.
    n_vars = function() {
      py_to_r_ifneedbe(private$.raw$n_vars)
    },
    #' @field var One-dimensional annotation of variables (data.frame).
    var = function(value) {
      py_to_r_ifneedbe(private$.raw$var)
    },
    #' @field var_names Names of variables.
    var_names = function(value) {
      py_to_r_ifneedbe(private$.raw$var_names)
    },
    #' @field varm Multi-dimensional annotation of variables (matrix).
    #'
    #' Stores for each key a two or higher-dimensional matrix with `n_var` rows.
    varm = function(value) {
      py_to_r_ifneedbe(private$.raw$varm)
    },
    #' @field shape Shape of data matrix (`n_obs`, `n_vars`).
    shape = function() {
      unlist(py_to_r_ifneedbe(private$.raw$shape))
    }
  )
)

#' Raw Helpers
#'
#' @param x An AnnData object.
#' @param convert Not used.
#' @param ... Parameters passed to the underlying function.
#'
#' @rdname RawHelpers
#' @export
#'
#' @examples
#' \dontrun{
#' ad <- AnnData(
#'   X = matrix(c(0, 1, 2, 3, 4, 5), nrow = 2),
#'   obs = data.frame(group = c("a", "b"), row.names = c("s1", "s2")),
#'   var = data.frame(type = c(1L, 2L, 3L), row.names = c("var1", "var2", "var3")),
#'   layers = list(
#'     spliced = matrix(c(4, 5, 6, 7, 8, 9), nrow = 2),
#'     unspliced = matrix(c(8, 9, 10, 11, 12, 13), nrow = 2)
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
#'   uns = list(a = 1, b = 2, c = list(c.a = 3, c.b = 4))
#' )
#' ad$raw <- ad
#'
#' dimnames(ad$raw)
#' dim(ad$raw)
#' as.matrix(ad$raw)
#' ad$raw[2,,drop=FALSE]
#' ad$raw[,-1]
#' ad$raw[,c("var1", "var2")]
#' }
dimnames.RawR6 <- function(x) {
  list(
    x$obs_names,
    x$var_names
  )
}

#' @rdname RawHelpers
#' @export
dim.RawR6 <- function(x) {
  x$shape
}

#' @rdname RawHelpers
#' @export
as.matrix.RawR6 <- function(x, ...) {
  mat <- x$X
  dimnames(mat) <- dimnames(x)
  mat
}

#' @rdname RawHelpers
#' @export
r_to_py.RawR6 <- function(x, convert = FALSE) {
  x$.get_py_object()
}

#' @rdname RawHelpers
#' @export
py_to_r.anndata._core.raw.Raw <- function(x) {
  RawR6$new(x)
}

#' @rdname RawHelpers
#' @export
`[.RawR6` <- function(x, ...) {
  as.matrix.RawR6(x)[...]
}

