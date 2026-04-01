# Changelog

## anndata 0.9.0

- SUPERSEDED: This package is superseded by `anndataR` on Bioconductor
  (<https://anndataR.scverse.org>). `anndataR` provides a pure R
  implementation of the `AnnData` data structure without requiring
  Python, along with native `.h5ad` file reading/writing and conversion
  to/from `SingleCellExperiment` and `Seurat` objects. A migration guide
  is available at
  [`vignette("migration_to_anndataR", package = "anndata")`](https://anndata.dynverse.org/articles/migration_to_anndataR.md).

## anndata 0.8.0

CRAN release: 2025-05-27

- FUNCTIONALITY: Added support for
  [`read_zarr()`](https://anndata.dynverse.org/reference/read_zarr.md)
  and
  [`write_zarr()`](https://anndata.dynverse.org/reference/write_zarr.md)
  (PR [\#33](https://github.com/dynverse/anndata/issues/33)).

- BUG FIX: Use the right interface for the
  [`all.equal()`](https://rdrr.io/pkg/Matrix/man/all.equal-methods.html)
  function (PR [\#32](https://github.com/dynverse/anndata/issues/32)).

- BUG FIX: Add `py_to_r` converter for `anndata.abc._AbstractCSDataset`
  (PR [\#34](https://github.com/dynverse/anndata/issues/34)).

- MINOR CHANGES: Ignore python warnings when running tests (PR
  [\#34](https://github.com/dynverse/anndata/issues/34)).

- MAJOR CHANGES: Update reticulate package dependency management (PR
  [\#36](https://github.com/dynverse/anndata/issues/36)).

- MINOR CHANGES: Clean up roxygen code (PR
  [\#36](https://github.com/dynverse/anndata/issues/36)).

- MINOR CHANGES: Use cli for generating errors (PR
  [\#36](https://github.com/dynverse/anndata/issues/36)).

## anndata 0.7.5.5

CRAN release: 2022-09-23

- FUNCTIONALITY: Added initial support for loading AnnData with
  `backed=TRUE`.

## anndata 0.7.5.4

CRAN release: 2022-08-23

- BUG FIX: Set dimnames on layer views as well
  ([\#16](https://github.com/dynverse/anndata/issues/16)).

- BUG FIX: Fix Github Actions for R CMD Check, test-coverage and
  pkgdown.

- DOCUMENTATION: Fix pkgdown config structure by adding missing topics.

- DOCUMENTATION: Regenerate the Rd files using the current CRAN version
  of roxygen2.

## anndata 0.7.5.3

CRAN release: 2021-09-10

- BUG FIX `write_h5ad(ad)`: Fix function pointer
  ([\#8](https://github.com/dynverse/anndata/issues/8)).

- BUG FIX: Add manual converter function for converting a csc_matrix to
  dgCMatrix ([\#11](https://github.com/dynverse/anndata/issues/11)).

## anndata 0.7.5.2

CRAN release: 2021-03-28

- MINOR CHANGE: Add getters and setter for the internal python objects.

- MINOR CHANGE: Alter how and when Python objects get converted to R and
  vice versa.

- DOCUMENTATION: Documentation site is available at
  <https://anndata.dynverse.org>!

- DOCUMENTATION: Added two basic vignettes.

## anndata 0.7.5.1

CRAN release: 2021-02-02

- MINOR CHANGE: Add wrapper classes for Raw and Layers objects.

- MAJOR CHANGE: Calling `ad[..., ...]` now correctly returns a view of
  `ad` instead of returning a matrix.

- TESTING: Extend tests based on `theislab/anndata` repository.

## anndata 0.7.5 (2020-11-19)

CRAN release: 2020-11-19

- MINOR CHANGES: Updated Python requirements to anndata 0.7.5.

- NEW FEATURE
  [`AnnData()`](https://anndata.dynverse.org/reference/AnnData.md):
  Added `obsp`, `varp`, and `raw` objects to parameters.

- TESTING: Added more tests based on `theislab/anndata` repository.

## anndata 0.7.4 (2020-11-04)

CRAN release: 2020-11-04

- Initial release
