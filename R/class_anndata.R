#' Create an Annotated Data Matrix
#'
#' @description `AnnData` stores a data matrix `X` together with annotations
#' of observations `obs` (`obsm`, `obsp`), variables `var` (`varm`, `varp`),
#' and unstructured annotations `uns`.
#'
#' An `AnnData` object `adata` can be sliced like a data frame,
#' for instance `adata_subset <- adata[, list_of_variable_names]`. `AnnData`’s
#' basic structure is similar to R's ExpressionSet.
#'
#' If setting an `h5ad`-formatted HDF5 backing file `filename`,
#' data remains on the disk but is automatically loaded into memory if needed.
#' See this [blog post](https://falexwolf.de/blog/171223_AnnData_indexing_views_HDF5-backing/) for more details.
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
#' Here's an example
#'
#' ```r
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
#' @rdname AnnData
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
#' @param raw Store raw version of `X` and `var` as `$raw$X` and `$raw$var`.
#' @param obsp Pairwise annotation of observations, a mutable mapping with array-like values.
#' @param varp Pairwise annotation of observations, a mutable mapping with array-like values.
#'
#' @export
#'
#' @seealso [read_h5ad()] [read_csv()] [read_excel()] [read_hdf()] [read_loom()] [read_mtx()] [read_text()] [read_umi_tools()] [write_h5ad()] [write_csvs()] [write_loom()]
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
#'
#' value <- matrix(c(1,2,3,4), nrow = 2)
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
#'
#' as.matrix(ad)
#' as.matrix(ad, layer = "unspliced")
#' dim(ad)
#' rownames(ad)
#' colnames(ad)
#' }
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
  obsp = NULL,
  varp = NULL
) {
  # check nrow size
  nrow <- nrow(X)
  if (is.null(nrow)) nrow <- nrow(obs)
  if (is.null(nrow) && !is.null(shape)) nrow <- shape[[1]]
  assert_that(!is.null(nrow), msg = "If $X, $obs and $var are NULL, shape should be set to the dimensions of the AnnData.")

  # check ncol size
  ncol <- ncol(X)
  if (is.null(ncol)) ncol <- nrow(var)
  if (is.null(ncol) && !is.null(shape)) ncol <- shape[[2]]
  assert_that(!is.null(ncol), msg = "If $X, $obs and $var are NULL, shape should be set to the dimensions of the AnnData.")

  # check for obs names
  obs_names <- rownames(X)
  if (is.null(obs_names)) obs_names <- rownames(obs)
  if (is.null(obs_names)) obs_names <- as.character(seq_len(nrow))

  # check for var names
  var_names <- colnames(X)
  if (is.null(var_names)) var_names <- rownames(var)
  if (is.null(var_names)) var_names <- as.character(seq_len(ncol))


  if (is.null(rownames(obs))) {
    if (is.null(obs)) {
      obs <- data.frame(row.names = obs_names)
      # obs <- list(obs_names = obs_names)
    } else if (is.data.frame(obs)) {
      rownames(obs) <- obs_names
      # obs$obs_names <- obs_names
    } else {
      obs$obs_names <- obs_names
    }
  }
  if (is.null(rownames(var))) {
    if (is.null(var)) {
      var <- data.frame(row.names = var_names)
      # var <- list(var_names = var_names)
    } else if (is.data.frame(var)) {
      rownames(var) <- var_names
    } else {
      var$var_names <- var_names
    }
  }

  # cast matrices if necessary
  X <- .check_matrix(X)
  if (!is.null(layers)) {
    for (i in seq_along(layers)) {
      layers[[i]] <- .check_matrix(layers[[i]])
    }
  }

  python_anndata <- reticulate::import("anndata", convert = FALSE)
  ad <- python_anndata$AnnData(
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
    obsp = obsp,
    varp = varp
  )

  AnnDataR6$new(ad)
}

