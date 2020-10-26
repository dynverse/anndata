# anndata - Annotated Data
#
# AnnData provides a scalable way of keeping track of data and learned annotations.


# For interfacing with python and anndata
#' @importFrom reticulate py_module_available import
#' @importFrom assertthat assert_that
NULL

# global reference to umap (will be initialized in .onLoad)
python_anndata <- NULL
python_builtins <- NULL
.onLoad <- function(libname, pkgname) {
  try(
    {
      python_anndata <<- reticulate::import("anndata", delay_load = TRUE)
      python_builtins <<- reticulate::import_builtins()
    },
    silent = TRUE
  )
}

# # populate R scripts
# funs <- names(python_anndata)
# is_fun <- purrr::map_lgl(funs, ~ is.function(python_anndata[[.]]))
# funs[!is_fun]
#
# for (fun in funs[is_fun]) {
#   cat("Processing python_anndata[[", fun, "]]\n", sep = "")
#   script <- paste0("R/", fun, ".R")
#   if (file.exists(script)) file.remove(script)
#   scaffolder::scaffold_py_function_wrapper(paste0("python_anndata$", fun), file_name = script)
#   if (file.exists(script)) {
#     readr::read_lines(script) %>%
#       gsub(":class:", "", ., fixed = TRUE) %>%
#       gsub(":attr:", "", ., fixed = TRUE) %>%
#       gsub(":doc:", "", ., fixed = TRUE) %>%
#       gsub("python_function_result <- ", "", ., fixed = TRUE) %>%
#       readr::write_lines(script)
#   }
# }
