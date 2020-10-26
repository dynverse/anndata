field_getter_setter <- function(name) {
  function(value) {
    if (missing(value)) {
      private$.anndata[name]
    } else {
      private$.anndata[name] <- value
      self
    }
  }
}
field_getter <- function(name) {
  function(value) {
    private$.anndata[name]
  }
}

#' @title AnnDataR6
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
#' @import R6
#' @export
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
#' @examples
#' \dontrun{
#' ad <- AnnDataR6$new(
#'   X = matrix(c(0, 1, 2, 3), nrow = 2, byrow = TRUE),
#'   obs = data.frame(group = c("a", "b"), row.names = c("s1", "s2")),
#'   var = data.frame(type = c(1L, 2L), row.names = c("var1", "var2")),
#'   layers = list(
#'     spliced = matrix(c(4, 5, 6, 7), nrow = 2, byrow = TRUE),
#'     unspliced = matrix(c(8, 9, 10, 11), nrow = 2, byrow = TRUE)
#'   ),
#'   varm = list(
#'     ones = matrix(rep(1L, 10), nrow = 2),
#'     rand = matrix(rnorm(6), nrow = 2),
#'     zeros = matrix(rep(0L, 10), nrow = 2)
#'   ),
#'   uns = list(a = 1, b = 2, c = list(c.a = 3, c.b = 4))
#' )
#' adpy <- ad$.__enclos_env__$private$.anndata
#' private <- list(.anndata = adpy)
#'
#' value <- matrix(c(1,2,3,4), nrow = 2)
#' ad$X
#' ad$X <- value
#' ad$X
#'
#' ad$layers
#' ad$layers["spliced"]
#' ad$layers["test"] <- value
#' ad$layers
#'
#' ad$X
#' ad$to_df()
#' ad$uns
#'
#' # and many more...
#' }
AnnDataR6 <- R6::R6Class(
  "AnnDataR6",
  private = list(
    .anndata = NULL
  ),
  active = list(
    #' @field X Data matrix of shape `n_obs` × `n_vars`.
    X = function(value) {
      if (missing(value)) {
        private$.anndata$X
      } else {
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
        private$.anndata$filename
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
        private$.anndata$layers
      } else {
        # add check for value
        private$.anndata$layers <- value
        self
      }
    },
    #' @field T Transpose whole object.
    #'
    #' Data matrix is transposed, observations and variables are interchanged.
    #'
    #' Ignores `.raw`.
    `T` = function() {
      private$.anndata$`T`
    },
    #' @field is_view `TRUE` if object is view of another AnnData object, `FALSE` otherwise.
    is_view = function() {
      private$.anndata$is_view
    },
    #' @field isbacked `TRUE` if object is backed on disk, `FALSE` otherwise.
    isbacked = function() {
      private$.anndata$isbacked
    },
    #' @field n_obs Number of observations.
    n_obs = function() {
      private$.anndata$n_obs
    },
    #' @field obs One-dimensional annotation of observations (data.frame).
    obs = function(value) {
      if (missing(value)) {
        private$.anndata$obs
      } else {
        # add check for value
        private$.anndata$obs <- value
        self
      }
    },
    #' @field obs_names Names of observations.
    obs_names = function(value) {
      if (missing(value)) {
        private$.anndata$obs_names
      } else {
        # add check for value
        private$.anndata$obs_names <- value
        self
      }
    },
    #' @field obsm Multi-dimensional annotation of observations (matrix).
    #'
    #' Stores for each key a two or higher-dimensional matrix with `n_obs` rows.
    obsm = function(value) {
      if (missing(value)) {
        private$.anndata$obsm
      } else {
        # add check for value
        private$.anndata$obsm <- value
        self
      }
    },
    #' @field obsp Pairwise annotation of observations, a mutable mapping with array-like values.
    #'
    #' Stores for each key a two or higher-dimensional data frame? whose first two dimensions are of length `n_obs`.
    obsp = function(value) {
      if (missing(value)) {
        private$.anndata$obsp
      } else {
        # add check for value
        private$.anndata$obsp <- value
        self
      }
    },
    #' @field n_var Number of variables.
    n_var = function() {
      private$.anndata$n_var
    },
    #' @field var One-dimensional annotation of variables (data.frame).
    var = function(value) {
      if (missing(value)) {
        private$.anndata$var
      } else {
        # add check for value
        private$.anndata$var <- value
        self
      }
    },
    #' @field var_names Names of variables.
    var_names = function(value) {
      if (missing(value)) {
        private$.anndata$var_names
      } else {
        # add check for value
        private$.anndata$var_names <- value
        self
      }
    },
    #' @field varm Multi-dimensional annotation of variables (matrix).
    #'
    #' Stores for each key a two or higher-dimensional matrix with `n_var` rows.
    varm = function(value) {
      if (missing(value)) {
        private$.anndata$varm
      } else {
        # add check for value
        private$.anndata$varm <- value
        self
      }
    },
    #' @field varp Pairwise annotation of variables, a mutable mapping with array-like values.
    #'
    #' Stores for each key a two or higher-dimensional data frame? whose first two dimensions are of length `n_var`.
    varp = function(value) {
      if (missing(value)) {
        private$.anndata$varp
      } else {
        # add check for value
        private$.anndata$varp <- value
        self
      }
    },
    #' @field shape Shape of data matrix (`n_obs`, `n_vars`).
    shape = function() {
      unlist(private$.anndata$shape)
    },
    #' @field uns Unstructured annotation (ordered dictionary).
    uns = function(value) {
      if (missing(value)) {
        private$.anndata$uns
      } else {
        # add check for value
        private$.anndata$uns <- value
        self
      }
    }
  ),
  public = list(
    #' @description Create a new AnnData object
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
    initialize = function(
      X = NULL,
      obs = NULL,
      var = NULL,
      uns = NULL,
      obsm = NULL,
      varm = NULL,
      layers = NULL,
      # raw = NULL,
      dtype = "float32",
      shape = NULL,
      filename = NULL,
      filemode = NULL
    ) {
      private$.anndata <- python_anndata$AnnData(
        X = X,
        obs = obs,
        var = var,
        uns = uns,
        obsm = obsm,
        varm = varm,
        layers = layers,
        # raw = raw,
        dtype = dtype,
        shape = shape,
        filename = filename,
        filemode = filemode
      )
    },

    #' @description List keys of observation annotation `obs`.
    obs_keys = function() {
      private$.anndata$obs_keys()
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
    #' ad <- AnnDataR6$new(
    #'   X = matrix(rep(1, 6), nrow = 3),
    #'   obs = data.frame(field = c(1, 2, 3))
    #' )
    #' ad$obs_names <- c("a", "a", "b")
    #' ad$obs_names_make_unique()
    #' ad$obs_names
    obs_names_make_unique = function(join = "-") {
      private$.anndata$obs_names_make_unique(join = join)
    },

    #' @description List keys of observation annotation `obsm`.
    obsm_keys = function() {
      private$.anndata$obsm_keys()
    },

    #' @description List keys of variable annotation `var`.
    var_keys = function() {
      private$.anndata$var_keys()
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
    #' ad <- AnnDataR6$new(
    #'   X = matrix(rep(1, 6), nrow = 2),
    #'   var = data.frame(field = c(1, 2, 3))
    #' )
    #' ad$var_names <- c("a", "a", "b")
    #' ad$var_names_make_unique()
    #' ad$var_names
    var_names_make_unique = function(join = "-") {
      private$.anndata$var_names_make_unique(join = join)
    },

    #' @description List keys of variable annotation `varm`.
    varm_keys = function() {
      private$.anndata$varm_keys()
    },

    #' @description List keys of unstructured annotation `uns`.
    uns_keys = function() {
      private$.anndata$uns_keys()
    },

    #' @description Return a chunk of the data matrix `X` with random or specified indices.
    #'
    #' @param select Depending on the values:
    #'   * 1 integer: A random chunk with select rows will be returned.
    #'   * multiple integers: A chunk with these indices will be returned.
    #' @param replace if `select` is an integer then `TRUE` means random sampling of indices with replacement,
    #'   `FALSE` without replacement.
    chunk_X = function(select = 1000L, replace = TRUE) {
      private$.anndata$chunk_X(select = select, replace = replace)
    },


    #' @description Return an iterator over the rows of the data matrix X.
    #'
    #' @param chunk_size Row size of a single chunk.
    chunked_X = function(chunk_size = NULL) {
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
    copy = function(filename = NULL) {
      private$.anndata$copy(filename = filename)
    },

    #' @description Rename categories of annotation `key` in `obs`, `var`, and `uns`.
    #' Only supports passing a list/array-like `categories` argument.
    #' Besides calling `self.obs[key].cat.categories = categories` –
    #' similar for `var` - this also renames categories in unstructured
    #' annotation that uses the categorical annotation `key`.
    #'
    #' @param key Key for observations or variables annotation.
    #' @param categories New categories, the same number as the old categories.
    rename_categories = function(key, categories) {
      private$.anndata$rename_categories(key = key, categories = categories)
    },

    #' @description Transform string annotations to categoricals.
    #'
    #' Only affects string annotations that lead to less categories than the total number of observations.
    #'
    #' @param df If `df` is `NULL`, modifies both `obs` and `var`, otherwise modifies `df` inplace.
    strings_to_categoricals = function(df = NULL) {
      private$.anndata$strings_to_categoricals(df = df)
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
    to_df = function(layer = NULL) {
      private$.anndata$to_df(layer = layer)
    },

    #' @description transpose Transpose whole object.
    #'
    #' Data matrix is transposed, observations and variables are interchanged.
    #'
    #' Ignores `.raw`.
    transpose = function() {
      private$.anndata$transpose()
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
    #' write_csvs(ad, "output")
    #'
    #' unlink("output", recursive = TRUE)
    #' }
    write_csvs = function(dirname, skip_data = TRUE, sep = ",") {
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
    #' write_h5ad(ad, "output.h5ad")
    #'
    #' file.remove("output.h5ad")
    #' }
    write_h5ad = function(filename, compression = NULL, compression_opts = NULL, as_dense = list()) {
      private$.anndata$write_h5ad(
        filename = filename,
        compression = compression,
        compression_opts = compression_opts,
        as_dense = as_dense
      )
    },

    #' Write .loom-formatted hdf5 file.
    #'
    #' @param anndata An [AnnData()] object
    #' @param filename The filename.
    #' @param write_obsm_varm Whether or not to also write the varm and obsm.
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
    #' write_loom(ad, "output.loom")
    #'
    #' file.remove("output.loom")
    #' }
    write_loom = function(filename, write_obsm_varm = FALSE) {
      private$.anndata$write_loom(
        filename = filename,
        write_obsm_varm = write_obsm_varm
      )
    }
  )
)

#' @export
`dimnames.anndata._core.anndata.AnnData` <- function(x) {
  list(
    x$obs_names,
    x$var_names
  )
}
#' @export
dimnames.AnnDataR6 <- function(x) {
  list(
    x$obs_names,
    x$var_names
  )
}

#' @export
dim.anndata._core.anndata.AnnData <- function(x) {
  unlist(x$shape())
}
#' @export
dim.AnnDataR6 <- function(x) {
  x$shape()
}
