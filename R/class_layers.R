#' Create a Layers object
#'
#' @rdname Layers
#'
#' @param parent An AnnData object.
#' @param vals A named list of matrices with the same dimensions as `parent`.
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
#'   )
#' )
#' ad$layers["spliced"]
#' ad$layers["test"] <- matrix(c(1, 3, 5, 7), nrow = 2)
#'
#' length(ad$layers)
#' names(ad$layers)
#' }
Layers <- function(
  parent,
  vals = NULL
) {
  python_anndata <- reticulate::import("anndata", convert = FALSE)

  obj <- python_anndata$Layers(
    parent = parent,
    vals = vals
  )

  LayersR6$new(obj)
}

#' @rdname Layers
#'
#' @importFrom R6 R6Class
#' @export
LayersR6 <- R6::R6Class(
  "LayersR6",
  private = list(
    .layers = NULL
  ),
  cloneable = FALSE,
  public = list(
    #' @description Create a new Layers object
    #'
    #' @param obj A Python Layers object
    initialize = function(obj) {
      private$.layers <- obj
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
      print(private$.layers, ...)
    },

    #' @description Get a layer
    #' @param name Name of the layer
    get = function(name) {
      out <- py_to_r_ifneedbe(private$.layers$get(name))
      if (!is.null(out)) {
        dimnames(out) <- dimnames(self$parent)
      }
      out
    },

    #' @description Set a layer
    #' @param name Name of the layer
    #' @param value A matrix
    set = function(name, value) {
      if (!is.null(value)) {
        invisible(private$.layers$`__setitem__`(name, value))
      } else {
        self$del(name)
      }
    },

    #' @description Delete a layer
    #' @param name Name of the layer
    del = function(name) {
      reticulate::py_del_item(private$.layers, name)
    },

    #' @description Get the names of the layers
    keys = function() {
      py_to_r_ifneedbe(private$.layers$keys())
    },

    #' @description Get the number of layers
    length = function() {
      py_to_r_ifneedbe(private$.layers$`__len__`())
    },

    #' @description Set internal Python object
    #' @param obj A Python layers object
    .set_py_object = function(obj) {
      private$.layers <- obj
    },

    #' @description Get internal Python object
    .get_py_object = function() {
      private$.layers
    }

  ),
  active = list(
    #' @field parent Reference to parent AnnData view
    parent = function() {
      py_to_r_ifneedbe(private$.layers$parent)
    }
  )
)

#' Layers Helpers
#'
#' @param x An AnnData object.
#' @param convert Not used.
#' @param name Name of the layer.
#' @param value Replacement value.
#'
#' @rdname LayersHelpers
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
#'   )
#' )
#'
#' ad$layers["spliced"]
#' ad$layers["test"] <- matrix(c(1, 3, 5, 7), nrow = 2)
#'
#' length(ad$layers)
#' names(ad$layers)
#' }
names.LayersR6 <- function(x) {
  x$keys()
}

#' @rdname LayersHelpers
#' @export
length.LayersR6 <- function(x) {
  x$length()
}

#' @rdname LayersHelpers
#' @export
r_to_py.LayersR6 <- function(x, convert = FALSE) {
  x$.get_py_object()
}

#' @rdname LayersHelpers
#' @export
py_to_r.anndata._core.aligned_mapping.LayersBase <- function(x) {
  LayersR6$new(x)
}

#' @rdname LayersHelpers
#' @export
`[.LayersR6` <- function(x, name) {
  x$get(name)
}

#' @rdname LayersHelpers
#' @export
`[<-.LayersR6` <- function(x, name, value) {
  x$set(name, value)
  x
}

#' @rdname LayersHelpers
#' @export
`[[.LayersR6` <- `[.LayersR6`

#' @rdname LayersHelpers
#' @export
`[[<-.LayersR6` <- `[<-.LayersR6`


#' @rdname all.equal
#' @export
all.equal.LayersR6 <- function(target, current, ...) {
  a <- target
  b <- current

  if (!inherits(b, "LayersR6")) {
    return("Not a Layers object")
  }

  a_names <- names(a)
  b_names <- names(b)

  match <-
    aecheck(a_names, b_names, "names(.)", ...)

  for (nm in intersect(a_names, b_names)) {
    match <- match %&%
      aecheck(a[nm], b[nm], nm, ...)
  }

  match
}
