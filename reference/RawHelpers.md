# Raw Helpers

Raw Helpers

## Usage

``` r
# S3 method for class 'RawR6'
dimnames(x)

# S3 method for class 'RawR6'
dim(x)

# S3 method for class 'RawR6'
as.matrix(x, ...)

# S3 method for class 'RawR6'
r_to_py(x, convert = FALSE)

# S3 method for class 'anndata._core.raw.Raw'
py_to_r(x)

# S3 method for class 'RawR6'
x[...]
```

## Arguments

- x:

  An AnnData object.

- ...:

  Parameters passed to the underlying function.

- convert:

  Not used.

## Examples

``` r
if (FALSE) { # \dontrun{
ad <- AnnData(
  X = matrix(c(0, 1, 2, 3, 4, 5), nrow = 2),
  obs = data.frame(group = c("a", "b"), row.names = c("s1", "s2")),
  var = data.frame(type = c(1L, 2L, 3L), row.names = c("var1", "var2", "var3")),
  layers = list(
    spliced = matrix(c(4, 5, 6, 7, 8, 9), nrow = 2),
    unspliced = matrix(c(8, 9, 10, 11, 12, 13), nrow = 2)
  ),
  obsm = list(
    ones = matrix(rep(1L, 10), nrow = 2),
    rand = matrix(rnorm(6), nrow = 2),
    zeros = matrix(rep(0L, 10), nrow = 2)
  ),
  varm = list(
    ones = matrix(rep(1L, 12), nrow = 3),
    rand = matrix(rnorm(6), nrow = 3),
    zeros = matrix(rep(0L, 12), nrow = 3)
  ),
  uns = list(a = 1, b = 2, c = list(c.a = 3, c.b = 4))
)
ad$raw <- ad

dimnames(ad$raw)
dim(ad$raw)
as.matrix(ad$raw)
ad$raw[2, , drop = FALSE]
ad$raw[, -1]
ad$raw[, c("var1", "var2")]
} # }
```
