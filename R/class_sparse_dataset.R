
#' @rdname SparseDataset
#'
#' @importFrom R6 R6Class
#' @export
SparseDatasetR6 <- R6::R6Class(
  "SparseDatasetR6",
  private = list(
    .self = NULL
  ),
  cloneable = FALSE,
  public = list(
    #' @param obj A Python SparseDataset object
    initialize = function(obj) {
      private$.self <- obj
    },

    #' @description Print Layers object
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
    #'   )
    #' )
    #'
    #' print(ad$layers)
    #' }
    print = function(...) {
      print(private$.self, ...)
    },

    #' @description Set internal Python object
    #' @param obj A python anndata object
    .set_py_object = function(obj) {
      private$.self <- obj
    },

    #' @description Get internal Python object
    .get_py_object = function() {
      private$.self
    }
  ),
  active = list(
    #' @field dtype dtype
    dtype = function() {
      py_to_r_ifneedbe(private$.self$dtype)
    },

    format_str = function() {
      py_to_r_ifneedbe(private$.self$format_str)
    },

    group = function() {
      py_to_r_ifneedbe(private$.self$group)
    },

    name = function() {
      py_to_r_ifneedbe(private$.self$name)
    },

    file = function() {
      # TODO: don't convert this yet, needs to be wrapped first
      private$.self$file
    },

    shape = function() {
      unlist(py_to_r_ifneedbe(private$.self$shape))
    },

    value = function() {
      # TODO: add dimnames ?
      py_to_r_ifneedbe(private$.self$value)
    }
  )
)

#' SparseDataset Helpers
#'
#' @param x A SparseDataset object.
#' @param convert Not used.
#' @param ... Parameters passed to the underlying function.
#'
#' @rdname SparseDatasetHelpers
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
#'
#' dimnames(ad)
#' dim(ad)
#' as.data.frame(ad)
#' as.data.frame(ad, layer = "unspliced")
#' as.matrix(ad)
#' as.matrix(ad, layer = "unspliced")
#' ad[2,,drop=FALSE]
#' ad[,-1]
#' ad[,c("var1", "var2")]
#' }
dimnames.SparseDatasetR6 <- function(x) {
  # warning("dimnames on SparseDatasets are not supported yet")
  list()
  # list(
  #   x$obs_names,
  #   x$var_names
  # )
}

#' @rdname SparseDatasetHelpers
#' @export
`dimnames<-.SparseDatasetR6` <- function(x, value) {
  # warning("dimnames on SparseDatasets are not supported yet")
  # d <- dim(x)
  # if (!is.list(value) || length(value) != 2L)
  #   stop("invalid 'dimnames' given for AnnData")
  # # value[[1L]] <- as.character(value[[1L]])
  # # value[[2L]] <- as.character(value[[2L]])
  # if (d[[1L]] != length(value[[1L]]) || d[[2L]] != length(value[[2L]]))
  #   stop("invalid 'dimnames' given for AnnData")
  # x$obs_names <- value[[1L]]
  # x$var_names <- value[[2L]]
  x
}

#' @rdname SparseDatasetHelpers
#' @export
dim.SparseDatasetR6 <- function(x) {
  x$shape
}

#' @rdname SparseDatasetHelpers
#' @export
r_to_py.SparseDatasetR6 <- function(x, convert = FALSE) {
  x$.get_py_object()
}

#' @rdname SparseDatasetHelpers
#' @export
py_to_r.anndata._core.sparse_dataset.SparseDataset <- function(x) {
  SparseDatasetR6$new(x)
}

#' @rdname SparseDatasetHelpers
#' @importFrom reticulate tuple
#' @param oidx Observation indices
#' @param vidx Variable indices
#' @export
`[.SparseDatasetR6` <- function(x, oidx, vidx) {
  # ad$X[1:3,c("ERI3","UQCRH" )]
  oidx <- .process_index(oidx, nrow(x))
  vidx <- .process_index(vidx, ncol(x))
  tup <- reticulate::tuple(oidx, vidx)
  py_to_r_ifneedbe(x$.get_py_object()$`__getitem__`(tup))
}

#' @rdname SparseDatasetHelpers
#' @export
`[[.SparseDatasetR6` <- `[.SparseDatasetR6`

