# Write .loom-formatted hdf5 file.

**\[superseded\]**

## Usage

``` r
write_loom(anndata, filename, write_obsm_varm = FALSE)
```

## Arguments

- anndata:

  An [`AnnData()`](https://anndata.dynverse.org/reference/AnnData.md)
  object

- filename:

  The filename.

- write_obsm_varm:

  Whether or not to also write the varm and obsm.

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

write_loom(ad, "output.loom")

file.remove("output.loom")
} # }
```
