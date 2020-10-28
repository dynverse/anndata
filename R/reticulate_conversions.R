#' Convert between Python and R objects
#'
#' @param x A Python object.
#' @param name A name
#' @param value A value
#'
#' @return An \R object, as converted from the Python object.
#'
#' @name r-py-conversion
#' @export
`[[<-.collections.abc.MutableMapping` <- function(x, name, value) {
  if (is.null(value)) {
    reticulate::py_del_item(x, name)
  } else {
    reticulate::py_set_item(x, name, value)
  }
}

#' @name r-py-conversion
#' @export
`[[.collections.abc.Mapping` <- function(x, name) {
  reticulate::py_to_r(reticulate::py_get_item(x, name))
}

#' @name r-py-conversion
#' @export
`[<-.collections.abc.MutableMapping` <- function(x, name, value) {
  if (is.null(value)) {
    reticulate::py_del_item(x, name)
  } else {
    reticulate::py_set_item(x, name, value)
  }
}

#' @name r-py-conversion
#' @export
`[.collections.abc.Mapping` <- function(x, name) {
  reticulate::py_to_r(reticulate::py_get_item(x, name))
}

#' @name r-py-conversion
#' @export
`names.collections.abc.Mapping` <- function(x) {
  python_builtins <- reticulate::import_builtins()
  python_builtins$list(x$keys())
}

#' @name r-py-conversion
#' @export
`py_to_r.collections.abc.Set` <- function(x) {
  python_builtins <- reticulate::import_builtins()
  python_builtins$list(x)
}

#' @name r-py-conversion
#' @export
py_to_r.pandas.core.indexes.base.Index <- function(x) {
  python_builtins <- reticulate::import_builtins()
  python_builtins$list(x)
}

#' @name r-py-conversion
#' @export
py_to_r.collections.abc.KeysView <- function(x) {
  python_builtins <- reticulate::import_builtins()
  python_builtins$list(x)
}

# #' @name r-py-conversion
# #' @export
# `py_to_r.collections.abc.Mapping` <- function(x, name) {
#   python_builtins <- reticulate::import_builtins()
#   python_builtins$list(x)
# }

# TODO: could add mapping specifically for:
# * adpy$layers: anndata._core.aligned_mapping.Layers
# * adpy$obsm: anndata._core.aligned_mapping.AxisArrays
# * adpy$varm: anndata._core.aligned_mapping.AxisArrays
# * adpy$obsp: anndata._core.aligned_mapping.PairwiseArrays
# * adpy$varp: anndata._core.aligned_mapping.PairwiseArrays
# * adpy$uns: anndata.compat._overloaded_dict.OverloadedDict

# TODO: Need to add mapping for:
# * adpy$chunked_X: python.builtin.iterator
