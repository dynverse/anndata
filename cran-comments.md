# anndata 0.8.0

This release updates uses the new package dependency management system in reticulate 1.41, and updates several other functions.

## Changelog

* FUNCTIONALITY: Added support for `read_zarr()` and `write_zarr()` (PR #33).

* BUG FIX: Use the right interface for the `all.equal()` function (PR #32).

* BUG FIX: Add `py_to_r` converter for `anndata.abc._AbstractCSDataset` (PR #34).

* MINOR CHANGES: Ignore python warnings when running tests (PR #34).

* MAJOR CHANGES: Update reticulate package dependency management (PR #36).

* MINOR CHANGES: Clean up roxygen code (PR #36).

* MINOR CHANGES: Use cli for generating errors (PR #36).

--------------------------------------------------------------------------

## Test environments
* local R installation
* win-builder (devel)
* Github Actions: 
  - Windows, R release
  - Mac OS X, R release
  - Ubuntu, R devel
  - Ubuntu, R release
  - Ubuntu, R oldrelease

── R CMD check results ───────────────────────────────────── anndata 0.8.0 ────
Duration: 34.9s

0 errors ✔ | 0 warnings ✔ | 0 notes ✔

## Reverse dependencies

```r
revdepcheck::revdep_check(num_workers = 4)
```

    ── INIT ────────────────────────────────────────────── Computing revdeps ──
    ── INSTALL ────────────────────────────────────────────────── 2 versions ──
    Installing CRAN version of anndata
    also installing the dependencies ‘rprojroot’, ‘Rcpp’, ‘RcppTOML’, ‘here’, ‘jsonlite’, ‘png’, ‘rappdirs’, ‘rlang’, ‘withr’, ‘assertthat’, ‘R6’, ‘reticulate’

    Installing DEV version of anndata
    Installing 15 packages: rprojroot, Rcpp, withr, rlang, rappdirs, png, jsonlite, here, RcppTOML, glue, cli, reticulate, R6, lifecycle, assertthat
    ── CHECK ──────────────────────────────────────────────────── 6 packages ──
    OK: 6
    BROKEN: 0
    Total time: 1 hour
