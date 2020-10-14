# helper function to skip tests if we don't have the 'anndata' module
skip_if_no_anndata <- function() {
  have_anndata <- py_module_available("anndata")
  if (!have_anndata) {
    skip("anndata not available for testing")
  }
}
