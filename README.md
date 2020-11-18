
[![Stars](https://img.shields.io/github/stars/theislab/anndata?logo=GitHub&color=yellow)](https://github.com/theislab/anndata/stargazers)
[![CRAN](https://www.r-pkg.org/badges/version/anndata)](https://cran.r-project.org/package=anndata)
[![Build
status](https://github.com/rcannood/anndata/workflows/R-CMD-check/badge.svg)](https://github.com/rcannood/anndata/actions)

# anndata - Annotated Data

`anndata` provides a scalable way of keeping track of data and learned
annotations, and can be used to read from and write to the h5ad file
format.

![anndata](http://falexwolf.de/img/scanpy/anndata.svg)

This package is, in essense, an R wrapper for the similarly named Python
package [`anndata`](https://anndata.readthedocs.io/en/latest/), with
some added functionality to support more R-like syntax. The version
number of the anndata R package is synced with the version number of the
python version.

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

    ##      [,1] [,2] [,3]
    ## [1,]    1    3    5
    ## [2,]    2    4    6

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

    ##      [,1] [,2] [,3] [,4] [,5]
    ## [1,]    1    1    1    1    1
    ## [2,]    1    1    1    1    1

``` r
ad$varm["rand"]
```

    ##              [,1]       [,2]
    ## [1,] -0.005767173 -0.7990092
    ## [2,]  2.404653389 -1.1476570
    ## [3,]  0.763593461 -0.2894616

``` r
ad$layers["unspliced"]
```

    ##      [,1] [,2] [,3]
    ## [1,]    8   10   12
    ## [2,]    9   11   13

``` r
ad$layers["spliced"]
```

    ##      [,1] [,2] [,3]
    ## [1,]    4    6    8
    ## [2,]    5    7    9

``` r
ad$uns["b"]
```

    ## $b
    ##    i  j     value
    ## 0  1  4  0.265509
    ## 1  2  5  0.372124
    ## 2  3  6  0.572853

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

### AnnData as a matrix

An `AnnData` object can be used as an R matrix:

``` r
ad[,c("var1", "var2")]
```

    ##    var1 var2
    ## s1    1    3
    ## s2    2    4

``` r
ad[-1, , drop = FALSE]
```

    ##    var1 var2 var3
    ## s2    2    4    6

``` r
ad[, 2] <- 10
```

You can simply use `ad[]` to get quick access to the `X` matrix, or add
in `layer="unspliced"` to switch to a different layer.

``` r
ad[]
```

    ##    var1 var2 var3
    ## s1    1   10    5
    ## s2    2   10    6

``` r
ad[layer="unspliced"]
```

    ##    var1 var2 var3
    ## s1    8   10   12
    ## s2    9   11   13

``` r
ad[,c("var2", "var3"),layer="unspliced"]
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
    ##      [,1] [,2] [,3]
    ## [1,]    1   10    5
    ## [2,]    2   10    6
    ## 
    ## $ad2
    ##      [,1] [,2] [,3]
    ## [1,]    1   10    5
    ## [2,]    2   10    6

This is standard Python behaviour but not R. In order to have two
separate copies of an AnnData object, use the `$copy()` function:

``` r
ad3 <- ad$copy()

ad$X[,2] <- c(3, 4)

list(ad = ad$X, ad3 = ad3$X)
```

    ## $ad
    ##      [,1] [,2] [,3]
    ## [1,]    1    3    5
    ## [2,]    2    4    6
    ## 
    ## $ad3
    ##      [,1] [,2] [,3]
    ## [1,]    1   10    5
    ## [2,]    2   10    6

## Future work

In some cases, this package may still act more like a Python package
rather than an R package. Some more helper functions and helper classes
need to be defined in order to fully encapsulate `AnnData()` objects.
Examples are:

``` r
ad$layers
```

    ## Layers with keys: spliced, unspliced

``` r
ad$chunked_X(1)
```

    ## <generator object AnnData.chunked_X at 0x7f206c391970>

Following functionality has not been tested:

``` r
ad$rename_categories(...)
ad$strings_to_categoricals(...)
```

Currently not implemented are the `read_zarr()` and `ad$write_zarr()`
functions.
