# anndata 0.7.5.1

Version number is set to '0.7.5.1' to keep in sync with the Python package 'anndata' which is at version 0.7.5.

* MINOR CHANGE: Add wrapper classes for Raw and Layers objects.

* MAJOR CHANGE: Calling `ad[..., ...]` now correctly returns a view of `ad` instead of returning a matrix.

* TESTING: Extend tests based on `theislab/anndata` repository.

--------------------------------------------------------------------------

## Test environments
* local R installation, R 4.0.3
* win-builder (devel)
* Github Actions: 
  - Windows, R 4.0
  - Mac OS X, R 4.0
  - Ubuntu, R 4.0
  - Ubuntu, R 3.6

## R CMD check results

Duration: 42.7s

0 errors ✓ | 0 warnings ✓ | 0 notes ✓

R CMD check succeeded
