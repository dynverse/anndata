# Layers Helpers

Layers Helpers

## Usage

``` r
# S3 method for class 'LayersR6'
names(x)

# S3 method for class 'LayersR6'
length(x)

# S3 method for class 'LayersR6'
r_to_py(x, convert = FALSE)

# S3 method for class 'anndata._core.aligned_mapping.LayersBase'
py_to_r(x)

# S3 method for class 'LayersR6'
x[name]

# S3 method for class 'LayersR6'
x[name] <- value

# S3 method for class 'LayersR6'
x[[name]]

# S3 method for class 'LayersR6'
x[[name]] <- value
```

## Arguments

- x:

  An AnnData object.

- convert:

  Not used.

- name:

  Name of the layer.

- value:

  Replacement value.

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
  )
)

ad$layers["spliced"]
ad$layers["test"] <- matrix(c(1, 3, 5, 7), nrow = 2)

length(ad$layers)
names(ad$layers)
} # }
```
