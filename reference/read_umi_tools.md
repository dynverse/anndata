# read_umi_tools

**\[superseded\]** Read a gzipped condensed count matrix from umi_tools.

## Usage

``` r
read_umi_tools(filename, dtype = "float32")
```

## Arguments

- filename:

  File name to read from.

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
ad <- read_umi_tools("...")
} # }
```
