# anndata 0.7.5.1

* MINOR CHANGE: Add wrapper classes for Raw and Layers objects.

* MAJOR CHANGE: Calling `ad[..., ...]` now correctly returns a view of `ad` instead of returning a matrix.

* TESTING: Extend tests based on `theislab/anndata` repository.

# anndata 0.7.5 (2020-11-19)

* MINOR CHANGES: Updated Python requirements to anndata 0.7.5.

* NEW FEATURE `AnnData()`: Added `obsp`, `varp`, and `raw` objects to parameters.

* TESTING: Added more tests based on `theislab/anndata` repository.

# anndata 0.7.4 (2020-11-04)

* Initial release
