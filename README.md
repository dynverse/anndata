
[![Stars](https://img.shields.io/github/stars/theislab/anndata?logo=GitHub&color=yellow)](https://github.com/theislab/anndata/stargazers)
[![CRAN](https://www.r-pkg.org/badges/version/anndata)](https://cran.r-project.org/package=anndata)
[![Build
status](https://github.com/rcannood/anndata/workflows/R-CMD-check/badge.svg)](https://github.com/rcannood/anndata/actions)

# anndata - Annotated Data

`anndata` provides a scalable way of keeping track of data and learned
annotations, and can be used to read from and write to the h5ad file
format.

![anndata](http://falexwolf.de/img/scanpy/anndata.svg)

This package is an R wrapper for the Python package
[`anndata`](https://anndata.readthedocs.io/en/latest/), with some added
functionality to support more R-like syntax. The version number of the
anndata R package is synced with the version number of the python
version.

## Installation

``` r
# install the R anndata package
install.packages("anndata")

# run this only if you do not already have an installation of miniconda
reticulate::install_miniconda()

# install the Python anndata package
anndata::install_anndata()
```

## Getting started

The API of `anndata` is very similar to its Python counterpart. Check
out `?anndata` for a full list of the functions provided by this
package.

`AnnData` stores a data matrix `X` together with annotations of
observations `obs` (`obsm`, `obsp`), variables `var` (`varm`, `varp`),
and unstructured annotations `uns`.

Here is an example of an AnnData object with 2 observations and 3
variables.

``` r
library(anndata)

ad <- AnnData(
  X = matrix(1:6, nrow = 2),
  obs = data.frame(group = c("a", "b"), row.names = c("s1", "s2")),
  var = data.frame(type = c(1L, 2L, 3L), row.names = c("var1", "var2", "var3")),
  layers = list(
    spliced = matrix(4:9, nrow = 2),
    unspliced = matrix(8:13, nrow = 2)
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
  uns = list(
    a = 1, 
    b = data.frame(i = 1:3, j = 4:6, value = runif(3)),
    c = list(c.a = 3, c.b = 4)
  )
)

ad
```

    ## AnnData object with n_obs × n_vars = 2 × 3
    ##     obs: 'group'
    ##     var: 'type'
    ##     uns: 'a', 'b', 'c'
    ##     obsm: 'ones', 'rand', 'zeros'
    ##     varm: 'ones', 'rand', 'zeros'
    ##     layers: 'spliced', 'unspliced'

You can read the information back out using the `$` notation.

``` r
ad$X
```

    ##    var1 var2 var3
    ## s1    1    3    5
    ## s2    2    4    6

``` r
ad$obs
```

    ##    group
    ## s1     a
    ## s2     b

``` r
ad$var
```

    ##      type
    ## var1    1
    ## var2    2
    ## var3    3

``` r
ad$obsm["ones"]
```

    ## $ones
    ##      [,1] [,2] [,3] [,4] [,5]
    ## [1,]    1    1    1    1    1
    ## [2,]    1    1    1    1    1

``` r
ad$varm["rand"]
```

    ## $rand
    ##              [,1]       [,2]
    ## [1,] -0.005767173 -0.7990092
    ## [2,]  2.404653389 -1.1476570
    ## [3,]  0.763593461 -0.2894616

``` r
ad$layers["unspliced"]
```

    ##    var1 var2 var3
    ## s1    8   10   12
    ## s2    9   11   13

``` r
ad$layers["spliced"]
```

    ##    var1 var2 var3
    ## s1    4    6    8
    ## s2    5    7    9

``` r
ad$uns["b"]
```

    ## $b
    ##   i j     value
    ## 1 1 4 0.2655087
    ## 2 2 5 0.3721239
    ## 3 3 6 0.5728534

### Reading / writing AnnData objects

Read from h5ad format:

``` r
read_h5ad("example_formats/pbmc_1k_protein_v3_processed.h5ad")
```

    ## AnnData object with n_obs × n_vars = 713 × 33538
    ##     var: 'gene_ids', 'feature_types', 'genome', 'highly_variable', 'means', 'dispersions', 'dispersions_norm'
    ##     uns: 'hvgParameters', 'normalizationParameters', 'pca', 'pcaParameters'
    ##     obsm: 'X_pca'
    ##     varm: 'PCs'

### Creating a view

You can use any of the regular R indexing methods to subset the
`AnnData` object. This will result in a ‘View’ of the underlying data
without needing to store the same data twice.

``` r
view <- ad[, 2]
view
```

    ## View of AnnData object with n_obs × n_vars = 2 × 1
    ##     obs: 'group'
    ##     var: 'type'
    ##     uns: 'a', 'b', 'c'
    ##     obsm: 'ones', 'rand', 'zeros'
    ##     varm: 'ones', 'rand', 'zeros'
    ##     layers: 'spliced', 'unspliced'

``` r
view$is_view
```

    ## [1] TRUE

``` r
ad[,c("var1", "var2")]
```

    ## View of AnnData object with n_obs × n_vars = 2 × 2
    ##     obs: 'group'
    ##     var: 'type'
    ##     uns: 'a', 'b', 'c'
    ##     obsm: 'ones', 'rand', 'zeros'
    ##     varm: 'ones', 'rand', 'zeros'
    ##     layers: 'spliced', 'unspliced'

``` r
ad[-1, ]
```

    ## View of AnnData object with n_obs × n_vars = 1 × 3
    ##     obs: 'group'
    ##     var: 'type'
    ##     uns: 'a', 'b', 'c'
    ##     obsm: 'ones', 'rand', 'zeros'
    ##     varm: 'ones', 'rand', 'zeros'
    ##     layers: 'spliced', 'unspliced'

### AnnData as a matrix

The `X` attribute can be used as an R matrix:

``` r
ad$X[,c("var1", "var2")]
```

    ##    var1 var2
    ## s1    1    3
    ## s2    2    4

``` r
ad$X[-1, , drop = FALSE]
```

    ##    var1 var2 var3
    ## s2    2    4    6

``` r
ad$X[, 2] <- 10
```

You can access a different layer matrix as follows:

``` r
ad$layers["unspliced"]
```

    ##    var1 var2 var3
    ## s1    8   10   12
    ## s2    9   11   13

``` r
ad$layers["unspliced"][,c("var2", "var3")]
```

    ##    var2 var3
    ## s1   10   12
    ## s2   11   13

### Note on state

If you assign an AnnData object to another variable and modify either,
both will be modified:

``` r
ad2 <- ad

ad$X[,2] <- 10

list(ad = ad$X, ad2 = ad2$X)
```

    ## $ad
    ##    var1 var2 var3
    ## s1    1   10    5
    ## s2    2   10    6
    ## 
    ## $ad2
    ##    var1 var2 var3
    ## s1    1   10    5
    ## s2    2   10    6

This is standard Python behaviour but not R. In order to have two
separate copies of an AnnData object, use the `$copy()` function:

``` r
ad3 <- ad$copy()

ad$X[,2] <- c(3, 4)

list(ad = ad$X, ad3 = ad3$X)
```

    ## $ad
    ##    var1 var2 var3
    ## s1    1    3    5
    ## s2    2    4    6
    ## 
    ## $ad3
    ##    var1 var2 var3
    ## s1    1   10    5
    ## s2    2   10    6

### Interoperability with other Python packages

AnnData objects created by this package usually work together extremely
well with other Python packages imported with reticulate. You can pass
AnnData objects created by this package into Python packages and still
get easy to work with results\!

``` r
library(reticulate)

ad$raw <- ad

sc <- import("scanpy")
sc$pp$normalize_per_cell(ad)

ad$X
```

    ##        var1 var2     var3
    ## s1 1.166667  3.5 5.833333
    ## s2 1.750000  3.5 5.250000

``` r
ad$raw[]
```

    ##    var1 var2 var3
    ## s1    1    3    5
    ## s2    2    4    6

## Future work

In some cases, this package may still act more like a Python package
rather than an R package. Some more helper functions and helper classes
need to be defined in order to fully encapsulate `AnnData()` objects.
Examples are:

``` r
ad$chunked_X(1)
```

    ## <generator object AnnData.chunked_X at 0x7efddaff8040>

Following functionality has not been tested:

``` r
ad$rename_categories(...)
ad$strings_to_categoricals(...)
```

Currently not implemented are the `read_zarr()` and `ad$write_zarr()`
functions. Need some example data to test this functionality.

## Latest changes

Check out `news(package = "anndata")` or [NEWS.md](NEWS.md) for a full
list of changes.

<!-- This section gets automatically generated from NEWS.md -->

### Recent changes in anndata 0.7.5.1

  - MINOR CHANGE: Add wrapper classes for Raw and Layers objects.

  - MAJOR CHANGE: Calling `ad[..., ...]` now correctly returns a view of
    `ad` instead of returning a matrix.

### Recent changes in anndata 0.7.5 (2020-11-19)

  - MINOR CHANGES: Updated Python requirements to anndata 0.7.5.

  - NEW FEATURE `AnnData()`: Added `obsp`, `varp`, and `raw` objects to
    parameters.

  - TESTING: Added more tests based on `theislab/anndata` repository.