#' @importFrom methods as
.check_matrix <- function(X) {
  if (inherits(X, "sparseMatrix") && !inherits(X, "CsparseMatrix") && !inherits(X, "RsparseMatrix")) {
    X <- as(X, "CsparseMatrix")
  }

  X
}

#' @rdname AnnData
#'
#' @importFrom R6 R6Class
#' @export
AnnDataR6 <- R6::R6Class(
  "AnnDataR6",
  private = list(
    .anndata = NULL
  ),
  cloneable = FALSE,
  public = list(
    #' @description Create a new AnnData object
    #'
    #' @param obj A Python anndata object
    #'
    #' @examples
    #' \dontrun{
    #' # use AnnData() instead of AnnDataR6$new()
    #' ad <- AnnData(
    #'   X = matrix(c(0, 1, 2, 3), nrow = 2),
    #'   obs = data.frame(group = c("a", "b"), row.names = c("s1", "s2")),
    #'   var = data.frame(type = c(1L, 2L), row.names = c("var1", "var2"))
    #' )
    #' }
    initialize = function(obj) {
      private$.anndata <- obj
    },

    #' @description List keys of observation annotation `obs`.
    #'
    #' @examples
    #' \dontrun{
    #' ad <- AnnData(
    #'   X = matrix(c(0, 1, 2, 3), nrow = 2),
    #'   obs = data.frame(group = c("a", "b"), row.names = c("s1", "s2"))
    #' )
    #' ad$obs_keys()
    #' }
    obs_keys = function() {
      py_to_r_ifneedbe(private$.anndata$obs_keys())
    },

    #' @description Makes the index unique by appending a number string to each duplicate index element: 1, 2, etc.
    #'
    #' If a tentative name created by the algorithm already exists in the index, it tries the next integer in the sequence.
    #'
    #' The first occurrence of a non-unique value is ignored.
    #'
    #' @param join The connecting string between name and integer (default: `"-"`).
    #'
    #' @examples
    #' \dontrun{
    #' ad <- AnnData(
    #'   X = matrix(rep(1, 6), nrow = 3),
    #'   obs = data.frame(field = c(1, 2, 3))
    #' )
    #' ad$obs_names <- c("a", "a", "b")
    #' ad$obs_names_make_unique()
    #' ad$obs_names
    #' }
    obs_names_make_unique = function(join = "-") {
      py_to_r_ifneedbe(private$.anndata$obs_names_make_unique(join = join))
    },

    #' @description List keys of observation annotation `obsm`.
    #'
    #' @examples
    #' \dontrun{
    #' ad <- AnnData(
    #'   X = matrix(c(0, 1, 2, 3), nrow = 2),
    #'   obs = data.frame(group = c("a", "b"), row.names = c("s1", "s2")),
    #'   obsm = list(
    #'     ones = matrix(rep(1L, 10), nrow = 2),
    #'     rand = matrix(rnorm(6), nrow = 2),
    #'     zeros = matrix(rep(0L, 10), nrow = 2)
    #'   )
    #' )
    #' ad$obs_keys()
    #' }
    obsm_keys = function() {
      py_to_r_ifneedbe(private$.anndata$obsm_keys())
    },

    #' @description List keys of variable annotation `var`.
    #' @examples
    #' \dontrun{
    #' ad <- AnnData(
    #'   X = matrix(c(0, 1, 2, 3), nrow = 2),
    #'   var = data.frame(type = c(1L, 2L), row.names = c("var1", "var2"))
    #' )
    #' ad$var_keys()
    #' }
    var_keys = function() {
      py_to_r_ifneedbe(private$.anndata$var_keys())
    },

    #' @description Makes the index unique by appending a number string to each duplicate index element: 1, 2, etc.
    #'
    #' If a tentative name created by the algorithm already exists in the index, it tries the next integer in the sequence.
    #'
    #' The first occurrence of a non-unique value is ignored.
    #'
    #' @param join The connecting string between name and integer (default: `"-"`).
    #'
    #' @examples
    #' \dontrun{
    #' ad <- AnnData(
    #'   X = matrix(rep(1, 6), nrow = 2),
    #'   var = data.frame(field = c(1, 2, 3))
    #' )
    #' ad$var_names <- c("a", "a", "b")
    #' ad$var_names_make_unique()
    #' ad$var_names
    #' }
    var_names_make_unique = function(join = "-") {
      py_to_r_ifneedbe(private$.anndata$var_names_make_unique(join = join))
    },

    #' @description List keys of variable annotation `varm`.
    #' @examples
    #' \dontrun{
    #' ad <- AnnData(
    #'   X = matrix(c(0, 1, 2, 3), nrow = 2),
    #'   var = data.frame(type = c(1L, 2L), row.names = c("var1", "var2")),
    #'   varm = list(
    #'     ones = matrix(rep(1L, 10), nrow = 2),
    #'     rand = matrix(rnorm(6), nrow = 2),
    #'     zeros = matrix(rep(0L, 10), nrow = 2)
    #'   )
    #' )
    #' ad$varm_keys()
    #' }
    varm_keys = function() {
      py_to_r_ifneedbe(private$.anndata$varm_keys())
    },

    #' @description List keys of unstructured annotation `uns`.
    #'
    #' @examples
    #' \dontrun{
    #' ad <- AnnData(
    #'   X = matrix(c(0, 1, 2, 3), nrow = 2),
    #'   obs = data.frame(group = c("a", "b"), row.names = c("s1", "s2")),
    #'   var = data.frame(type = c(1L, 2L), row.names = c("var1", "var2")),
    #'   uns = list(a = 1, b = 2, c = list(c.a = 3, c.b = 4))
    #' )
    #' }
    uns_keys = function() {
      py_to_r_ifneedbe(private$.anndata$uns_keys())
    },

    #' @description Return a chunk of the data matrix `X` with random or specified indices.
    #'
    #' @param select Depending on the values:
    #'   * 1 integer: A random chunk with select rows will be returned.
    #'   * multiple integers: A chunk with these indices will be returned.
    #' @param replace if `select` is an integer then `TRUE` means random sampling of indices with replacement,
    #'   `FALSE` without replacement.
    #'
    #' @examples
    #' \dontrun{
    #' ad <- AnnData(
    #'   X = matrix(runif(10000), nrow = 50)
    #' )
    #'
    #' ad$chunk_X(select = 10L) # 10 random samples
    #' ad$chunk_X(select = 1:3) # first 3 samples
    #' }
    chunk_X = function(select = 1000L, replace = TRUE) {
      py_to_r_ifneedbe(private$.anndata$chunk_X(select = select, replace = replace))
    },


    #' @description Return an iterator over the rows of the data matrix X.
    #'
    #' @param chunk_size Row size of a single chunk.
    #'
    #' @examples
    #' \dontrun{
    #' ad <- AnnData(
    #'   X = matrix(runif(10000), nrow = 50)
    #' )
    #' ad$chunked_X(10)
    #' }
    chunked_X = function(chunk_size = NULL) {
      # TODO: write py_to_r for this class
      private$.anndata$chunked_X(chunk_size = chunk_size)
    },

    #' @description Concatenate along the observations axis.
    #'
    #' @param ... Deprecated
    concatenate = function(...) {
      stop("Deprecated! Use concat(ad1, ad2) instead.")
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
    copy = function(filename = NULL) {
      py_to_r_ifneedbe(private$.anndata$copy(filename = filename))
    },

    #' @description Rename categories of annotation `key` in `obs`, `var`, and `uns`.
    #' Only supports passing a list/array-like `categories` argument.
    #' Besides calling `self.obs[key].cat.categories = categories` –
    #' similar for `var` - this also renames categories in unstructured
    #' annotation that uses the categorical annotation `key`.
    #'
    #' @param key Key for observations or variables annotation.
    #' @param categories New categories, the same number as the old categories.
    #'
    #' @examples
    #' \dontrun{
    #' ad <- AnnData(
    #'   X = matrix(c(0, 1, 2, 3), nrow = 2),
    #'   obs = data.frame(group = c("a", "b"), row.names = c("s1", "s2"))
    #' )
    #' ad$rename_categories("group", c(a = "A", b = "B")) # ??
    #' }
    rename_categories = function(key, categories) {
      py_to_r_ifneedbe(private$.anndata$rename_categories(key = key, categories = categories))
    },

    #' @description Transform string annotations to categoricals.
    #'
    #' Only affects string annotations that lead to less categories than the total number of observations.
    #'
    #' @param df If `df` is `NULL`, modifies both `obs` and `var`, otherwise modifies `df` inplace.
    #'
    #' @examples
    #' \dontrun{
    #' ad <- AnnData(
    #'   X = matrix(c(0, 1, 2, 3), nrow = 2),
    #'   obs = data.frame(group = c("a", "b"), row.names = c("s1", "s2")),
    #'   var = data.frame(type = c(1L, 2L), row.names = c("var1", "var2")),
    #' )
    #' ad$strings_to_categoricals() # ??
    #' }
    strings_to_categoricals = function(df = NULL) {
      py_to_r_ifneedbe(private$.anndata$strings_to_categoricals(df = df))
    },

    #' @description Generate shallow data frame.
    #'
    #' The data matrix `X` is returned as data frame, where `obs_names` are the rownames, and `var_names` the columns names.
    #'
    #' No annotations are maintained in the returned object.
    #'
    #' The data matrix is densified in case it is sparse.
    #'
    #' @param layer Key for layers
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
    #' ad$to_df()
    #' ad$to_df("unspliced")
    #' }
    to_df = function(layer = NULL) {
      py_to_r_ifneedbe(private$.anndata$to_df(layer = layer))
    },

    #' @description transpose Transpose whole object.
    #'
    #' Data matrix is transposed, observations and variables are interchanged.
    #'
    #' Ignores `.raw`.
    #'
    #' @examples
    #' \dontrun{
    #' ad <- AnnData(
    #'   X = matrix(c(0, 1, 2, 3), nrow = 2),
    #'   obs = data.frame(group = c("a", "b"), row.names = c("s1", "s2")),
    #'   var = data.frame(type = c(1L, 2L), row.names = c("var1", "var2"))
    #' )
    #'
    #' ad$transpose()
    #' }
    transpose = function() {
      py_to_r_ifneedbe(private$.anndata$transpose())
    },

    #' @description Write annotation to .csv files.
    #'
    #' It is not possible to recover the full AnnData from these files. Use [write_h5ad()] for this.
    #'
    #' @param anndata An [AnnData()] object
    #' @param dirname Name of the directory to which to export.
    #' @param skip_data Skip the data matrix `X`.
    #' @param sep Separator for the data
    #'
    #' @examples
    #' \dontrun{
    #' ad <- AnnData(
    #'   X = matrix(c(0, 1, 2, 3), nrow = 2),
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
    #' ad$to_write_csvs("output")
    #'
    #' unlink("output", recursive = TRUE)
    #' }
    write_csvs = function(dirname, skip_data = TRUE, sep = ",") {
      dirname <- normalizePath(dirname, mustWork = FALSE)
      private$.anndata$write_csvs(
        dirname = dirname,
        skip_data = skip_data,
        sep = sep
      )
    },

    #' @description Write .h5ad-formatted hdf5 file.
    #'
    #' Generally, if you have sparse data that are stored as a dense matrix, you can
    #' dramatically improve performance and reduce disk space by converting to a csr_matrix:
    #'
    #' @param anndata An [AnnData()] object
    #' @param filename Filename of data file. Defaults to backing file.
    #' @param compression See the h5py [filter pipeline](http://docs.h5py.org/en/latest/high/dataset.html#dataset-compression).
    #'   Options are `"gzip"`, `"lzf"` or `NULL`.
    #' @param compression_opts See the h5py [filter pipeline](http://docs.h5py.org/en/latest/high/dataset.html#dataset-compression).
    #' @param as_dense Sparse in AnnData object to write as dense. Currently only supports `"X"` and `"raw/X"`.
    #'
    #' @examples
    #' \dontrun{
    #' ad <- AnnData(
    #'   X = matrix(c(0, 1, 2, 3), nrow = 2),
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
    #' ad$write_h5ad("output.h5ad")
    #'
    #' file.remove("output.h5ad")
    #' }
    write_h5ad = function(filename, compression = NULL, compression_opts = NULL, as_dense = list()) {
      filename <- normalizePath(filename, mustWork = FALSE)
      private$.anndata$write_h5ad(
        filename = filename,
        compression = compression,
        compression_opts = compression_opts,
        as_dense = as_dense
      )
    },

    #' @description Write .loom-formatted hdf5 file.
    #'
    #' @param anndata An [AnnData()] object
    #' @param filename The filename.
    #' @param write_obsm_varm Whether or not to also write the varm and obsm.
    #'
    #' @examples
    #' \dontrun{
    #' ad <- AnnData(
    #'   X = matrix(c(0, 1, 2, 3), nrow = 2),
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
    #' ad$write_loom("output.loom")
    #'
    #' file.remove("output.loom")
    #' }
    write_loom = function(filename, write_obsm_varm = FALSE) {
      filename <- normalizePath(filename, mustWork = FALSE)
      private$.anndata$write_loom(
        filename = filename,
        write_obsm_varm = write_obsm_varm
      )
    },

    #' @description Print AnnData object
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
    #'
    #' ad$print()
    #' print(ad)
    #' }
    print = function(...) {
      print(private$.anndata, ...)
    },

    #' @description Set internal Python object
    #' @param obj A python anndata object
    .set_py_object = function(obj) {
      private$.anndata <- obj
    },

    #' @description Get internal Python object
    .get_py_object = function() {
      private$.anndata
    }
  ),
  active = list(
    #' @field X Data matrix of shape `n_obs` × `n_vars`.
    X = function(value) {
      if (missing(value)) {
        out <- py_to_r_ifneedbe(private$.anndata$X)
        if (!is.null(out)) {
          dimnames(out) <- dimnames(self)
        }
        out
      } else {
        value <- .check_matrix(value)
        private$.anndata$X <- value
        self
      }
    },
    #' @field filename Name of the backing file.
    #'
    #' Change to backing mode by setting the filename of a `.h5ad` file.
    #'
    #' - Setting the filename writes the stored data to disk.
    #' - Setting the filename when the filename was previously another name
    #'   moves the backing file from the previous file to the new file.
    #'   If you want to copy the previous file, use `copy(filename='new_filename')`.
    filename = function(value) {
      if (missing(value)) {
        py_to_r_ifneedbe(private$.anndata$filename)
      } else {
        private$.anndata$filename <- value
        self
      }
    },
    #' @field layers A list-like object with values of the same dimensions as `X`.
    #' Layers in AnnData are inspired by [loompy's layers](https://linnarssonlab.org/loompy/apiwalkthrough/index.html#loomlayers).
    #'
    #' Overwrite the layers:
    #' ```
    #' adata$layers <- list(spliced = spliced, unspliced = unspliced)
    #' ````
    #'
    #' Return the layer named `"unspliced"`:
    #' ```
    #' adata$layers["unspliced"]
    #' ```
    #'
    #' Create or replace the `"spliced"` layer:
    #' ```
    #' adata$layers["spliced"] = example_matrix
    #' ```
    #'
    #' Assign the 10th column of layer `"spliced"` to the variable a:
    #' ```
    #' a <- adata$layers["spliced"][, 10]
    #' ```
    #'
    #' Delete the `"spliced"`:
    #' ```
    #' adata$layers["spliced"] <- NULL
    #' ```
    #'
    #' Return layers' names:
    #' ```
    #' names(adata$layers)
    #' ```
    layers = function(value) {
      if (missing(value)) {
        py_to_r_ifneedbe(private$.anndata$layers)
      } else {
        # add check for value
        if (!is.null(value) && is.list(value)) {
          for (i in seq_along(value)) {
            value[[i]] <- .check_matrix(value[[i]])
          }
        }
        private$.anndata$layers <- reticulate::r_to_py(value)
        self
      }
    },
    #' @field T Transpose whole object.
    #'
    #' Data matrix is transposed, observations and variables are interchanged.
    #'
    #' Ignores `.raw`.
    `T` = function() {
      py_to_r_ifneedbe(private$.anndata$`T`)
    },
    #' @field is_view `TRUE` if object is view of another AnnData object, `FALSE` otherwise.
    is_view = function() {
      py_to_r_ifneedbe(private$.anndata$is_view)
    },
    #' @field isbacked `TRUE` if object is backed on disk, `FALSE` otherwise.
    isbacked = function() {
      py_to_r_ifneedbe(private$.anndata$isbacked)
    },
    #' @field n_obs Number of observations.
    n_obs = function() {
      py_to_r_ifneedbe(private$.anndata$n_obs)
    },
    #' @field obs One-dimensional annotation of observations (data.frame).
    obs = function(value) {
      if (missing(value)) {
        py_to_r_ifneedbe(private$.anndata$obs)
      } else {
        if (is.null(value)) {
          py_del_attr(private$.anndata, "obs")
        } else {
          private$.anndata$obs <- value
        }
        self
      }
    },
    #' @field obs_names Names of observations.
    obs_names = function(value) {
      if (missing(value)) {
        py_to_r_ifneedbe(private$.anndata$obs_names)
      } else {
        # add check for value
        private$.anndata$obs_names <- value
        private$.anndata$obs_names$name <- attr(value, "name")
        self
      }
    },
    #' @field obsm Multi-dimensional annotation of observations (matrix).
    #'
    #' Stores for each key a two or higher-dimensional matrix with `n_obs` rows.
    obsm = function(value) {
      if (missing(value)) {
        py_to_r_ifneedbe(private$.anndata$obsm)
      } else {
        # add check for value
        private$.anndata$obsm <- value
        self
      }
    },
    #' @field obsp Pairwise annotation of observations, a mutable mapping with array-like values.
    #'
    #' Stores for each key a two or higher-dimensional matrix whose first two dimensions are of length `n_obs`.
    obsp = function(value) {
      if (missing(value)) {
        py_to_r_ifneedbe(private$.anndata$obsp)
      } else {
        # add check for value
        private$.anndata$obsp <- value
        self
      }
    },
    #' @field n_vars Number of variables.
    n_vars = function() {
      py_to_r_ifneedbe(private$.anndata$n_vars)
    },
    #' @field var One-dimensional annotation of variables (data.frame).
    var = function(value) {
      if (missing(value)) {
        py_to_r_ifneedbe(private$.anndata$var)
      } else {
        if (is.null(value)) {
          py_del_attr(private$.anndata, "var")
        } else {
          private$.anndata$var <- value
        }
        self
      }
    },
    #' @field var_names Names of variables.
    var_names = function(value) {
      if (missing(value)) {
        py_to_r_ifneedbe(private$.anndata$var_names)
      } else {
        # add check for value
        private$.anndata$var_names <- value
        private$.anndata$var_names$name <- attr(value, "name")
        self
      }
    },
    #' @field varm Multi-dimensional annotation of variables (matrix).
    #'
    #' Stores for each key a two or higher-dimensional matrix with `n_vars` rows.
    varm = function(value) {
      if (missing(value)) {
        py_to_r_ifneedbe(private$.anndata$varm)
      } else {
        # add check for value
        private$.anndata$varm <- value
        self
      }
    },
    #' @field varp Pairwise annotation of variables, a mutable mapping with array-like values.
    #'
    #' Stores for each key a two or higher-dimensional matrix whose first two dimensions are of length `n_vars`.
    varp = function(value) {
      if (missing(value)) {
        py_to_r_ifneedbe(private$.anndata$varp)
      } else {
        # add check for value
        private$.anndata$varp <- value
        self
      }
    },
    #' @field shape Shape of data matrix (`n_obs`, `n_vars`).
    shape = function() {
      unlist(py_to_r_ifneedbe(private$.anndata$shape))
    },
    #' @field uns Unstructured annotation (ordered dictionary).
    uns = function(value) {
      if (missing(value)) {
        py_to_r_ifneedbe(private$.anndata$uns)
      } else {
        if (is.null(value)) {
          py_del_attr(private$.anndata, "uns")
        } else {
          private$.anndata$uns <- value
        }
        self
      }
    },
    #' @field raw Store raw version of `X` and `var` as `$raw$X` and `$raw$var`.
    #'
    #' The `raw` attribute is initialized with the current content of an object
    #' by setting:
    #'
    #' ```
    #' adata$raw = adata
    #' ```
    #'
    #' Its content can be deleted:
    #' ```
    #' adata$raw <- NULL
    #' ```
    #' Upon slicing an AnnData object along the obs (row) axis, `raw` is also
    #' sliced. Slicing an AnnData object along the vars (columns) axis
    #' leaves `raw` unaffected. Note that you can call:
    #'
    #' ```
    #' adata$raw[, 'orig_variable_name']$X
    #' ```
    #' `
    #' to retrieve the data associated with a variable that might have been
    #' filtered out or "compressed away" in `X`.
    raw = function(value) {
      if (missing(value)) {
        py_to_r_ifneedbe(private$.anndata$raw)
      } else {
        # TODO: fix `ad$raw <- ...`
        # add check for value
        if (is.null(value)) {
          # reticulate::py_del_attr(private$.anndata, "raw")
          reticulate::py_del_attr(r_to_py(private$.anndata), "raw")
        } else {
          if (inherits(value, "AnnDataR6") || inherits(value, "RawR6")) {
            value <- r_to_py(value)
          }
          private$.anndata$raw <- value
        }

        self
      }
    }
  )
)

#' AnnData Helpers
#'
#' @param x An AnnData object.
#' @param layer An AnnData layer. If `NULL`, will use `ad$X`, otherwise `ad$layers[layer]`.
#' @param convert Not used.
#' @param row.names Not used.
#' @param optional Not used.
#' @param ... Parameters passed to the underlying function.
#' @param value a possible valie for `dimnames(ad)`. The dimnames of a AnnData
#'   can be `NULL` (which is not stored) or a list of the same length as `dim(ad)`.
#'   If a list, its components are either NULL or a character vector with
#'   positive length of the appropriate dimension of `ad`.
#'
#' @rdname AnnDataHelpers
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
dimnames.AnnDataR6 <- function(x) {
  list(
    x$obs_names,
    x$var_names
  )
}

#' @rdname AnnDataHelpers
#' @export
`dimnames<-.AnnDataR6` <- function(x, value) {
  d <- dim(x)
  if (!is.list(value) || length(value) != 2L)
    stop("invalid 'dimnames' given for AnnData")
  # value[[1L]] <- as.character(value[[1L]])
  # value[[2L]] <- as.character(value[[2L]])
  if (d[[1L]] != length(value[[1L]]) || d[[2L]] != length(value[[2L]]))
    stop("invalid 'dimnames' given for AnnData")
  x$obs_names <- value[[1L]]
  x$var_names <- value[[2L]]
  x
}

#' @rdname AnnDataHelpers
#' @export
dim.AnnDataR6 <- function(x) {
  x$shape
}

#' @rdname AnnDataHelpers
#' @export
as.data.frame.AnnDataR6 <- function(x, row.names = NULL, optional = FALSE, layer = NULL, ...) {
  x$to_df(layer = layer)
}

#' @rdname AnnDataHelpers
#' @export
as.matrix.AnnDataR6 <- function(x, layer = NULL, ...) {
  mat <-
    if (is.null(layer)) {
      x$X
    } else {
      x$layers[[layer]]
    }
  dimnames(mat) <- dimnames(x)
  mat
}

#' @rdname AnnDataHelpers
#' @export
r_to_py.AnnDataR6 <- function(x, convert = FALSE) {
  x$.get_py_object()
}

#' @rdname AnnDataHelpers
#' @export
py_to_r.anndata._core.anndata.AnnData <- function(x) {
  AnnDataR6$new(x)
}

.process_index <- function(idx, len) {
  if (missing(idx) || is.null(idx)) {
    builtins <- reticulate::import_builtins(convert = FALSE)
    idx <- builtins$slice(builtins$None)
  } else if (is.numeric(idx)) {
    if (any(idx <= 0)) {
      if (!all(idx < 0)) {
        stop("integer indices should be all positive or all negative")
      }
      idx <- seq_len(len)[idx]
    }
    idx <- as.integer(idx - 1)
  }

  idx
}

#' @rdname AnnDataHelpers
#' @importFrom reticulate tuple
#' @param oidx Observation indices
#' @param vidx Variable indices
#' @export
`[.AnnDataR6` <- function(x, oidx, vidx) {
  oidx <- .process_index(oidx, nrow(x))
  vidx <- .process_index(vidx, ncol(x))
  tup <- reticulate::tuple(oidx, vidx)
  py_to_r_ifneedbe(x$.get_py_object()$`__getitem__`(tup))
}

#' @rdname AnnDataHelpers
#' @export
t.AnnDataR6 <- function(x) {
  x$`T`
}

# interpreted from
# https://github.com/theislab/anndata/blob/58886f09b2e387c6389a2de20ed0bc7d20d1b843/anndata/tests/helpers.py#L352
#' Test if two objects objects are equal
#' @rdname all.equal
#' @inheritParams base::all.equal
#' @export
all.equal.AnnDataR6 <- function(target, current) {
  a <- target
  b <- current

  if (!inherits(b, "AnnDataR6")) {
    return("Not an AnnData object")
  }

  aecheck <- function(a, b, field) {
    e <- all.equal(a, b)
    if (!isTRUE(e)) {
      paste0("Field ", field, " mismatch: ", e)
    } else {
      e
    }
  }

  `%&%` <- function(a, b) {
    if (isTRUE(a)) {
      if (isTRUE(b)) {
        a
      } else {
        b
      }
    } else {
      if (isTRUE(b)) {
        a
      } else {
        c(a, b)
      }
    }
  }

  match <-
    aecheck(a$obs_names, b$obs_names, "obs_names") %&%
    aecheck(a$var_names, b$var_names, "var_names") %&%
    aecheck(a$obs, b$obs, "obs") %&%
    aecheck(a$var, b$var, "var") %&%
    aecheck(a$X, b$X, "X") %&%
    aecheck(a$obsm, b$obsm, "obsm") %&%
    aecheck(a$varm, b$varm, "varm") %&%
    aecheck(a$layers, b$layers, "layers") %&%
    aecheck(a$uns, b$uns, "uns") %&%
    aecheck(a$obsp, b$obsp, "obsp") %&%
    aecheck(a$varp, b$varp, "varp")

  if (!is.null(a$raw)) {
    # TODO: implement all equal for raw
  }

  match
}

#' @rdname AnnDataHelpers
#' @export
py_to_r.anndata._core.sparse_dataset.SparseDataset <- function(x) {
  py_to_r_ifneedbe(x$value)
}

#' @rdname AnnDataHelpers
#' @export
py_to_r.h5py._hl.dataset.Dataset <- function(x) {
  py_to_r(py_get_item(x, tuple()))
}
