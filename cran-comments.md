# anndata 0.7.5.3

* BUG FIX `write_h5ad(ad)`: Fix function pointer (#8).

* BUG FIX: Add manual converter function for converting a csc_matrix to dgCMatrix (#11).

--------------------------------------------------------------------------

## Test environments
* local R installation, R 4.0.3
* win-builder (devel)
* Github Actions: 
  - Windows, R 4.0
  - Mac OS X, R 4.0
  - Ubuntu, R 4.0
  - Ubuntu, R 3.6

## ── R CMD check results ──────────────────────────────────── anndata 0.7.5.2 ─
Duration: 55.7s

0 errors ✓ | 0 warnings ✓ | 0 notes ✓

R CMD check succeeded
