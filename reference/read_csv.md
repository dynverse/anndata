# read_csv

Read `.csv` file.

## Usage

``` r
read_csv(
  filename,
  delimiter = ",",
  first_column_names = NULL,
  dtype = "float32"
)
```

## Arguments

- filename:

  Data file.

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
[`read_text()`](https://anndata.dynverse.org/reference/read_text.md) but
with default delimiter `','`.

## Examples

``` r
if (FALSE) { # \dontrun{
ad <- read_csv("matrix.csv")
} # }
```
