
# anndata for R

<!-- badges: start -->

[![CRAN](https://www.r-pkg.org/badges/version/anndata)](https://cran.r-project.org/package=anndata)
[![CRAN
Downloads](https://cranlogs.r-pkg.org/badges/anndata)](https://cran.r-project.org/package=anndata)
[![R-CMD-check](https://github.com/dynverse/anndata/workflows/R-CMD-check/badge.svg)](https://github.com/dynverse/anndata/actions)
[![Codecov test
coverage](https://app.codecov.io/gh/dynverse/anndata/branch/main/graph/badge.svg)](https://app.codecov.io/gh/dynverse/anndata?branch=main)
<!-- badges: end -->

[`anndata`](https://anndata.readthedocs.io/en/latest/) is a commonly
used Python package for keeping track of data and learned annotations,
and can be used to read from and write to the h5ad file format. It is
also the main data format used in the scanpy python package (Wolf,
Angerer, and Theis 2018).

![](https://raw.githubusercontent.com/dynverse/anndata/master/man/readme_files/anndata_for_r.png)

However, using scanpy/anndata in R can be a major hassle. When trying to
read an h5ad file, R users could approach this problem in one of two
ways. A) You could read in the file manually (since it’s an H5 file),
but this involves a lot of manual work and a lot of understanding on how
the h5ad and H5 file formats work (also, expect major headaches from
cryptic hdf5r bugs). Or B) interact with scanpy and anndata through
reticulate, but run into issues converting some of the python objects
into R.

We recently published
[`anndata`](https://cran.r-project.org/package=anndata) on CRAN, which
is a reticulate wrapper for the Python package – with some syntax
sprinkled on top to make R users feel more at home.

anndata for R is still under active development at
[github.com/dynverse/anndata](https://github.com/dynverse/anndata). If
you encounter any issues, feel free to post an issue on GitHub!

## Installation

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
```

    ## 
    ## Attaching package: 'anndata'

    ## The following object is masked from 'package:readr':
    ## 
    ##     read_csv

``` r
ad <- read_h5ad("example_formats/pbmc_1k_protein_v3_processed.h5ad")

ad
```

    ## AnnData object with n_obs × n_vars = 713 × 33538
    ##     var: 'gene_ids', 'feature_types', 'genome', 'highly_variable', 'means', 'dispersions', 'dispersions_norm'
    ##     uns: 'hvgParameters', 'normalizationParameters', 'pca', 'pcaParameters'
    ##     obsm: 'X_pca'
    ##     varm: 'PCs'

``` r
Matrix::rowMeans(ad$X[1:10,])
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

-   [Getting
    started](https://anndata.dynverse.org/articles/getting_started.html)
-   [Demo with
    scanpy](https://anndata.dynverse.org/articles/scanpy_demo.html)

## Future work

In some cases, this package may still act more like a Python package
rather than an R package. Some more helper functions and helper classes
need to be defined in order to fully encapsulate `AnnData()` objects.
Examples are `ad$chunked_X(...)`, backed file modes, `read_zarr()` and
`ad$write_zarr()`.

## References

<div id="refs" class="references csl-bib-body hanging-indent">

<div id="ref-wolf_scanpylargescalesinglecell_2018" class="csl-entry">

Wolf, F Alexander, Philipp Angerer, and Fabian J Theis. 2018. “SCANPY:
Large-Scale Single-Cell Gene Expression Data Analysis.” *Genome Biology*
19 (February): 15. <https://doi.org/10.1186/s13059-017-1382-0>.

</div>

</div>
