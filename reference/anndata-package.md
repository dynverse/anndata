# anndata - Annotated Data

`anndata` provides a scalable way of keeping track of data and learned
annotations, and can be used to read from and write to the h5ad file
format. [`AnnData()`](https://anndata.dynverse.org/reference/AnnData.md)
stores a data matrix `X` together with annotations of observations `obs`
(`obsm`, `obsp`), variables `var` (`varm`, `varp`), and unstructured
annotations `uns`.

## Details

This package is, in essense, an R wrapper for the similarly named Python
package [`anndata`](https://anndata.readthedocs.io/en/latest/), with
some added functionality to support more R-like syntax. The version
number of the anndata R package is synced with the version number of the
python version.

Check out `?anndata` for a full list of the functions provided by this
package.

## Creating an AnnData object

- [`AnnData()`](https://anndata.dynverse.org/reference/AnnData.md)

## Concatenating two or more AnnData objects

- [`concat()`](https://anndata.dynverse.org/reference/concat.md)

## Reading an AnnData object from a file

- [`read_csv()`](https://anndata.dynverse.org/reference/read_csv.md)

- [`read_excel()`](https://anndata.dynverse.org/reference/read_excel.md)

- [`read_h5ad()`](https://anndata.dynverse.org/reference/read_h5ad.md)

- [`read_hdf()`](https://anndata.dynverse.org/reference/read_hdf.md)

- [`read_loom()`](https://anndata.dynverse.org/reference/read_loom.md)

- [`read_mtx()`](https://anndata.dynverse.org/reference/read_mtx.md)

- [`read_text()`](https://anndata.dynverse.org/reference/read_text.md)

- [`read_umi_tools()`](https://anndata.dynverse.org/reference/read_umi_tools.md)

## Writing an AnnData object to a file

- [`write_csvs()`](https://anndata.dynverse.org/reference/write_csvs.md)

- [`write_h5ad()`](https://anndata.dynverse.org/reference/write_h5ad.md)

- [`write_loom()`](https://anndata.dynverse.org/reference/write_loom.md)

## Install the `anndata` Python package

- [`install_anndata()`](https://anndata.dynverse.org/reference/install_anndata.md)

## See also

Useful links:

- <https://anndata.dynverse.org>

- <https://github.com/dynverse/anndata>

- Report bugs at <https://github.com/dynverse/anndata/issues>

## Author

**Maintainer**: Robrecht Cannoodt <rcannood@gmail.com>
([ORCID](https://orcid.org/0000-0003-3641-729X)) \[copyright holder\]

Other contributors:

- Philipp Angerer <phil.angerer@gmail.com>
  ([ORCID](https://orcid.org/0000-0002-0369-2888)) \[conceptor\]

- Alex Wolf <f.alex.wolf@gmx.de>
  ([ORCID](https://orcid.org/0000-0002-8760-7838)) \[conceptor\]

- Isaac Virshup ([ORCID](https://orcid.org/0000-0002-1710-8945))
  \[conceptor\]

- Sergei Rybakov ([ORCID](https://orcid.org/0000-0002-4944-6586))
  \[conceptor\]

## Examples

``` r
if (FALSE) { # \dontrun{
ad <- AnnData(
  X = matrix(1:6, nrow = 2),
  obs = data.frame(group = c("a", "b"), row.names = c("s1", "s2")),
  var = data.frame(type = c(1L, 2L, 3L), row.names = c("var1", "var2", "var3")),
  layers = list(
    spliced = matrix(4:9, nrow = 2),
    unspliced = matrix(8:13, nrow = 2)
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
  uns = list(
    a = 1,
    b = data.frame(i = 1:3, j = 4:6, value = runif(3)),
    c = list(c.a = 3, c.b = 4)
  )
)

ad$X

ad$obs
ad$var

ad$obsm["ones"]
ad$varm["rand"]

ad$layers["unspliced"]
ad$layers["spliced"]

ad$uns["b"]

ad[, c("var1", "var2")]
ad[-1, , drop = FALSE]
ad[, 2] <- 10
} # }
```
