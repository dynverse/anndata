# read_text

**\[superseded\]** Read `.txt`, `.tab`, `.data` (text) file.

## Usage

``` r
read_text(
  filename,
  delimiter = NULL,
  first_column_names = NULL,
  dtype = "float32"
)
```

## Arguments

- filename:

  Data file, filename or stream.

- delimiter:

  Delimiter that separates data within text file. If `NULL`, will split
  at arbitrary number of white spaces, which is different from enforcing
  splitting at single white space `' '`.

- first_column_names:

  Assume the first column stores row names.

- dtype:

  Numpy data type.

## Details

Same as
[`read_csv()`](https://anndata.dynverse.org/reference/read_csv.md) but
with default delimiter `NULL`.

## Superseded

This function is superseded. Please use
[anndataR](https://anndataR.scverse.org) for reading and working with
`AnnData` objects in R. See
[`vignette("migration_to_anndataR", package = "anndata")`](https://anndata.dynverse.org/articles/migration_to_anndataR.md)
for migration guidance.

## Examples

``` r
if (FALSE) { # \dontrun{
ad <- read_text("matrix.tab")
} # }
```
