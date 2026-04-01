# Package index

## Package documentation

- [`anndata-package`](https://anndata.dynverse.org/reference/anndata-package.md)
  [`anndata`](https://anndata.dynverse.org/reference/anndata-package.md)
  **\[superseded\]** : anndata - Annotated Data

## Creating an AnnData object

- [`AnnData()`](https://anndata.dynverse.org/reference/AnnData.md) :
  Create an Annotated Data Matrix

## Concatenating two or more AnnData objects

- [`concat()`](https://anndata.dynverse.org/reference/concat.md)
  **\[superseded\]** : concat

## Reading an AnnData object from a file

- [`read_csv()`](https://anndata.dynverse.org/reference/read_csv.md)
  **\[superseded\]** : read_csv
- [`read_excel()`](https://anndata.dynverse.org/reference/read_excel.md)
  **\[superseded\]** : read_excel
- [`read_h5ad()`](https://anndata.dynverse.org/reference/read_h5ad.md)
  **\[superseded\]** : read_h5ad
- [`read_hdf()`](https://anndata.dynverse.org/reference/read_hdf.md)
  **\[superseded\]** : read_hdf
- [`read_loom()`](https://anndata.dynverse.org/reference/read_loom.md)
  **\[superseded\]** : read_loom
- [`read_mtx()`](https://anndata.dynverse.org/reference/read_mtx.md)
  **\[superseded\]** : read_mtx
- [`read_text()`](https://anndata.dynverse.org/reference/read_text.md)
  **\[superseded\]** : read_text
- [`read_umi_tools()`](https://anndata.dynverse.org/reference/read_umi_tools.md)
  **\[superseded\]** : read_umi_tools
- [`read_zarr()`](https://anndata.dynverse.org/reference/read_zarr.md)
  **\[superseded\]** : Read from a hierarchical Zarr array store.

## Writing an AnnData object to a file

- [`write_csvs()`](https://anndata.dynverse.org/reference/write_csvs.md)
  **\[superseded\]** : Write annotation to .csv files.
- [`write_h5ad()`](https://anndata.dynverse.org/reference/write_h5ad.md)
  **\[superseded\]** : Write .h5ad-formatted hdf5 file.
- [`write_loom()`](https://anndata.dynverse.org/reference/write_loom.md)
  **\[superseded\]** : Write .loom-formatted hdf5 file.
- [`write_zarr()`](https://anndata.dynverse.org/reference/write_zarr.md)
  **\[superseded\]** : Write a hierarchical Zarr array store.

## Installer

Helper function for installing the anndata Python package

- [`install_anndata()`](https://anndata.dynverse.org/reference/install_anndata.md)
  **\[deprecated\]** : Install anndata

## Helper functions / sugar syntax

- [`Layers()`](https://anndata.dynverse.org/reference/Layers.md) :
  Create a Layers object
- [`Raw()`](https://anndata.dynverse.org/reference/Raw.md) : Create a
  Raw object
- [`dimnames(`*`<AnnDataR6>`*`)`](https://anndata.dynverse.org/reference/AnnDataHelpers.md)
  [`` `dimnames<-`( ``*`<AnnDataR6>`*`)`](https://anndata.dynverse.org/reference/AnnDataHelpers.md)
  [`dim(`*`<AnnDataR6>`*`)`](https://anndata.dynverse.org/reference/AnnDataHelpers.md)
  [`as.data.frame(`*`<AnnDataR6>`*`)`](https://anndata.dynverse.org/reference/AnnDataHelpers.md)
  [`as.matrix(`*`<AnnDataR6>`*`)`](https://anndata.dynverse.org/reference/AnnDataHelpers.md)
  [`r_to_py(`*`<AnnDataR6>`*`)`](https://anndata.dynverse.org/reference/AnnDataHelpers.md)
  [`py_to_r(`*`<anndata._core.anndata.AnnData>`*`)`](https://anndata.dynverse.org/reference/AnnDataHelpers.md)
  [`` `[`( ``*`<AnnDataR6>`*`)`](https://anndata.dynverse.org/reference/AnnDataHelpers.md)
  [`t(`*`<AnnDataR6>`*`)`](https://anndata.dynverse.org/reference/AnnDataHelpers.md)
  [`py_to_r(`*`<anndata._core.sparse_dataset.SparseDataset>`*`)`](https://anndata.dynverse.org/reference/AnnDataHelpers.md)
  [`py_to_r(`*`<h5py._hl.dataset.Dataset>`*`)`](https://anndata.dynverse.org/reference/AnnDataHelpers.md)
  : AnnData Helpers
- [`dimnames(`*`<RawR6>`*`)`](https://anndata.dynverse.org/reference/RawHelpers.md)
  [`dim(`*`<RawR6>`*`)`](https://anndata.dynverse.org/reference/RawHelpers.md)
  [`as.matrix(`*`<RawR6>`*`)`](https://anndata.dynverse.org/reference/RawHelpers.md)
  [`r_to_py(`*`<RawR6>`*`)`](https://anndata.dynverse.org/reference/RawHelpers.md)
  [`py_to_r(`*`<anndata._core.raw.Raw>`*`)`](https://anndata.dynverse.org/reference/RawHelpers.md)
  [`` `[`( ``*`<RawR6>`*`)`](https://anndata.dynverse.org/reference/RawHelpers.md)
  : Raw Helpers
- [`all.equal(`*`<AnnDataR6>`*`)`](https://anndata.dynverse.org/reference/all.equal.md)
  [`all.equal(`*`<LayersR6>`*`)`](https://anndata.dynverse.org/reference/all.equal.md)
  [`all.equal(`*`<RawR6>`*`)`](https://anndata.dynverse.org/reference/all.equal.md)
  : Test if two objects objects are equal
- [`names(`*`<LayersR6>`*`)`](https://anndata.dynverse.org/reference/LayersHelpers.md)
  [`length(`*`<LayersR6>`*`)`](https://anndata.dynverse.org/reference/LayersHelpers.md)
  [`r_to_py(`*`<LayersR6>`*`)`](https://anndata.dynverse.org/reference/LayersHelpers.md)
  [`py_to_r(`*`<anndata._core.aligned_mapping.LayersBase>`*`)`](https://anndata.dynverse.org/reference/LayersHelpers.md)
  [`` `[`( ``*`<LayersR6>`*`)`](https://anndata.dynverse.org/reference/LayersHelpers.md)
  [`` `[<-`( ``*`<LayersR6>`*`)`](https://anndata.dynverse.org/reference/LayersHelpers.md)
  [`` `[[`( ``*`<LayersR6>`*`)`](https://anndata.dynverse.org/reference/LayersHelpers.md)
  [`` `[[<-`( ``*`<LayersR6>`*`)`](https://anndata.dynverse.org/reference/LayersHelpers.md)
  : Layers Helpers
- [`` `[[<-`( ``*`<collections.abc.MutableMapping>`*`)`](https://anndata.dynverse.org/reference/r-py-conversion.md)
  [`` `[[`( ``*`<collections.abc.Mapping>`*`)`](https://anndata.dynverse.org/reference/r-py-conversion.md)
  [`` `[<-`( ``*`<collections.abc.MutableMapping>`*`)`](https://anndata.dynverse.org/reference/r-py-conversion.md)
  [`` `[`( ``*`<collections.abc.Mapping>`*`)`](https://anndata.dynverse.org/reference/r-py-conversion.md)
  [`names(`*`<collections.abc.Mapping>`*`)`](https://anndata.dynverse.org/reference/r-py-conversion.md)
  [`py_to_r(`*`<collections.abc.Set>`*`)`](https://anndata.dynverse.org/reference/r-py-conversion.md)
  [`py_to_r(`*`<pandas.core.indexes.base.Index>`*`)`](https://anndata.dynverse.org/reference/r-py-conversion.md)
  [`py_to_r(`*`<collections.abc.KeysView>`*`)`](https://anndata.dynverse.org/reference/r-py-conversion.md)
  [`py_to_r(`*`<collections.abc.Mapping>`*`)`](https://anndata.dynverse.org/reference/r-py-conversion.md)
  [`py_to_r(`*`<anndata.abc._AbstractCSDataset>`*`)`](https://anndata.dynverse.org/reference/r-py-conversion.md)
  : Convert between Python and R objects
