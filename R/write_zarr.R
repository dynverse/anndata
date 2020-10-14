# #' Write a hierarchical Zarr array store.
# #'
# #' @param anndata An [AnnData()] object
# #' @param store The filename, a MutableMapping, or a Zarr storage class.
# #' @param chunks Chunk shape.
# #'
# #' @export
# #'
# #' @examples
# #' ad <- AnnData(
# #'   X = matrix(c(0, 1, 2, 3), nrow = 2, byrow = TRUE),
# #'   obs = data.frame(group = c("a", "b"), row.names = c("s1", "s2")),
# #'   var = data.frame(type = c(1L, 2L), row.names = c("var1", "var2")),
# #'   varm = list(
# #'     ones = matrix(rep(1L, 10), nrow = 2),
# #'     rand = matrix(rnorm(6), nrow = 2),
# #'     zeros = matrix(rep(0L, 10), nrow = 2)
# #'   ),
# #'   uns = list(a = 1, b = 2, c = list(c.a = 3, c.b = 4))
# #' )
# #'
# #' write_zarr(ad, "output.zarr")
# write_zarr <- function(anndata, store, chunks = NULL) {
#   anndata$write_zarr(
#     store = store,
#     chunks = chunks
#   )
# }
