# read_excel

Read `.xlsx` (Excel) file.

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

## Examples

``` r
if (FALSE) { # \dontrun{
ad <- read_excel("spreadsheet.xls")
} # }
```
