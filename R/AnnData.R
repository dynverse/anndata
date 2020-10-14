#' @title AnnData
#'
#' @description An annotated data matrix.
#'
#' @details `AnnData` stores a data matrix `X` together with annotations
#' of observations `obs` (`obsm`, `obsp`), variables `var` (`varm`, `varp`),
#' and unstructured annotations `uns`.
#'
#' An `AnnData` object `adata` can be sliced like a data frame,
#' for instance `adata_subset <- adata[, list_of_variable_names]`.`AnnData`’s
#' basic structure is similar to R's ExpressionSet.
#'
#' If setting an `h5ad`-formatted HDF5 backing file `filename`,
#' data remains on the disk but is automatically loaded into memory if needed.
#' See this [blog post](http://falexwolf.de/blog/171223_AnnData_indexing_views_HDF5-backing/) for more details.
#'
#' @param X A #observations × #variables data matrix. A view of the data is used if the data type matches, otherwise, a copy is made.
#' @param obs Key-indexed one-dimensional observations annotation of length #observations.
#' @param var Key-indexed one-dimensional variables annotation of length #variables.
#' @param uns Key-indexed unstructured annotation.
#' @param obsm Key-indexed multi-dimensional observations annotation of length #observations. If passing a `~numpy.ndarray`, it needs to have a structured datatype.
#' @param varm Key-indexed multi-dimensional variables annotation of length #variables. If passing a `~numpy.ndarray`, it needs to have a structured datatype.
#' @param layers Key-indexed multi-dimensional arrays aligned to dimensions of `X`.
#' @param dtype Data type used for storage.
#' @param shape Shape list (#observations, #variables). Can only be provided if `X` is `NULL`.
#' @param filename Name of backing file. See [h5py.File](https://docs.h5py.org/en/latest/high/file.html#h5py.File).
#' @param filemode Open mode of backing file. See [h5py.File](https://docs.h5py.org/en/latest/high/file.html#h5py.File).
#' @param asview asview
#' @param raw undocumented agument
#'
#' @seealso [read_h5ad()] [read_csv()] [read_excel()] [read_hdf()] [read_loom()] [read_mtx()] [read_text()] [read_umi_tools()] [write_h5ad()] [write_csvs()] [write_loom()]
#'
#' @details
#' `AnnData` stores observations (samples) of variables/features in the rows of a matrix.
#' This is the convention of the modern classics of statistic and machine learning,
#' the convention of dataframes both in R and Python and the established statistics
#' and machine learning packages in Python (statsmodels, scikit-learn).
#'
#' Single dimensional annotations of the observation and variables are stored
#' in the `obs` and `var` attributes as data frames.
#' This is intended for metrics calculated over their axes.
#' Multi-dimensional annotations are stored in `obsm` and `varm`,
#' which are aligned to the objects observation and variable dimensions respectively.
#' Square matrices representing graphs are stored in `obsp` and `varp`,
#' with both of their own dimensions aligned to their associated axis.
#' Additional measurements across both observations and variables are stored in
#' `layers`.
#'
#' Indexing into an AnnData object can be performed by relative position
#' with numeric indices,  or by labels.
#' To avoid ambiguity with numeric indexing into observations or variables,
#' indexes of the AnnData object are converted to strings by the constructor.
#'
#' Subsetting an AnnData object by indexing into it will also subset its elements
#' according to the dimensions they were aligned to.
#' This means an operation like `adata[list_of_obs, ]` will also subset `obs`,
#' `obsm`, and `layers`.
#'
#' Subsetting an AnnData object returns a view into the original object,
#' meaning very little additional memory is used upon subsetting.
#' This is achieved lazily, meaning that the constituent arrays are subset on access.
#' Copying a view causes an equivalent “real” AnnData object to be generated.
#' Attempting to modify a view (at any attribute except X) is handled
#' in a copy-on-modify manner, meaning the object is initialized in place.
#' Here’s an example
#'
#' ```
#' batch1 <- adata[adata$obs["batch"] == "batch1", ]
#' batch1$obs["value"] = 0 # This makes batch1 a “real” AnnData object
#' ```
#'
#' At the end of this snippet: `adata` was not modified,
#' and `batch1` is its own AnnData object with its own data.
#'
#' Similar to Bioconductor’s `ExpressionSet` and `scipy.sparse` matrices,
#' subsetting an AnnData object retains the dimensionality of its constituent arrays.
#' Therefore, unlike with the classes exposed by `pandas`, `numpy`,
#' and `xarray`, there is no concept of a one dimensional AnnData object.
#' AnnDatas always have two inherent dimensions, `obs` and `var`.
#' Additionally, maintaining the dimensionality of the AnnData object allows for
#' consistent handling of `scipy.sparse` matrices and `numpy` arrays.
#'
#' @section Attributes:
#'
#' | Attribute | Description |
#' |-----------|-------------|
#' | `T` | Transpose whole object. |
#' | `X` | Data matrix of shape `n_obs` × `n_vars` |
#' | `filename` | Change to backing mode by setting the filename of a `.h5ad` file.
#' | `is_view` | `TRUE` if object is view of another AnnData object, `FALSE` otherwise.
#' | `isbacked` | `TRUE` if object is backed on disk, `FALSE` otherwise.
#' | `layers` | Dictionary-like object with values of the same dimensions as X. |
#' | `n_obs` | Number of observations. |
#' | `n_vars` | Number of variables/features. |
#' | `obs` | One-dimensional annotation of observations (data frame). |
#' | `obs_names` | Names of observations (alias for `$obs$index`). |
#' | `obsm` | Multi-dimensional annotation of observations (mutable structured ndarray). |
#' | `obsp` | Pairwise annotation of observations, a mutable mapping with array-like values. |
#' | `raw` | Store raw version of X and var as `$raw$X`^ and `$raw$var`. |
#' | `shape` | Shape of data matrix (n_obs, n_vars). |
#' | `uns` | Unstructured annotation (ordered dictionary). |
#' | `var` | One-dimensional annotation of variables/ features (data frame). |
#' | `var_names` | Names of variables (alias for `$var$index`). |
#' | `varm` | Multi-dimensional annotation of variables/features (mutable structured ndarray). |
#' | `varp` | Pairwise annotation of observations, a mutable mapping with array-like values. |
#'
#' @section Methods:
#'
#' | Method | Description |
#' |--------|-------------|
#' | `chunk_X([select, replace])` | Return a chunk of the data matrix `X` with random or specified indices. |
#' | `chunked_X([chunk_size])` | Return an iterator over the rows of the data matrix `X`. |
#' | `concatenate(adatas[, join, batch_key, ...])` | Concatenate along the observations axis. |
#' | `copy([filename])` | Full copy, optionally on disk. |
#' | `obs_keys()` | List keys of observation annotation `o`bs. |
#' | `obs_names_make_unique([join])` | Makes the index unique by appending a number string to each duplicate index element: ‘1’, ‘2’, etc. |
#' | `obs_vector(k, *[, layer])` | Convenience function for returning a 1 dimensional ndarray of values from `X`, `layers[k]`, or `obs`. |
#' | `obsm_keys()` | List keys of observation annotation `obsm`. |
#' | `rename_categories(key, categories)` | Rename categories of annotation key in `obs`, `var`, and `uns`. |
#' | `strings_to_categoricals([df])` | Transform string annotations to categoricals. |
#' | `to_df([layer])` | Generate shallow data frame. |
#' | `transpose()` | Transpose whole object. |
#' | `uns_keys()` | List keys of unstructured annotation. |
#' | `var_keys()` | List keys of variable annotation `var`. |
#' | `var_names_make_unique([join])` | Makes the index unique by appending a number string to each duplicate index element: ‘1’, ‘2’, etc. |
#' | `var_vector(k, *[, layer])` | Convenience function for returning a 1 dimensional ndarray of values from `X`, `layers[k]`, or `obs`. |
#' | `varm_keys()` | List keys of variable annotation varm. |
#' | `write([filename, compression, ...])` | Write `h5ad`-formatted hdf5 file. |
#' | `write_csvs(dirname[, skip_data, sep])` | Write annotation to `csv` files. |
#' | `write_h5ad([filename, compression, ...])` | Write `h5ad`-formatted hdf5 file. |
#' | `write_loom(filename[, write_obsm_varm]` | Write `loom`-formatted hdf5 file. |
#' | `write_zarr(store[, chunks])` | Write a hierarchical Zarr array store. |
#'
#' @examples
#' \dontrun{
#' ad <- AnnData(
#'   X = matrix(c(0, 1, 2, 3), nrow = 2, byrow = TRUE),
#'   obs = data.frame(group = c("a", "b"), row.names = c("s1", "s2")),
#'   var = data.frame(type = c(1L, 2L), row.names = c("var1", "var2")),
#'   varm = list(
#'     ones = matrix(rep(1L, 10), nrow = 2),
#'     rand = matrix(rnorm(6), nrow = 2),
#'     zeros = matrix(rep(0L, 10), nrow = 2)
#'   ),
#'   uns = list(a = 1, b = 2, c = list(c.a = 3, c.b = 4))
#' )
#'
#' ad$X
#' ad$to_df()
#' ad$uns
#'
#' # and many more...
#' }
#'
#' @export
AnnData <- function(
  X = NULL,
  obs = NULL,
  var = NULL,
  uns = NULL,
  obsm = NULL,
  varm = NULL,
  layers = NULL,
  raw = NULL,
  dtype = "float32",
  shape = NULL,
  filename = NULL,
  filemode = NULL,
  asview = FALSE
) {
  python_anndata$AnnData(
    X = X,
    obs = obs,
    var = var,
    uns = uns,
    obsm = obsm,
    varm = varm,
    layers = layers,
    raw = raw,
    dtype = dtype,
    shape = shape,
    filename = filename,
    filemode = filemode,
    asview = asview
  )
}
