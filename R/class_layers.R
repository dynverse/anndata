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
  LayersR6$new(
    parent = parent
  )
}

#' @rdname AnnData
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
    #' @param parent An AnnData object.
    #' @param vals A named list of matrices with the same dimensions as `parent`.
    #'
    #' @examples
    #' \dontrun{
    #' # use Layers() instead of LayersR6$new()
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
    #' ad$layers["spliced"]
    #' ad$layers["test"] <- matrix(c(1, 3, 5, 7), nrow = 2)
    #'
    #' length(ad$layers)
    #' names(ad$layers)
    #' }
    initialize = function(
      parent,
      vals = NULL
    ) {
      if (!identical(parent, "DUMMY")) {
        python_anndata <- reticulate::import("anndata", convert = FALSE)

        private$.layers <- python_anndata$Layers(
          parent = parent,
          vals = vals
        )
      }
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
    }
  ),
  active = list(
    #' @field parent The parent AnnData of this object.
    parent = function() {
      py_to_r(private$.layers$parent)
    }
  )
)

#' AnnData Helpers
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
  py_to_r(x$.__enclos_env__$private$.layers$keys())
}

#' @rdname LayersHelpers
#' @export
length.LayersR6 <- function(x) {
  py_to_r(x$.__enclos_env__$private$.layers$`__len__`())
}

#' @rdname LayersHelpers
#' @export
r_to_py.LayersR6 <- function(x, convert = FALSE) {
  x$.__enclos_env__$private$.layers
}

#' @rdname LayersHelpers
#' @export
py_to_r.anndata._core.aligned_mapping.Layers <- function(x) {
  ad <- Layers(parent = "DUMMY")
  ad$.__enclos_env__$private$.layers <- x
  ad
}

#' @rdname LayersHelpers
#' @export
`[.LayersR6` <- function(x, name) {
  out <- py_to_r(x$.__enclos_env__$private$.layers$get(name))
  if (!is.null(out)) {
    dimnames(out) <- dimnames(x$parent)
  }
  out
}

#' @rdname LayersHelpers
#' @export
`[<-.LayersR6` <- function(x, name, value) {
  if (!is.null(value)) {
    x$.__enclos_env__$private$.layers$`__setitem__`(name, value)
  } else {
    reticulate::py_del_item(x$.__enclos_env__$private$.layers, name)
  }
  x
}

#' @rdname LayersHelpers
#' @export
`[[.LayersR6` <- `[.LayersR6`

#' @rdname LayersHelpers
#' @export
`[[<-.LayersR6` <- `[<-.LayersR6`


#' Test if two LayersR6 objects are equal
#' @inheritParams base::all.equal
#' @export
all.equal.LayersR6 <- function(target, current) {
  a <- target
  b <- current

  if (!is(b, "LayersR6")) {
    return("Not a Layers object")
  }

  a_names <- names(a)
  b_names <- names(b)

  match <-
    aecheck(a_names, b_names, "names(.)")

  for (nm in intersect(a_names, b_names)) {
    match <- match %&%
      aecheck(a[nm], b[nm], nm)
  }

  match
}
