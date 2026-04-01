# Convert between Python and R objects

Convert between Python and R objects

## Usage

``` r
# S3 method for class 'collections.abc.MutableMapping'
x[[name]] <- value

# S3 method for class 'collections.abc.Mapping'
x[[name]]

# S3 method for class 'collections.abc.MutableMapping'
x[name] <- value

# S3 method for class 'collections.abc.Mapping'
x[name]

# S3 method for class 'collections.abc.Mapping'
names(x)

# S3 method for class 'collections.abc.Set'
py_to_r(x)

# S3 method for class 'pandas.core.indexes.base.Index'
py_to_r(x)

# S3 method for class 'collections.abc.KeysView'
py_to_r(x)

# S3 method for class 'collections.abc.Mapping'
py_to_r(x)

# S3 method for class 'anndata.abc._AbstractCSDataset'
py_to_r(x)
```

## Arguments

- x:

  A Python object.

- name:

  A name

- value:

  A value

## Value

An R object, as converted from the Python object.
