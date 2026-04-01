# Install anndata

**\[deprecated\]**

Needs to be run after installing the anndata R package.

## Usage

``` r
install_anndata(method = "auto", conda = "auto")
```

## Arguments

- method:

  Installation method. By default, "auto" automatically finds a method
  that will work in the local environment. Change the default to force a
  specific installation method. Note that the "virtualenv" method is not
  available on Windows.

- conda:

  The path to a `conda` executable. Use `"auto"` to allow `reticulate`
  to automatically find an appropriate `conda` binary. See **Finding
  Conda** and
  [`conda_binary()`](https://rstudio.github.io/reticulate/reference/conda-tools.html)
  for more details.

## Examples

``` r
if (FALSE) { # \dontrun{
reticulate::conda_install()
install_anndata()
} # }
```
