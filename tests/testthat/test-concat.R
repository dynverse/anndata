context("testing concat()")

skip_if_no_anndata()

a <- AnnData(
  X = matrix(c(0, 1, 2, 3), nrow = 2, byrow = TRUE),
  obs = data.frame(group = c("a", "b"), row.names = c("s1", "s2")),
  var = data.frame(type = c(1L, 2L), row.names = c("var1", "var2")),
  varm = list(
    ones = matrix(rep(1L, 10), nrow = 2),
    rand = matrix(rnorm(6), nrow = 2),
    zeros = matrix(rep(0L, 10), nrow = 2)
  ),
  uns = list(
    a = 1,
    b = 2,
    c = list(
      c.a = 3,
      c.b = 4
    )
  )
)

b <- AnnData(
  X = matrix(c(4, 5, 6, 7, 8, 9), nrow = 2, byrow = TRUE),
  obs = data.frame(group = c("b", "c"), row.names = c("s3", "s4")),
  var = data.frame(type = c(1L, 2L, 3L), row.names = c("var1", "var2", "var3")),
  varm = list(
    ones = matrix(rep(1L, 15), nrow = 3),
    rand = matrix(rnorm(15), nrow = 3)
  ),
  uns = list(
    a = 1,
    b = 3,
    c = list(
      c.a = 3
    )
  )
)

c <- AnnData(
  X = matrix(c(10, 11, 12, 13), nrow = 2, byrow = TRUE),
  obs = data.frame(group = c("a", "b"), row.names = c("s1", "s2")),
  var = data.frame(type = c(3L, 4L), row.names = c("var3", "var4")),
  uns = list(
    a = 1,
    b = 4,
    c = list(
      c.a = 3,
      c.b = 4,
      c.c = 5
    )
  )
)

test_that("simple concat", {
  out <- concat(list(a, b))

  expect_equal(nrow(out$X), 4)
  expect_equal(ncol(out$X), 2)

  # concat(list(a, c), axis = 1L)$to_df()
  #
  # # Inner and outer joins
  # inner <- concat(list(a, b))
  # inner
  # inner$obs_names
  # inner$var_names
  #
  # outer <- concat(list(a, b), join = "outer")
  # outer
  # outer$var_names
  # outer$to_df()
  #
  # # Keeping track of source objects
  # concat(list(a = a, b = b), label = "batch")$obs
  # concat(list(a, b), label = "batch", keys = c("a", "b"))$obs
  # concat(list(a = a, b = b), index_unique = "-")$obs
  #
  # # Combining values not aligned to axis of concatenation
  # concat(list(a, b), merge = "same")
  # concat(list(a, b), merge = "unique")
  # concat(list(a, b), merge = "first")
  # concat(list(a, b), merge = "only")
  #
  # # The same merge strategies can be used for elements in .uns
  # concat(list(a, b, c), uns_merge = "same")$uns
  # concat(list(a, b, c), uns_merge = "unique")$uns
  # concat(list(a, b, c), uns_merge = "first")$uns
  # concat(list(a, b, c), uns_merge = "only")$uns

})
