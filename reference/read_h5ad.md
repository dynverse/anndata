# read_h5ad

Read `.h5ad`-formatted hdf5 file.

## Usage

``` r
read_h5ad(filename, backed = NULL)
```

## Arguments

- filename:

  File name of data file.

- backed:

  If `'r'`, load `~anndata.AnnData` in `backed` mode instead of fully
  loading it into memory (`memory` mode). If you want to modify backed
  attributes of the AnnData object, you need to choose `'r+'`.

## Examples

``` r
if (FALSE) { # \dontrun{
ad <- read_h5ad("example_formats/pbmc_1k_protein_v3_processed.h5ad")
} # }
```
