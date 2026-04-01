# read_loom

**\[superseded\]** Read `.loom`-formatted hdf5 file.

## Usage

``` r
read_loom(
  filename,
  sparse = TRUE,
  cleanup = FALSE,
  X_name = "spliced",
  obs_names = "CellID",
  obsm_names = NULL,
  var_names = "Gene",
  varm_names = NULL,
  dtype = "float32",
  ...
)
```

## Arguments

- filename:

  The filename.

- sparse:

  Whether to read the data matrix as sparse.

- cleanup:

  Whether to collapse all obs/var fields that only store one unique
  value into `.uns['loom-.']`.

- X_name:

  Loompy key with which the data matrix `AnnData.X` is initialized.

- obs_names:

  Loompy key where the observation/cell names are stored.

- obsm_names:

  Loompy keys which will be constructed into observation matrices

- var_names:

  Loompy key where the variable/gene names are stored.

- varm_names:

  Loompy keys which will be constructed into variable matrices

- dtype:

  Numpy data type.

- ...:

  Arguments to loompy.connect

## Details

This reads the whole file into memory. Beware that you have to
explicitly state when you want to read the file as sparse data.

## Superseded

This function is superseded. Please use
[anndataR](https://anndataR.scverse.org) for reading and working with
`AnnData` objects in R. See
[`vignette("migration_to_anndataR", package = "anndata")`](https://anndata.dynverse.org/articles/migration_to_anndataR.md)
for migration guidance.

## Examples

``` r
if (FALSE) { # \dontrun{
ad <- read_loom("dataset.loom")
} # }
```
