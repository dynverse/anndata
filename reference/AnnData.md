# Create an Annotated Data Matrix

`AnnData` stores a data matrix `X` together with annotations of
observations `obs` (`obsm`, `obsp`), variables `var` (`varm`, `varp`),
and unstructured annotations `uns`.

An `AnnData` object `adata` can be sliced like a data frame, for
instance `adata_subset <- adata[, list_of_variable_names]`. `AnnData`’s
basic structure is similar to R's ExpressionSet.

If setting an `h5ad`-formatted HDF5 backing file `filename`, data
remains on the disk but is automatically loaded into memory if needed.
See this [blog
post](https://falexwolf.de/blog/171223_AnnData_indexing_views_HDF5-backing/)
for more details.

## Usage

``` r
AnnData(
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
)
```

## Arguments

- X:

  A \#observations × \#variables data matrix. A view of the data is used
  if the data type matches, otherwise, a copy is made.

- obs:

  Key-indexed one-dimensional observations annotation of length
  \#observations.

- var:

  Key-indexed one-dimensional variables annotation of length
  \#variables.

- uns:

  Key-indexed unstructured annotation.

- obsm:

  Key-indexed multi-dimensional observations annotation of length
  \#observations. If passing a `~numpy.ndarray`, it needs to have a
  structured datatype.

- varm:

  Key-indexed multi-dimensional variables annotation of length
  \#variables. If passing a `~numpy.ndarray`, it needs to have a
  structured datatype.

- layers:

  Key-indexed multi-dimensional arrays aligned to dimensions of `X`.

- raw:

  Store raw version of `X` and `var` as `$raw$X` and `$raw$var`.

- dtype:

  Data type used for storage.

- shape:

  Shape list (#observations, \#variables). Can only be provided if `X`
  is `NULL`.

- filename:

  Name of backing file. See
  [h5py.File](https://docs.h5py.org/en/latest/high/file.html#h5py.File).

- filemode:

  Open mode of backing file. See
  [h5py.File](https://docs.h5py.org/en/latest/high/file.html#h5py.File).

- obsp:

  Pairwise annotation of observations, a mutable mapping with array-like
  values.

- varp:

  Pairwise annotation of observations, a mutable mapping with array-like
  values.

## Details

`AnnData` stores observations (samples) of variables/features in the
rows of a matrix. This is the convention of the modern classics of
statistic and machine learning, the convention of dataframes both in R
and Python and the established statistics and machine learning packages
in Python (statsmodels, scikit-learn).

Single dimensional annotations of the observation and variables are
stored in the `obs` and `var` attributes as data frames. This is
intended for metrics calculated over their axes. Multi-dimensional
annotations are stored in `obsm` and `varm`, which are aligned to the
objects observation and variable dimensions respectively. Square
matrices representing graphs are stored in `obsp` and `varp`, with both
of their own dimensions aligned to their associated axis. Additional
measurements across both observations and variables are stored in
`layers`.

Indexing into an AnnData object can be performed by relative position
with numeric indices, or by labels. To avoid ambiguity with numeric
indexing into observations or variables, indexes of the AnnData object
are converted to strings by the constructor.

Subsetting an AnnData object by indexing into it will also subset its
elements according to the dimensions they were aligned to. This means an
operation like `adata[list_of_obs, ]` will also subset `obs`, `obsm`,
and `layers`.

Subsetting an AnnData object returns a view into the original object,
meaning very little additional memory is used upon subsetting. This is
achieved lazily, meaning that the constituent arrays are subset on
access. Copying a view causes an equivalent “real” AnnData object to be
generated. Attempting to modify a view (at any attribute except X) is
handled in a copy-on-modify manner, meaning the object is initialized in
place. Here's an example

    batch1 <- adata[adata$obs["batch"] == "batch1", ]
    batch1$obs["value"] = 0 # This makes batch1 a “real” AnnData object

At the end of this snippet: `adata` was not modified, and `batch1` is
its own AnnData object with its own data.

Similar to Bioconductor’s `ExpressionSet` and `scipy.sparse` matrices,
subsetting an AnnData object retains the dimensionality of its
constituent arrays. Therefore, unlike with the classes exposed by
`pandas`, `numpy`, and `xarray`, there is no concept of a one
dimensional AnnData object. AnnDatas always have two inherent
dimensions, `obs` and `var`. Additionally, maintaining the
dimensionality of the AnnData object allows for consistent handling of
`scipy.sparse` matrices and `numpy` arrays.

## See also

[`read_h5ad()`](https://anndata.dynverse.org/reference/read_h5ad.md)
[`read_csv()`](https://anndata.dynverse.org/reference/read_csv.md)
[`read_excel()`](https://anndata.dynverse.org/reference/read_excel.md)
[`read_hdf()`](https://anndata.dynverse.org/reference/read_hdf.md)
[`read_loom()`](https://anndata.dynverse.org/reference/read_loom.md)
[`read_mtx()`](https://anndata.dynverse.org/reference/read_mtx.md)
[`read_text()`](https://anndata.dynverse.org/reference/read_text.md)
[`read_umi_tools()`](https://anndata.dynverse.org/reference/read_umi_tools.md)
[`write_h5ad()`](https://anndata.dynverse.org/reference/write_h5ad.md)
[`write_csvs()`](https://anndata.dynverse.org/reference/write_csvs.md)
[`write_loom()`](https://anndata.dynverse.org/reference/write_loom.md)

## Active bindings

- `X`:

  Data matrix of shape `n_obs` × `n_vars`.

- `filename`:

  Name of the backing file.

  Change to backing mode by setting the filename of a `.h5ad` file.

  - Setting the filename writes the stored data to disk.

  - Setting the filename when the filename was previously another name
    moves the backing file from the previous file to the new file. If
    you want to copy the previous file, use
    `copy(filename='new_filename')`.

- `layers`:

  A list-like object with values of the same dimensions as `X`. Layers
  in AnnData are inspired by [loompy's
  layers](https://linnarssonlab.org/loompy/apiwalkthrough/index.html#loomlayers).

  Overwrite the layers:

      adata$layers <- list(spliced = spliced, unspliced = unspliced)

  Return the layer named `"unspliced"`:

      adata$layers["unspliced"]

  Create or replace the `"spliced"` layer:

      adata$layers["spliced"] = example_matrix

  Assign the 10th column of layer `"spliced"` to the variable a:

      a <- adata$layers["spliced"][, 10]

  Delete the `"spliced"`:

      adata$layers["spliced"] <- NULL

  Return layers' names:

      names(adata$layers)

- `T`:

  Transpose whole object.

  Data matrix is transposed, observations and variables are
  interchanged.

  Ignores `.raw`.

- `is_view`:

  `TRUE` if object is view of another AnnData object, `FALSE` otherwise.

- `isbacked`:

  `TRUE` if object is backed on disk, `FALSE` otherwise.

- `n_obs`:

  Number of observations.

- `obs`:

  One-dimensional annotation of observations (data.frame).

- `obs_names`:

  Names of observations.

- `obsm`:

  Multi-dimensional annotation of observations (matrix).

  Stores for each key a two or higher-dimensional matrix with `n_obs`
  rows.

- `obsp`:

  Pairwise annotation of observations, a mutable mapping with array-like
  values.

  Stores for each key a two or higher-dimensional matrix whose first two
  dimensions are of length `n_obs`.

- `n_vars`:

  Number of variables.

- `var`:

  One-dimensional annotation of variables (data.frame).

- `var_names`:

  Names of variables.

- `varm`:

  Multi-dimensional annotation of variables (matrix).

  Stores for each key a two or higher-dimensional matrix with `n_vars`
  rows.

- `varp`:

  Pairwise annotation of variables, a mutable mapping with array-like
  values.

  Stores for each key a two or higher-dimensional matrix whose first two
  dimensions are of length `n_vars`.

- `shape`:

  Shape of data matrix (`n_obs`, `n_vars`).

- `uns`:

  Unstructured annotation (ordered dictionary).

- `raw`:

  Store raw version of `X` and `var` as `$raw$X` and `$raw$var`.

  The `raw` attribute is initialized with the current content of an
  object by setting:

      adata$raw = adata

  Its content can be deleted:

      adata$raw <- NULL

  Upon slicing an AnnData object along the obs (row) axis, `raw` is also
  sliced. Slicing an AnnData object along the vars (columns) axis leaves
  `raw` unaffected. Note that you can call:

      adata$raw[, 'orig_variable_name']$X

  `to retrieve the data associated with a variable that might have been filtered out or "compressed away" in`X\`.

## Methods

### Public methods

- [`AnnDataR6$new()`](#method-AnnDataR6-new)

- [`AnnDataR6$obs_keys()`](#method-AnnDataR6-obs_keys)

- [`AnnDataR6$obs_names_make_unique()`](#method-AnnDataR6-obs_names_make_unique)

- [`AnnDataR6$obsm_keys()`](#method-AnnDataR6-obsm_keys)

- [`AnnDataR6$var_keys()`](#method-AnnDataR6-var_keys)

- [`AnnDataR6$var_names_make_unique()`](#method-AnnDataR6-var_names_make_unique)

- [`AnnDataR6$varm_keys()`](#method-AnnDataR6-varm_keys)

- [`AnnDataR6$uns_keys()`](#method-AnnDataR6-uns_keys)

- [`AnnDataR6$chunk_X()`](#method-AnnDataR6-chunk_X)

- [`AnnDataR6$chunked_X()`](#method-AnnDataR6-chunked_X)

- [`AnnDataR6$concatenate()`](#method-AnnDataR6-concatenate)

- [`AnnDataR6$copy()`](#method-AnnDataR6-copy)

- [`AnnDataR6$rename_categories()`](#method-AnnDataR6-rename_categories)

- [`AnnDataR6$strings_to_categoricals()`](#method-AnnDataR6-strings_to_categoricals)

- [`AnnDataR6$to_df()`](#method-AnnDataR6-to_df)

- [`AnnDataR6$transpose()`](#method-AnnDataR6-transpose)

- [`AnnDataR6$write_csvs()`](#method-AnnDataR6-write_csvs)

- [`AnnDataR6$write_h5ad()`](#method-AnnDataR6-write_h5ad)

- [`AnnDataR6$write_loom()`](#method-AnnDataR6-write_loom)

- [`AnnDataR6$write_zarr()`](#method-AnnDataR6-write_zarr)

- [`AnnDataR6$print()`](#method-AnnDataR6-print)

- [`AnnDataR6$.set_py_object()`](#method-AnnDataR6-.set_py_object)

- [`AnnDataR6$.get_py_object()`](#method-AnnDataR6-.get_py_object)

------------------------------------------------------------------------

### Method `new()`

Create a new AnnData object

#### Usage

    AnnDataR6$new(obj)

#### Arguments

- `obj`:

  A Python anndata object

#### Examples

    \dontrun{
    # use AnnData() instead of AnnDataR6$new()
    ad <- AnnData(
      X = matrix(c(0, 1, 2, 3), nrow = 2),
      obs = data.frame(group = c("a", "b"), row.names = c("s1", "s2")),
      var = data.frame(type = c(1L, 2L), row.names = c("var1", "var2"))
    )
    }

------------------------------------------------------------------------

### Method `obs_keys()`

List keys of observation annotation `obs`.

#### Usage

    AnnDataR6$obs_keys()

#### Examples

    \dontrun{
    ad <- AnnData(
      X = matrix(c(0, 1, 2, 3), nrow = 2),
      obs = data.frame(group = c("a", "b"), row.names = c("s1", "s2"))
    )
    ad$obs_keys()
    }

------------------------------------------------------------------------

### Method `obs_names_make_unique()`

Makes the index unique by appending a number string to each duplicate
index element: 1, 2, etc.

If a tentative name created by the algorithm already exists in the
index, it tries the next integer in the sequence.

The first occurrence of a non-unique value is ignored.

#### Usage

    AnnDataR6$obs_names_make_unique(join = "-")

#### Arguments

- `join`:

  The connecting string between name and integer (default: `"-"`).

#### Examples

    \dontrun{
    ad <- AnnData(
      X = matrix(rep(1, 6), nrow = 3),
      obs = data.frame(field = c(1, 2, 3))
    )
    ad$obs_names <- c("a", "a", "b")
    ad$obs_names_make_unique()
    ad$obs_names
    }

------------------------------------------------------------------------

### Method `obsm_keys()`

List keys of observation annotation `obsm`.

#### Usage

    AnnDataR6$obsm_keys()

#### Examples

    \dontrun{
    ad <- AnnData(
      X = matrix(c(0, 1, 2, 3), nrow = 2),
      obs = data.frame(group = c("a", "b"), row.names = c("s1", "s2")),
      obsm = list(
        ones = matrix(rep(1L, 10), nrow = 2),
        rand = matrix(rnorm(6), nrow = 2),
        zeros = matrix(rep(0L, 10), nrow = 2)
      )
    )
    ad$obs_keys()
    }

------------------------------------------------------------------------

### Method `var_keys()`

List keys of variable annotation `var`.

#### Usage

    AnnDataR6$var_keys()

#### Examples

    \dontrun{
    ad <- AnnData(
      X = matrix(c(0, 1, 2, 3), nrow = 2),
      var = data.frame(type = c(1L, 2L), row.names = c("var1", "var2"))
    )
    ad$var_keys()
    }

------------------------------------------------------------------------

### Method `var_names_make_unique()`

Makes the index unique by appending a number string to each duplicate
index element: 1, 2, etc.

If a tentative name created by the algorithm already exists in the
index, it tries the next integer in the sequence.

The first occurrence of a non-unique value is ignored.

#### Usage

    AnnDataR6$var_names_make_unique(join = "-")

#### Arguments

- `join`:

  The connecting string between name and integer (default: `"-"`).

#### Examples

    \dontrun{
    ad <- AnnData(
      X = matrix(rep(1, 6), nrow = 2),
      var = data.frame(field = c(1, 2, 3))
    )
    ad$var_names <- c("a", "a", "b")
    ad$var_names_make_unique()
    ad$var_names
    }

------------------------------------------------------------------------

### Method `varm_keys()`

List keys of variable annotation `varm`.

#### Usage

    AnnDataR6$varm_keys()

#### Examples

    \dontrun{
    ad <- AnnData(
      X = matrix(c(0, 1, 2, 3), nrow = 2),
      var = data.frame(type = c(1L, 2L), row.names = c("var1", "var2")),
      varm = list(
        ones = matrix(rep(1L, 10), nrow = 2),
        rand = matrix(rnorm(6), nrow = 2),
        zeros = matrix(rep(0L, 10), nrow = 2)
      )
    )
    ad$varm_keys()
    }

------------------------------------------------------------------------

### Method `uns_keys()`

List keys of unstructured annotation `uns`.

#### Usage

    AnnDataR6$uns_keys()

#### Examples

    \dontrun{
    ad <- AnnData(
      X = matrix(c(0, 1, 2, 3), nrow = 2),
      obs = data.frame(group = c("a", "b"), row.names = c("s1", "s2")),
      var = data.frame(type = c(1L, 2L), row.names = c("var1", "var2")),
      uns = list(a = 1, b = 2, c = list(c.a = 3, c.b = 4))
    )
    }

------------------------------------------------------------------------

### Method `chunk_X()`

Return a chunk of the data matrix `X` with random or specified indices.

#### Usage

    AnnDataR6$chunk_X(select = 1000L, replace = TRUE)

#### Arguments

- `select`:

  Depending on the values:

  - 1 integer: A random chunk with select rows will be returned.

  - multiple integers: A chunk with these indices will be returned.

- `replace`:

  if `select` is an integer then `TRUE` means random sampling of indices
  with replacement, `FALSE` without replacement.

#### Examples

    \dontrun{
    ad <- AnnData(
      X = matrix(runif(10000), nrow = 50)
    )

    ad$chunk_X(select = 10L) # 10 random samples
    ad$chunk_X(select = 1:3) # first 3 samples
    }

------------------------------------------------------------------------

### Method `chunked_X()`

Return an iterator over the rows of the data matrix X.

#### Usage

    AnnDataR6$chunked_X(chunk_size = NULL)

#### Arguments

- `chunk_size`:

  Row size of a single chunk.

#### Examples

    \dontrun{
    ad <- AnnData(
      X = matrix(runif(10000), nrow = 50)
    )
    ad$chunked_X(10)
    }

------------------------------------------------------------------------

### Method `concatenate()`

**\[deprecated\]**

Use [`concat()`](https://anndata.dynverse.org/reference/concat.md)
instead.

#### Usage

    AnnDataR6$concatenate(...)

#### Arguments

- `...`:

  Deprecated

------------------------------------------------------------------------

### Method `copy()`

Full copy, optionally on disk.

#### Usage

    AnnDataR6$copy(filename = NULL)

#### Arguments

- `filename`:

  Path to filename (default: `NULL`).

#### Examples

    \dontrun{
    ad <- AnnData(
      X = matrix(c(0, 1, 2, 3), nrow = 2)
    )
    ad$copy()
    ad$copy("file.h5ad")
    }

------------------------------------------------------------------------

### Method `rename_categories()`

Rename categories of annotation `key` in `obs`, `var`, and `uns`. Only
supports passing a list/array-like `categories` argument. Besides
calling `self.obs[key].cat.categories = categories` – similar for
`var` - this also renames categories in unstructured annotation that
uses the categorical annotation `key`.

#### Usage

    AnnDataR6$rename_categories(key, categories)

#### Arguments

- `key`:

  Key for observations or variables annotation.

- `categories`:

  New categories, the same number as the old categories.

#### Examples

    \dontrun{
    ad <- AnnData(
      X = matrix(c(0, 1, 2, 3), nrow = 2),
      obs = data.frame(group = c("a", "b"), row.names = c("s1", "s2"))
    )
    ad$rename_categories("group", c(a = "A", b = "B")) # ??
    }

------------------------------------------------------------------------

### Method `strings_to_categoricals()`

Transform string annotations to categoricals.

Only affects string annotations that lead to less categories than the
total number of observations.

#### Usage

    AnnDataR6$strings_to_categoricals(df = NULL)

#### Arguments

- `df`:

  If `df` is `NULL`, modifies both `obs` and `var`, otherwise modifies
  `df` inplace.

#### Examples

    \dontrun{
    ad <- AnnData(
      X = matrix(c(0, 1, 2, 3), nrow = 2),
      obs = data.frame(group = c("a", "b"), row.names = c("s1", "s2")),
      var = data.frame(type = c(1L, 2L), row.names = c("var1", "var2")),
    )
    ad$strings_to_categoricals() # ??
    }

------------------------------------------------------------------------

### Method `to_df()`

Generate shallow data frame.

The data matrix `X` is returned as data frame, where `obs_names` are the
rownames, and `var_names` the columns names.

No annotations are maintained in the returned object.

The data matrix is densified in case it is sparse.

#### Usage

    AnnDataR6$to_df(layer = NULL)

#### Arguments

- `layer`:

  Key for layers

#### Examples

    \dontrun{
    ad <- AnnData(
      X = matrix(c(0, 1, 2, 3), nrow = 2),
      obs = data.frame(group = c("a", "b"), row.names = c("s1", "s2")),
      var = data.frame(type = c(1L, 2L), row.names = c("var1", "var2")),
      layers = list(
        spliced = matrix(c(4, 5, 6, 7), nrow = 2),
        unspliced = matrix(c(8, 9, 10, 11), nrow = 2)
      )
    )

    ad$to_df()
    ad$to_df("unspliced")
    }

------------------------------------------------------------------------

### Method `transpose()`

transpose Transpose whole object.

Data matrix is transposed, observations and variables are interchanged.

Ignores `.raw`.

#### Usage

    AnnDataR6$transpose()

#### Examples

    \dontrun{
    ad <- AnnData(
      X = matrix(c(0, 1, 2, 3), nrow = 2),
      obs = data.frame(group = c("a", "b"), row.names = c("s1", "s2")),
      var = data.frame(type = c(1L, 2L), row.names = c("var1", "var2"))
    )

    ad$transpose()
    }

------------------------------------------------------------------------

### Method [`write_csvs()`](https://anndata.dynverse.org/reference/write_csvs.md)

Write annotation to .csv files.

It is not possible to recover the full AnnData from these files. Use
[`write_h5ad()`](https://anndata.dynverse.org/reference/write_h5ad.md)
for this.

#### Usage

    AnnDataR6$write_csvs(dirname, skip_data = TRUE, sep = ",")

#### Arguments

- `dirname`:

  Name of the directory to which to export.

- `skip_data`:

  Skip the data matrix `X`.

- `sep`:

  Separator for the data

- `anndata`:

  An `AnnData()` object

#### Examples

    \dontrun{
    ad <- AnnData(
      X = matrix(c(0, 1, 2, 3), nrow = 2),
      obs = data.frame(group = c("a", "b"), row.names = c("s1", "s2")),
      var = data.frame(type = c(1L, 2L), row.names = c("var1", "var2")),
      varm = list(
        ones = matrix(rep(1L, 10), nrow = 2),
        rand = matrix(rnorm(6), nrow = 2),
        zeros = matrix(rep(0L, 10), nrow = 2)
      ),
      uns = list(a = 1, b = 2, c = list(c.a = 3, c.b = 4))
    )

    ad$to_write_csvs("output")

    unlink("output", recursive = TRUE)
    }

------------------------------------------------------------------------

### Method [`write_h5ad()`](https://anndata.dynverse.org/reference/write_h5ad.md)

Write .h5ad-formatted hdf5 file.

Generally, if you have sparse data that are stored as a dense matrix,
you can dramatically improve performance and reduce disk space by
converting to a csr_matrix:

#### Usage

    AnnDataR6$write_h5ad(
      filename,
      compression = NULL,
      compression_opts = NULL,
      as_dense = list()
    )

#### Arguments

- `filename`:

  Filename of data file. Defaults to backing file.

- `compression`:

  See the h5py [filter
  pipeline](http://docs.h5py.org/en/latest/high/dataset.html#dataset-compression).
  Options are `"gzip"`, `"lzf"` or `NULL`.

- `compression_opts`:

  See the h5py [filter
  pipeline](http://docs.h5py.org/en/latest/high/dataset.html#dataset-compression).

- `as_dense`:

  Sparse in AnnData object to write as dense. Currently only supports
  `"X"` and `"raw/X"`.

#### Examples

    \dontrun{
    ad <- AnnData(
      X = matrix(c(0, 1, 2, 3), nrow = 2),
      obs = data.frame(group = c("a", "b"), row.names = c("s1", "s2")),
      var = data.frame(type = c(1L, 2L), row.names = c("var1", "var2")),
      varm = list(
        ones = matrix(rep(1L, 10), nrow = 2),
        rand = matrix(rnorm(6), nrow = 2),
        zeros = matrix(rep(0L, 10), nrow = 2)
      ),
      uns = list(a = 1, b = 2, c = list(c.a = 3, c.b = 4))
    )

    ad$write_h5ad("output.h5ad")

    file.remove("output.h5ad")
    }

------------------------------------------------------------------------

### Method [`write_loom()`](https://anndata.dynverse.org/reference/write_loom.md)

Write .loom-formatted hdf5 file.

#### Usage

    AnnDataR6$write_loom(filename, write_obsm_varm = FALSE)

#### Arguments

- `filename`:

  The filename.

- `write_obsm_varm`:

  Whether or not to also write the varm and obsm.

#### Examples

    \dontrun{
    ad <- AnnData(
      X = matrix(c(0, 1, 2, 3), nrow = 2),
      obs = data.frame(group = c("a", "b"), row.names = c("s1", "s2")),
      var = data.frame(type = c(1L, 2L), row.names = c("var1", "var2")),
      varm = list(
        ones = matrix(rep(1L, 10), nrow = 2),
        rand = matrix(rnorm(6), nrow = 2),
        zeros = matrix(rep(0L, 10), nrow = 2)
      ),
      uns = list(a = 1, b = 2, c = list(c.a = 3, c.b = 4))
    )

    ad$write_loom("output.loom")

    file.remove("output.loom")
    }

------------------------------------------------------------------------

### Method [`write_zarr()`](https://anndata.dynverse.org/reference/write_zarr.md)

Write a hierarchical Zarr array store.

#### Usage

    AnnDataR6$write_zarr(store, chunks = NULL)

#### Arguments

- `store`:

  The filename, a MutableMapping, or a Zarr storage class.

- `chunks`:

  Chunk size.

------------------------------------------------------------------------

### Method [`print()`](https://rdrr.io/r/base/print.html)

Print AnnData object

#### Usage

    AnnDataR6$print(...)

#### Arguments

- `...`:

  optional arguments to print method.

#### Examples

    \dontrun{
    ad <- AnnData(
      X = matrix(c(0, 1, 2, 3), nrow = 2),
      obs = data.frame(group = c("a", "b"), row.names = c("s1", "s2")),
      var = data.frame(type = c(1L, 2L), row.names = c("var1", "var2")),
      layers = list(
        spliced = matrix(c(4, 5, 6, 7), nrow = 2),
        unspliced = matrix(c(8, 9, 10, 11), nrow = 2)
      ),
      obsm = list(
        ones = matrix(rep(1L, 10), nrow = 2),
        rand = matrix(rnorm(6), nrow = 2),
        zeros = matrix(rep(0L, 10), nrow = 2)
      ),
      varm = list(
        ones = matrix(rep(1L, 10), nrow = 2),
        rand = matrix(rnorm(6), nrow = 2),
        zeros = matrix(rep(0L, 10), nrow = 2)
      ),
      uns = list(a = 1, b = 2, c = list(c.a = 3, c.b = 4))
    )

    ad$print()
    print(ad)
    }

------------------------------------------------------------------------

### Method `.set_py_object()`

Set internal Python object

#### Usage

    AnnDataR6$.set_py_object(obj)

#### Arguments

- `obj`:

  A python anndata object

------------------------------------------------------------------------

### Method `.get_py_object()`

Get internal Python object

#### Usage

    AnnDataR6$.get_py_object()

## Examples

``` r
if (FALSE) { # \dontrun{
ad <- AnnData(
  X = matrix(c(0, 1, 2, 3), nrow = 2),
  obs = data.frame(group = c("a", "b"), row.names = c("s1", "s2")),
  var = data.frame(type = c(1L, 2L), row.names = c("var1", "var2")),
  layers = list(
    spliced = matrix(c(4, 5, 6, 7), nrow = 2),
    unspliced = matrix(c(8, 9, 10, 11), nrow = 2)
  ),
  obsm = list(
    ones = matrix(rep(1L, 10), nrow = 2),
    rand = matrix(rnorm(6), nrow = 2),
    zeros = matrix(rep(0L, 10), nrow = 2)
  ),
  varm = list(
    ones = matrix(rep(1L, 10), nrow = 2),
    rand = matrix(rnorm(6), nrow = 2),
    zeros = matrix(rep(0L, 10), nrow = 2)
  ),
  uns = list(a = 1, b = 2, c = list(c.a = 3, c.b = 4))
)

value <- matrix(c(1, 2, 3, 4), nrow = 2)
ad$X <- value
ad$X

ad$layers
ad$layers["spliced"]
ad$layers["test"] <- value
ad$layers

ad$to_df()
ad$uns

as.matrix(ad)
as.matrix(ad, layer = "unspliced")
dim(ad)
rownames(ad)
colnames(ad)
} # }

## ------------------------------------------------
## Method `AnnDataR6$new`
## ------------------------------------------------

if (FALSE) { # \dontrun{
# use AnnData() instead of AnnDataR6$new()
ad <- AnnData(
  X = matrix(c(0, 1, 2, 3), nrow = 2),
  obs = data.frame(group = c("a", "b"), row.names = c("s1", "s2")),
  var = data.frame(type = c(1L, 2L), row.names = c("var1", "var2"))
)
} # }

## ------------------------------------------------
## Method `AnnDataR6$obs_keys`
## ------------------------------------------------

if (FALSE) { # \dontrun{
ad <- AnnData(
  X = matrix(c(0, 1, 2, 3), nrow = 2),
  obs = data.frame(group = c("a", "b"), row.names = c("s1", "s2"))
)
ad$obs_keys()
} # }

## ------------------------------------------------
## Method `AnnDataR6$obs_names_make_unique`
## ------------------------------------------------

if (FALSE) { # \dontrun{
ad <- AnnData(
  X = matrix(rep(1, 6), nrow = 3),
  obs = data.frame(field = c(1, 2, 3))
)
ad$obs_names <- c("a", "a", "b")
ad$obs_names_make_unique()
ad$obs_names
} # }

## ------------------------------------------------
## Method `AnnDataR6$obsm_keys`
## ------------------------------------------------

if (FALSE) { # \dontrun{
ad <- AnnData(
  X = matrix(c(0, 1, 2, 3), nrow = 2),
  obs = data.frame(group = c("a", "b"), row.names = c("s1", "s2")),
  obsm = list(
    ones = matrix(rep(1L, 10), nrow = 2),
    rand = matrix(rnorm(6), nrow = 2),
    zeros = matrix(rep(0L, 10), nrow = 2)
  )
)
ad$obs_keys()
} # }

## ------------------------------------------------
## Method `AnnDataR6$var_keys`
## ------------------------------------------------

if (FALSE) { # \dontrun{
ad <- AnnData(
  X = matrix(c(0, 1, 2, 3), nrow = 2),
  var = data.frame(type = c(1L, 2L), row.names = c("var1", "var2"))
)
ad$var_keys()
} # }

## ------------------------------------------------
## Method `AnnDataR6$var_names_make_unique`
## ------------------------------------------------

if (FALSE) { # \dontrun{
ad <- AnnData(
  X = matrix(rep(1, 6), nrow = 2),
  var = data.frame(field = c(1, 2, 3))
)
ad$var_names <- c("a", "a", "b")
ad$var_names_make_unique()
ad$var_names
} # }

## ------------------------------------------------
## Method `AnnDataR6$varm_keys`
## ------------------------------------------------

if (FALSE) { # \dontrun{
ad <- AnnData(
  X = matrix(c(0, 1, 2, 3), nrow = 2),
  var = data.frame(type = c(1L, 2L), row.names = c("var1", "var2")),
  varm = list(
    ones = matrix(rep(1L, 10), nrow = 2),
    rand = matrix(rnorm(6), nrow = 2),
    zeros = matrix(rep(0L, 10), nrow = 2)
  )
)
ad$varm_keys()
} # }

## ------------------------------------------------
## Method `AnnDataR6$uns_keys`
## ------------------------------------------------

if (FALSE) { # \dontrun{
ad <- AnnData(
  X = matrix(c(0, 1, 2, 3), nrow = 2),
  obs = data.frame(group = c("a", "b"), row.names = c("s1", "s2")),
  var = data.frame(type = c(1L, 2L), row.names = c("var1", "var2")),
  uns = list(a = 1, b = 2, c = list(c.a = 3, c.b = 4))
)
} # }

## ------------------------------------------------
## Method `AnnDataR6$chunk_X`
## ------------------------------------------------

if (FALSE) { # \dontrun{
ad <- AnnData(
  X = matrix(runif(10000), nrow = 50)
)

ad$chunk_X(select = 10L) # 10 random samples
ad$chunk_X(select = 1:3) # first 3 samples
} # }

## ------------------------------------------------
## Method `AnnDataR6$chunked_X`
## ------------------------------------------------

if (FALSE) { # \dontrun{
ad <- AnnData(
  X = matrix(runif(10000), nrow = 50)
)
ad$chunked_X(10)
} # }

## ------------------------------------------------
## Method `AnnDataR6$copy`
## ------------------------------------------------

if (FALSE) { # \dontrun{
ad <- AnnData(
  X = matrix(c(0, 1, 2, 3), nrow = 2)
)
ad$copy()
ad$copy("file.h5ad")
} # }

## ------------------------------------------------
## Method `AnnDataR6$rename_categories`
## ------------------------------------------------

if (FALSE) { # \dontrun{
ad <- AnnData(
  X = matrix(c(0, 1, 2, 3), nrow = 2),
  obs = data.frame(group = c("a", "b"), row.names = c("s1", "s2"))
)
ad$rename_categories("group", c(a = "A", b = "B")) # ??
} # }

## ------------------------------------------------
## Method `AnnDataR6$strings_to_categoricals`
## ------------------------------------------------

if (FALSE) { # \dontrun{
ad <- AnnData(
  X = matrix(c(0, 1, 2, 3), nrow = 2),
  obs = data.frame(group = c("a", "b"), row.names = c("s1", "s2")),
  var = data.frame(type = c(1L, 2L), row.names = c("var1", "var2")),
)
ad$strings_to_categoricals() # ??
} # }

## ------------------------------------------------
## Method `AnnDataR6$to_df`
## ------------------------------------------------

if (FALSE) { # \dontrun{
ad <- AnnData(
  X = matrix(c(0, 1, 2, 3), nrow = 2),
  obs = data.frame(group = c("a", "b"), row.names = c("s1", "s2")),
  var = data.frame(type = c(1L, 2L), row.names = c("var1", "var2")),
  layers = list(
    spliced = matrix(c(4, 5, 6, 7), nrow = 2),
    unspliced = matrix(c(8, 9, 10, 11), nrow = 2)
  )
)

ad$to_df()
ad$to_df("unspliced")
} # }

## ------------------------------------------------
## Method `AnnDataR6$transpose`
## ------------------------------------------------

if (FALSE) { # \dontrun{
ad <- AnnData(
  X = matrix(c(0, 1, 2, 3), nrow = 2),
  obs = data.frame(group = c("a", "b"), row.names = c("s1", "s2")),
  var = data.frame(type = c(1L, 2L), row.names = c("var1", "var2"))
)

ad$transpose()
} # }

## ------------------------------------------------
## Method `AnnDataR6$write_csvs`
## ------------------------------------------------

if (FALSE) { # \dontrun{
ad <- AnnData(
  X = matrix(c(0, 1, 2, 3), nrow = 2),
  obs = data.frame(group = c("a", "b"), row.names = c("s1", "s2")),
  var = data.frame(type = c(1L, 2L), row.names = c("var1", "var2")),
  varm = list(
    ones = matrix(rep(1L, 10), nrow = 2),
    rand = matrix(rnorm(6), nrow = 2),
    zeros = matrix(rep(0L, 10), nrow = 2)
  ),
  uns = list(a = 1, b = 2, c = list(c.a = 3, c.b = 4))
)

ad$to_write_csvs("output")

unlink("output", recursive = TRUE)
} # }

## ------------------------------------------------
## Method `AnnDataR6$write_h5ad`
## ------------------------------------------------

if (FALSE) { # \dontrun{
ad <- AnnData(
  X = matrix(c(0, 1, 2, 3), nrow = 2),
  obs = data.frame(group = c("a", "b"), row.names = c("s1", "s2")),
  var = data.frame(type = c(1L, 2L), row.names = c("var1", "var2")),
  varm = list(
    ones = matrix(rep(1L, 10), nrow = 2),
    rand = matrix(rnorm(6), nrow = 2),
    zeros = matrix(rep(0L, 10), nrow = 2)
  ),
  uns = list(a = 1, b = 2, c = list(c.a = 3, c.b = 4))
)

ad$write_h5ad("output.h5ad")

file.remove("output.h5ad")
} # }

## ------------------------------------------------
## Method `AnnDataR6$write_loom`
## ------------------------------------------------

if (FALSE) { # \dontrun{
ad <- AnnData(
  X = matrix(c(0, 1, 2, 3), nrow = 2),
  obs = data.frame(group = c("a", "b"), row.names = c("s1", "s2")),
  var = data.frame(type = c(1L, 2L), row.names = c("var1", "var2")),
  varm = list(
    ones = matrix(rep(1L, 10), nrow = 2),
    rand = matrix(rnorm(6), nrow = 2),
    zeros = matrix(rep(0L, 10), nrow = 2)
  ),
  uns = list(a = 1, b = 2, c = list(c.a = 3, c.b = 4))
)

ad$write_loom("output.loom")

file.remove("output.loom")
} # }

## ------------------------------------------------
## Method `AnnDataR6$print`
## ------------------------------------------------

if (FALSE) { # \dontrun{
ad <- AnnData(
  X = matrix(c(0, 1, 2, 3), nrow = 2),
  obs = data.frame(group = c("a", "b"), row.names = c("s1", "s2")),
  var = data.frame(type = c(1L, 2L), row.names = c("var1", "var2")),
  layers = list(
    spliced = matrix(c(4, 5, 6, 7), nrow = 2),
    unspliced = matrix(c(8, 9, 10, 11), nrow = 2)
  ),
  obsm = list(
    ones = matrix(rep(1L, 10), nrow = 2),
    rand = matrix(rnorm(6), nrow = 2),
    zeros = matrix(rep(0L, 10), nrow = 2)
  ),
  varm = list(
    ones = matrix(rep(1L, 10), nrow = 2),
    rand = matrix(rnorm(6), nrow = 2),
    zeros = matrix(rep(0L, 10), nrow = 2)
  ),
  uns = list(a = 1, b = 2, c = list(c.a = 3, c.b = 4))
)

ad$print()
print(ad)
} # }
```
