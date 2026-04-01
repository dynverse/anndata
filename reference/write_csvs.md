# Write annotation to .csv files.

**\[superseded\]**

## Usage

``` r
write_csvs(anndata, dirname, skip_data = TRUE, sep = ",")
```

## Arguments

- anndata:

  An [`AnnData()`](https://anndata.dynverse.org/reference/AnnData.md)
  object

- dirname:

  Name of the directory to which to export.

- skip_data:

  Skip the data matrix `X`.

- sep:

  Separator for the data

## Details

It is not possible to recover the full AnnData from these files. Use
[`write_h5ad()`](https://anndata.dynverse.org/reference/write_h5ad.md)
for this.

## Superseded

This function is superseded. Please use
[anndataR](https://anndataR.scverse.org) for reading and working with
`AnnData` objects in R. See
[`vignette("migration_to_anndataR", package = "anndata")`](https://anndata.dynverse.org/articles/migration_to_anndataR.md)
for migration guidance.

## Examples

``` r
if (FALSE) { # \dontrun{
ad <- AnnData(
  X = matrix(c(0, 1, 2, 3), nrow = 2, byrow = TRUE),
  obs = data.frame(group = c("a", "b"), row.names = c("s1", "s2")),
  var = data.frame(type = c(1L, 2L), row.names = c("var1", "var2")),
  varm = list(
    ones = matrix(rep(1L, 10), nrow = 2),
    rand = matrix(rnorm(6), nrow = 2),
    zeros = matrix(rep(0L, 10), nrow = 2)
  ),
  uns = list(a = 1, b = 2, c = list(c.a = 3, c.b = 4))
)

write_csvs(ad, "output")

unlink("output", recursive = TRUE)
} # }
```
