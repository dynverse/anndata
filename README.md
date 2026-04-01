
# anndata for R

<!-- badges: start -->

[![CRAN](https://www.r-pkg.org/badges/version/anndata)](https://cran.r-project.org/package=anndata)
[![CRAN
Downloads](https://cranlogs.r-pkg.org/badges/anndata)](https://cran.r-project.org/package=anndata)
[![R-CMD-check](https://github.com/dynverse/anndata/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/dynverse/anndata/actions/workflows/R-CMD-check.yaml)
[![Codecov test
coverage](https://app.codecov.io/gh/dynverse/anndata/branch/main/graph/badge.svg)](https://app.codecov.io/gh/dynverse/anndata?branch=main)
[![Lifecycle:
superseded](https://img.shields.io/badge/lifecycle-superseded-blue.svg)](https://lifecycle.r-lib.org/articles/stages.html#superseded)
<!-- badges: end -->

> **⚠️ This package is superseded by
> [anndataR](https://anndataR.scverse.org).**
>
> `anndataR` provides a pure R implementation of the `AnnData` data
> structure — no Python required. It reads and writes `.h5ad` files
> natively and supports conversion to/from `SingleCellExperiment` and
> `Seurat` objects. New users should install `anndataR` from
> Bioconductor instead:
>
> ``` r
> BiocManager::install("anndataR")
> ```
>
> Existing users of `anndata` can follow the [migration
> guide](https://anndata.dynverse.org/articles/migration_to_anndataR.html)
> for guidance on switching to `anndataR`.

`anndata` for R is a `reticulate` wrapper for the Python `anndata`
package.

## Installation

> **Note:** New projects should use
> [anndataR](https://anndataR.scverse.org) instead. See
> the [migration
> guide](https://anndata.dynverse.org/articles/migration_to_anndataR.html).

You can install `anndata` for R from CRAN as follows:

``` r
install.packages("anndata")
```

Normally, reticulate should take care of installing Miniconda and the
Python anndata.

If not, try running:

``` r
reticulate::install_miniconda()
anndata::install_anndata()
```

## Getting started

The API of anndata for R is very similar to its Python counterpart. Here
is an example:

``` r
library(anndata)

ad <- read_h5ad("example_formats/pbmc_1k_protein_v3_processed.h5ad")

ad
```

    ## AnnData object with n_obs × n_vars = 713 × 33538
    ##     var: 'gene_ids', 'feature_types', 'genome', 'highly_variable', 'means', 'dispersions', 'dispersions_norm'
    ##     uns: 'hvgParameters', 'normalizationParameters', 'pca', 'pcaParameters'
    ##     obsm: 'X_pca'
    ##     varm: 'PCs'

``` r
Matrix::rowMeans(ad$X[1:10, ])
```

    ## AAACCCAAGTGGTCAG-1 AAAGGTATCAACTACG-1 AAAGTCCAGCGTGTCC-1 AACACACTCAAGAGTA-1 
    ##         0.06499579         0.06385104         0.06102355         0.06739055 
    ## AACACACTCGACGAGA-1 AACAGGGCAGGAGGTT-1 AACAGGGCAGTGTATC-1 AACAGGGTCAGAATAG-1 
    ##         0.08891241         0.08648681         0.09318970         0.09140243 
    ## AACCTGAAGATGGTCG-1 AACGGGATCGTTATCT-1 
    ##         0.06664118         0.07866523

See `?anndata` for a full list of the functions provided by this
package. Check out any of the other vignettes by clicking any of the
links below:

- [Getting
  started](https://anndata.dynverse.org/articles/getting_started.html)
- [Migrating from anndata to
  anndataR](https://anndata.dynverse.org/articles/migration_to_anndataR.html)
- [Demo with
  scanpy](https://anndata.dynverse.org/articles/scanpy_demo.html)

## Future work

This package is no longer under active development as it has been
superseded by [anndataR](https://anndataR.scverse.org).
Bug fixes may still be applied, but no new features are planned.

## References
