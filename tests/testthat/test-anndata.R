context("testing AnnData")

skip_if_no_anndata()

ad <- AnnData$new(
  X = matrix(c(0, 1, 2, 3), nrow = 2),
  obs = data.frame(group = c("a", "b"), row.names = c("s1", "s2")),
  var = data.frame(type = c(1L, 2L), row.names = c("var1", "var2")),
  layers = list(
    spliced = matrix(c(4, 5, 6, 7), nrow = 2),
    unspliced = matrix(c(8, 9, 10, 11), nrow = 2)
  ),
  varm = list(
    ones = matrix(rep(1L, 10), nrow = 2),
    rand = matrix(rnorm(6), nrow = 2),
    zeros = matrix(rep(0L, 10), nrow = 2)
  ),
  uns = list(a = 1, b = 2, c = list(c.a = 3, c.b = 4))
)

test_that("simple functions", {
  value <- matrix(1:4, nrow = 2)

  expect_true(all(ad$X == 0:3))
  ad$X <- value
  expect_true(all(ad$X == 1:4))

  expect_true(all(ad$layers["spliced"] == 4:7))
  ad$layers["spliced"] <- value
  expect_true(all(ad$layers["spliced"] == 1:4))
})
