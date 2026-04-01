# read_mtx

**\[superseded\]** Read `.mtx` file.

## Usage

``` r
read_mtx(filename, dtype = "float32")
```

## Arguments

- filename:

  The filename.

- dtype:

  Numpy data type.

## Superseded

This function is superseded. Please use
[anndataR](https://anndataR.scverse.org) for reading and working with
`AnnData` objects in R. See
[`vignette("migration_to_anndataR", package = "anndata")`](https://anndata.dynverse.org/articles/migration_to_anndataR.md)
for migration guidance.

## Examples

``` r
if (FALSE) { # \dontrun{
ad <- read_mtx("matrix.mtx")
} # }
```
