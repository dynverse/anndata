# Create a Layers object

Create a Layers object

## Usage

``` r
Layers(parent, vals = NULL)
```

## Arguments

- parent:

  An AnnData object.

- vals:

  A named list of matrices with the same dimensions as `parent`.

## Active bindings

- `parent`:

  Reference to parent AnnData view

## Methods

### Public methods

- [`LayersR6$new()`](#method-LayersR6-new)

- [`LayersR6$print()`](#method-LayersR6-print)

- [`LayersR6$get()`](#method-LayersR6-get)

- [`LayersR6$set()`](#method-LayersR6-set)

- [`LayersR6$del()`](#method-LayersR6-del)

- [`LayersR6$keys()`](#method-LayersR6-keys)

- [`LayersR6$length()`](#method-LayersR6-length)

- [`LayersR6$.set_py_object()`](#method-LayersR6-.set_py_object)

- [`LayersR6$.get_py_object()`](#method-LayersR6-.get_py_object)

------------------------------------------------------------------------

### Method `new()`

Create a new Layers object

#### Usage

    LayersR6$new(obj)

#### Arguments

- `obj`:

  A Python Layers object

------------------------------------------------------------------------

### Method [`print()`](https://rdrr.io/r/base/print.html)

Print Layers object

#### Usage

    LayersR6$print(...)

#### Arguments

- `...`:

  optional arguments to print method.

#### Examples

    \dontrun{
    ad <- AnnData(
      X = matrix(c(0, 1, 2, 3), nrow = 2),
      obs = data.frame(group = c("a", "b"), row.names = c("s1", "s2")),
      var = data.frame(type = c(1L, 2L), row.names = c("var1", "var2")),
      layers = list(
        spliced = matrix(c(4, 5, 6, 7), nrow = 2),
        unspliced = matrix(c(8, 9, 10, 11), nrow = 2)
      )
    )

    print(ad$layers)
    }

------------------------------------------------------------------------

### Method [`get()`](https://rdrr.io/r/base/get.html)

Get a layer

#### Usage

    LayersR6$get(name)

#### Arguments

- `name`:

  Name of the layer

------------------------------------------------------------------------

### Method `set()`

Set a layer

#### Usage

    LayersR6$set(name, value)

#### Arguments

- `name`:

  Name of the layer

- `value`:

  A matrix

------------------------------------------------------------------------

### Method `del()`

Delete a layer

#### Usage

    LayersR6$del(name)

#### Arguments

- `name`:

  Name of the layer

------------------------------------------------------------------------

### Method `keys()`

Get the names of the layers

#### Usage

    LayersR6$keys()

------------------------------------------------------------------------

### Method [`length()`](https://rdrr.io/r/base/length.html)

Get the number of layers

#### Usage

    LayersR6$length()

------------------------------------------------------------------------

### Method `.set_py_object()`

Set internal Python object

#### Usage

    LayersR6$.set_py_object(obj)

#### Arguments

- `obj`:

  A Python layers object

------------------------------------------------------------------------

### Method `.get_py_object()`

Get internal Python object

#### Usage

    LayersR6$.get_py_object()

## Examples

``` r
if (FALSE) { # \dontrun{
ad <- AnnData(
  X = matrix(c(0, 1, 2, 3), nrow = 2),
  obs = data.frame(group = c("a", "b"), row.names = c("s1", "s2")),
  var = data.frame(type = c(1L, 2L), row.names = c("var1", "var2")),
  layers = list(
    spliced = matrix(c(4, 5, 6, 7), nrow = 2),
    unspliced = matrix(c(8, 9, 10, 11), nrow = 2)
  )
)
ad$layers["spliced"]
ad$layers["test"] <- matrix(c(1, 3, 5, 7), nrow = 2)

length(ad$layers)
names(ad$layers)
} # }

## ------------------------------------------------
## Method `LayersR6$print`
## ------------------------------------------------

if (FALSE) { # \dontrun{
ad <- AnnData(
  X = matrix(c(0, 1, 2, 3), nrow = 2),
  obs = data.frame(group = c("a", "b"), row.names = c("s1", "s2")),
  var = data.frame(type = c(1L, 2L), row.names = c("var1", "var2")),
  layers = list(
    spliced = matrix(c(4, 5, 6, 7), nrow = 2),
    unspliced = matrix(c(8, 9, 10, 11), nrow = 2)
  )
)

print(ad$layers)
} # }
```
