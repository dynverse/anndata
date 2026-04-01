# Create a Raw object

Create a Raw object

## Usage

``` r
Raw(adata, X = NULL, var = NULL, varm = NULL)
```

## Arguments

- adata:

  An AnnData object.

- X:

  A \#observations × \#variables data matrix.

- var:

  Key-indexed one-dimensional variables annotation of length
  \#variables.

- varm:

  Key-indexed multi-dimensional variables annotation of length
  \#variables.

## Active bindings

- `X`:

  Data matrix of shape `n_obs` × `n_vars`.

- `n_obs`:

  Number of observations.

- `obs_names`:

  Names of observations.

- `n_vars`:

  Number of variables.

- `var`:

  One-dimensional annotation of variables (data.frame).

- `var_names`:

  Names of variables.

- `varm`:

  Multi-dimensional annotation of variables (matrix).

  Stores for each key a two or higher-dimensional matrix with `n_var`
  rows.

- `shape`:

  Shape of data matrix (`n_obs`, `n_vars`).

## Methods

### Public methods

- [`RawR6$new()`](#method-RawR6-new)

- [`RawR6$copy()`](#method-RawR6-copy)

- [`RawR6$to_adata()`](#method-RawR6-to_adata)

- [`RawR6$print()`](#method-RawR6-print)

- [`RawR6$.set_py_object()`](#method-RawR6-.set_py_object)

- [`RawR6$.get_py_object()`](#method-RawR6-.get_py_object)

------------------------------------------------------------------------

### Method `new()`

Create a new Raw object

#### Usage

    RawR6$new(obj)

#### Arguments

- `obj`:

  A Python Raw object

------------------------------------------------------------------------

### Method `copy()`

Full copy, optionally on disk.

#### Usage

    RawR6$copy()

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

### Method `to_adata()`

Create a full AnnData object

#### Usage

    RawR6$to_adata()

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
    ad$raw <- ad

    ad$raw$to_adata()
    }

------------------------------------------------------------------------

### Method [`print()`](https://rdrr.io/r/base/print.html)

Print Raw object

#### Usage

    RawR6$print(...)

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
    ad$raw <- ad

    library(reticulate)
    sc <- import("scanpy")
    sc$pp$normalize_per_cell(ad)

    ad[]
    ad$raw[]

    ad$print()
    print(ad)
    }

------------------------------------------------------------------------

### Method `.set_py_object()`

Set internal Python object

#### Usage

    RawR6$.set_py_object(obj)

#### Arguments

- `obj`:

  A Python Raw object

------------------------------------------------------------------------

### Method `.get_py_object()`

Get internal Python object

#### Usage

    RawR6$.get_py_object()

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
ad$raw <- ad

library(reticulate)
sc <- import("scanpy")
sc$pp$normalize_per_cell(ad)

ad[]
ad$raw[]
} # }

## ------------------------------------------------
## Method `RawR6$copy`
## ------------------------------------------------

if (FALSE) { # \dontrun{
ad <- AnnData(
  X = matrix(c(0, 1, 2, 3), nrow = 2)
)
ad$copy()
ad$copy("file.h5ad")
} # }

## ------------------------------------------------
## Method `RawR6$to_adata`
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
ad$raw <- ad

ad$raw$to_adata()
} # }

## ------------------------------------------------
## Method `RawR6$print`
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
ad$raw <- ad

library(reticulate)
sc <- import("scanpy")
sc$pp$normalize_per_cell(ad)

ad[]
ad$raw[]

ad$print()
print(ad)
} # }
```
