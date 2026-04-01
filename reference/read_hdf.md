# read_hdf

**\[superseded\]** Read `.h5` (hdf5) file.

## Usage

``` r
read_hdf(filename, key)
```

## Arguments

- filename:

  Filename of data file.

- key:

  Name of dataset in the file.

## Details

Note: Also looks for fields `row_names` and `col_names`.

## Superseded

This function is superseded. Please use
[anndataR](https://anndataR.scverse.org) for reading and working with
`AnnData` objects in R. See
[`vignette("migration_to_anndataR", package = "anndata")`](https://anndata.dynverse.org/articles/migration_to_anndataR.md)
for migration guidance.

## Examples

``` r
if (FALSE) { # \dontrun{
ad <- read_hdf("file.h5")
} # }
```
