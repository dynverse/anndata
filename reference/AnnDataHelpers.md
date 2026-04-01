# AnnData Helpers

AnnData Helpers

## Usage

``` r
# S3 method for class 'AnnDataR6'
dimnames(x)

# S3 method for class 'AnnDataR6'
dimnames(x) <- value

# S3 method for class 'AnnDataR6'
dim(x)

# S3 method for class 'AnnDataR6'
as.data.frame(x, row.names = NULL, optional = FALSE, layer = NULL, ...)

# S3 method for class 'AnnDataR6'
as.matrix(x, layer = NULL, ...)

# S3 method for class 'AnnDataR6'
r_to_py(x, convert = FALSE)

# S3 method for class 'anndata._core.anndata.AnnData'
py_to_r(x)

# S3 method for class 'AnnDataR6'
x[oidx, vidx]

# S3 method for class 'AnnDataR6'
t(x)

# S3 method for class 'anndata._core.sparse_dataset.SparseDataset'
py_to_r(x)

# S3 method for class 'h5py._hl.dataset.Dataset'
py_to_r(x)
```

## Arguments

- x:

  An AnnData object.

- value:

  a possible valie for `dimnames(ad)`. The dimnames of a AnnData can be
  `NULL` (which is not stored) or a list of the same length as
  `dim(ad)`. If a list, its components are either NULL or a character
  vector with positive length of the appropriate dimension of `ad`.

- row.names:

  Not used.

- optional:

  Not used.

- layer:

  An AnnData layer. If `NULL`, will use `ad$X`, otherwise
  `ad$layers[layer]`.

- ...:

  Parameters passed to the underlying function.

- convert:

  Not used.

- oidx:

  Observation indices

- vidx:

  Variable indices

## Examples

``` r
if (FALSE) { # \dontrun{
ad <- AnnData(
  X = matrix(c(0, 1, 2, 3, 4, 5), nrow = 2),
  obs = data.frame(group = c("a", "b"), row.names = c("s1", "s2")),
  var = data.frame(type = c(1L, 2L, 3L), row.names = c("var1", "var2", "var3")),
  layers = list(
    spliced = matrix(c(4, 5, 6, 7, 8, 9), nrow = 2),
    unspliced = matrix(c(8, 9, 10, 11, 12, 13), nrow = 2)
  ),
  obsm = list(
    ones = matrix(rep(1L, 10), nrow = 2),
    rand = matrix(rnorm(6), nrow = 2),
    zeros = matrix(rep(0L, 10), nrow = 2)
  ),
  varm = list(
    ones = matrix(rep(1L, 12), nrow = 3),
    rand = matrix(rnorm(6), nrow = 3),
    zeros = matrix(rep(0L, 12), nrow = 3)
  ),
  uns = list(a = 1, b = 2, c = list(c.a = 3, c.b = 4))
)

dimnames(ad)
dim(ad)
as.data.frame(ad)
as.data.frame(ad, layer = "unspliced")
as.matrix(ad)
as.matrix(ad, layer = "unspliced")
ad[2, , drop = FALSE]
ad[, -1]
ad[, c("var1", "var2")]
} # }
```
