expect_not_equal <- function(object, expected, ...) {
  expect_false(isTRUE(all.equal(object, expected, ...)))
}
