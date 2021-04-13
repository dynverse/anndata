#' Write annotation to .csv files.
#'
#' It is not possible to recover the full AnnData from these files. Use [write_h5ad()] for this.
#'
#' @param anndata An [AnnData()] object
#' @param dirname Name of the directory to which to export.
#' @param skip_data Skip the data matrix `X`.
#' @param sep Separator for the data
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
#' write_csvs(ad, "output")
#'
#' unlink("output", recursive = TRUE)
#' }
write_csvs <- function(anndata, dirname, skip_data = TRUE, sep = ",") {
  invisible(py_to_r_ifneedbe(anndata$write_csvs(
    dirname = dirname,
    skip_data = skip_data,
    sep = sep
  )))
}

