#' @title concat
#'
#' @description Concatenates AnnData objects along an axis.
#'
#' @details See the `concatenation` section in the docs for a more in-depth description.
#'
#' warning: This function is marked as experimental for the `0.7` release series, and will supercede the `AnnData$concatenate()` method in future releases.
#'
#' warning: If you use `join='outer'` this fills 0s for sparse data when variables are absent in a batch. Use this with care. Dense data is filled with `NaN`.
#'
#' @param adatas The objects to be concatenated. If a Mapping is passed, keys are used for the `keys` argument and values are concatenated.
#' @param axis Which axis to concatenate along.
#' @param join How to align values when concatenating. If "outer", the union of the other axis is taken. If "inner", the intersection. See `concatenation` for more.
#' @param merge How elements not aligned to the axis being concatenated along are selected. Currently implemented strategies include: * `NULL`: No elements are kept. * `"same"`: Elements that are the same in each of the objects. * `"unique"`: Elements for which there is only one possible value. * `"first"`: The first element seen at each from each position. * `"only"`: Elements that show up in only one of the objects.
#' @param uns_merge How the elements of `.uns` are selected. Uses the same set of strategies as the `merge` argument, except applied recursively.
#' @param label Column in axis annotation (i.e. `.obs` or `.var`) to place batch information in. If it's NULL, no column is added.
#' @param keys Names for each object being added. These values are used for column values for `label` or appended to the index if `index_unique` is not `NULL`. Defaults to incrementing integer labels.
#' @param index_unique Whether to make the index unique by using the keys. If provided, this is the delimeter between `orig_idx + index_unique + key`. When `NULL`, the original indices are kept.
#' @param fill_value When `join="outer"`, this is the value that will be used to fill the introduced indices. By default, sparse arrays are padded with zeros, while dense arrays and DataFrames are padded with missing values.
#' @param pairwise Whether pairwise elements along the concatenated dimension should be included. This is FALSE by default, since the resulting arrays are often not meaningful.
#'
#' @export
#'
#' @examples
#' \dontrun{
#' # Preparing example objects
#' a <- AnnData(
#'   X = matrix(c(0, 1, 2, 3), nrow = 2, byrow = TRUE),
#'   obs = data.frame(group = c("a", "b"), row.names = c("s1", "s2")),
#'   var = data.frame(type = c(1L, 2L), row.names = c("var1", "var2")),
#'   varm = list(
#'     ones = matrix(rep(1L, 10), nrow = 2),
#'     rand = matrix(rnorm(6), nrow = 2),
#'     zeros = matrix(rep(0L, 10), nrow = 2)
#'   ),
#'   uns = list(
#'     a = 1,
#'     b = 2,
#'     c = list(
#'       c.a = 3,
#'       c.b = 4
#'     )
#'   )
#' )
#'
#' b <- AnnData(
#'   X = matrix(c(4, 5, 6, 7, 8, 9), nrow = 2, byrow = TRUE),
#'   obs = data.frame(group = c("b", "c"), row.names = c("s3", "s4")),
#'   var = data.frame(type = c(1L, 2L, 3L), row.names = c("var1", "var2", "var3")),
#'   varm = list(
#'     ones = matrix(rep(1L, 15), nrow = 3),
#'     rand = matrix(rnorm(15), nrow = 3)
#'   ),
#'   uns = list(
#'     a = 1,
#'     b = 3,
#'     c = list(
#'       c.a = 3
#'     )
#'   )
#' )
#'
#' c <- AnnData(
#'   X = matrix(c(10, 11, 12, 13), nrow = 2, byrow = TRUE),
#'   obs = data.frame(group = c("a", "b"), row.names = c("s1", "s2")),
#'   var = data.frame(type = c(3L, 4L), row.names = c("var3", "var4")),
#'   uns = list(
#'     a = 1,
#'     b = 4,
#'     c = list(
#'       c.a = 3,
#'       c.b = 4,
#'       c.c = 5
#'     )
#'   )
#' )
#'
#' # Concatenating along different axes
#' concat(list(a, b))$to_df()
#' concat(list(a, c), axis = 1L)$to_df()
#'
#' # Inner and outer joins
#' inner <- concat(list(a, b))
#' inner
#' inner$obs_names
#' inner$var_names
#'
#' outer <- concat(list(a, b), join = "outer")
#' outer
#' outer$var_names
#' outer$to_df()
#'
#' # Keeping track of source objects
#' concat(list(a = a, b = b), label = "batch")$obs
#' concat(list(a, b), label = "batch", keys = c("a", "b"))$obs
#' concat(list(a = a, b = b), index_unique = "-")$obs
#'
#' # Combining values not aligned to axis of concatenation
#' concat(list(a, b), merge = "same")
#' concat(list(a, b), merge = "unique")
#' concat(list(a, b), merge = "first")
#' concat(list(a, b), merge = "only")
#'
#' # The same merge strategies can be used for elements in .uns
#' concat(list(a, b, c), uns_merge = "same")$uns
#' concat(list(a, b, c), uns_merge = "unique")$uns
#' concat(list(a, b, c), uns_merge = "first")$uns
#' concat(list(a, b, c), uns_merge = "only")$uns
#' }
concat <- function(
  adatas,
  axis = 0L,
  join = "inner",
  merge = NULL,
  uns_merge = NULL,
  label = NULL,
  keys = NULL,
  index_unique = NULL,
  fill_value = NULL,
  pairwise = FALSE
) {
  if (!is.list(adatas)) {
    cli::cli_abort(c(
      "Argument {.arg adatas} must be a list of AnnData objects.",
      "x" = "You provided an object of class {.cls {class(adatas)}}."
    ))
  }
  is_anndata <- sapply(adatas, inherits, "AnnDataR6")
  if (any(!is_anndata)) {
    is_not_anndata <- which(!is_anndata)
    cli::cli_abort(c(
      "Argument {.arg adatas} must be a list of AnnData objects.",
      "x" = "You provided an object of class {.cls {class(adatas[[is_not_anndata[1]]])}} at index {.val {is_not_anndata[1]}}."
    ))
  }

  # get python objects
  adatas2 <- lapply(
    adatas,
    reticulate::r_to_py
  )

  python_anndata <- reticulate::import("anndata", convert = FALSE)
  py_to_r_ifneedbe(python_anndata$concat(
    adatas = adatas2,
    axis = axis,
    join = join,
    merge = merge,
    uns_merge = uns_merge,
    label = label,
    keys = keys,
    index_unique = index_unique,
    fill_value = fill_value,
    pairwise = pairwise
  ))
}
