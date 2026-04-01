# read_excel

**\[superseded\]** Read `.xlsx` (Excel) file.

## Usage

``` r
read_excel(filename, sheet, dtype = "float32")
```

## Arguments

- filename:

  File name to read from.

- sheet:

  Name of sheet in Excel file.

- dtype:

  Numpy data type.

## Details

Assumes that the first columns stores the row names and the first row
the column names.

## Superseded

This function is superseded. Please use
[anndataR](https://anndataR.scverse.org) for reading and working with
`AnnData` objects in R. See
[`vignette("migration_to_anndataR", package = "anndata")`](https://anndata.dynverse.org/articles/migration_to_anndataR.md)
for migration guidance.

## Examples

``` r
if (FALSE) { # \dontrun{
ad <- read_excel("spreadsheet.xls")
} # }
```
