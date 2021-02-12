
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
      group
    ) {
      if (!identical(group, "DUMMY")) {
        # python_anndata <- reticulate::import("anndata", convert = FALSE)
        #
        # private$.self <- python_anndata$Layers(
        #   parent = parent,
        #   vals = vals
        # )
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
      print(private$.self, ...)
    }
  ),
  active = list(
    #' @field dtype dtype
    dtype = function() {
      py_to_r(private$.self$dtype)
    },

    format_str = function() {
      py_to_r(private$.self$format_str)
    },

    h5py_group = function() {
      py_to_r(private$.self$h5py_group)
    },

    name = function() {
      py_to_r(private$.self$name)
    },

    file = function() {
      # TODO: don't convert this yet, needs to be wrapped first
      private$.self$file
    },

    shape = function() {
      unlist(py_to_r(private$.self$shape))
    },

    value = function() {
      py_to_r(private$.self$value)
    }
  )
)

