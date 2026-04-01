# Read from a hierarchical Zarr array store.

**\[superseded\]**

## Usage

``` r
read_zarr(store)
```

## Arguments

- store:

  The filename, a MutableMapping, or a Zarr storage class.

## Superseded

This function is superseded. Please use
[anndataR](https://anndataR.scverse.org) for reading and working with
`AnnData` objects in R. See
[`vignette("migration_to_anndataR", package = "anndata")`](https://anndata.dynverse.org/articles/migration_to_anndataR.md)
for migration guidance.

## Examples

``` r
if (FALSE) { # \dontrun{
ad <- read_zarr("...")
} # }
```
