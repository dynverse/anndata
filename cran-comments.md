This package is a reticulate wrapper for the Python package 'anndata'.

 > Please add more details about the package functionality and implemented
methods in your Description text.

Done!

--------------------------------------------------------------------------

> \dontrun{} should only be used if the example really cannot be executed
(e.g. because of missing additional software, missing API keys, ...) by
the user. That's why wrapping examples in \dontrun{} adds the comment
("# Not run:") as a warning for the user.
Does not seem necessary.
Please unwrap the examples if they are executable in < 5 sec, or replace
\dontrun{} with \donttest{}.

This package is a reticulate wrapper for the 'anndata' Python package. 
Since I cannot assume that the anndata package is installed on CRAN, 
the examples are wrapped in \donttext{}.

--------------------------------------------------------------------------

> Please add small executable examples in your Rd-files to illustrate the
use of the exported function but also enable automatic testing.

Done!

--------------------------------------------------------------------------

> Please do not modify the global environment (e.g. by using <<-) in your
functions. This is not allowed by the CRAN policies.

Here I am following the recommendations of RStudio related to making sure
my package is well bahaved on CRAN:

  https://rstudio.github.io/reticulate/articles/package.html#checking-and-testing-on-cran-1
  
In addition, I see several other CRAN packages importing python packages 
in a similar fashion.

--------------------------------------------------------------------------

## Test environments
* local R installation, R 4.0.2
* win-builder (devel)
* Github Actions: 
  - Windows, R 4.0
  - Mac OS X, R 4.0
  - Ubuntu, R 4.0
  - Ubuntu, R 3.6

## R CMD check results

0 errors | 0 warnings | 1 note

* This is a new release.
