#' Write .loom-formatted hdf5 file.
#'
#' @param anndata An [AnnData()] object
#' @param filename The filename.
#' @param write_obsm_varm Whether or not to also write the varm and obsm.
#'
#' @export
#'
#' @examples
#' \dontrun{
#' ad <- AnnData(
#'   X = matrix(c(0, 1, 2, 3), nrow = 2, byrow = TRUE),
#'   obs = data.frame(group = c("a", "b"), row.names = c("s1", "s2")),
#'   var = data.frame(type = c(1L, 2L), row.names = c("var1", "var2")),
#'   varm = list(
#'     ones = matrix(rep(1L, 10), nrow = 2),
#'     rand = matrix(rnorm(6), nrow = 2),
#'     zeros = matrix(rep(0L, 10), nrow = 2)
#'   ),
#'   uns = list(a = 1, b = 2, c = list(c.a = 3, c.b = 4))
#' )
#'
#' write_loom(ad, "output.loom")
#'
#' file.remove("output.loom")
#' }
write_loom <- function(anndata, filename, write_obsm_varm = FALSE) {
  invisible(py_to_r_ifneedbe(anndata$write_loom(
    filename = filename,
    write_obsm_varm = write_obsm_varm
  )))
}
