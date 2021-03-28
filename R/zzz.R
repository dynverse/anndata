# following advice from https://rstudio.github.io/reticulate/articles/python_dependencies.html#onload-configuration
# not sure what exactly this does yet, though
.onLoad <- function(libname, pkgname) {
  reticulate::configure_environment(pkgname)
}
