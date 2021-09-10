# anndata 0.7.5.3

* BUG FIX `write_h5ad(ad)`: Fix function pointer (#8).

* BUG FIX: Add manual converter function for converting a csc_matrix to dgCMatrix (#11).

# anndata 0.7.5.2

* MINOR CHANGE: Add getters and setter for the internal python objects.

* MINOR CHANGE: Alter how and when Python objects get converted to R and vice versa.

* DOCUMENTATION: Documentation site is available at https://anndata.dynverse.org!

* DOCUMENTATION: Added two basic vignettes.

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
