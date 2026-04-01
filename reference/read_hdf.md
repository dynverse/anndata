# read_hdf

Read `.h5` (hdf5) file.

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

## Examples

``` r
if (FALSE) { # \dontrun{
ad <- read_hdf("file.h5")
} # }
```
