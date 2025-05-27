context("testing AnnData")

skip_on_cran()
skip_if_no_anndata()

warnings <- reticulate::import("warnings")
warnings$filterwarnings("ignore")

ad <- AnnData(
  X = matrix(0:5, nrow = 2),
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
    ones = matrix(rep(1L, 15), nrow = 3),
    rand = matrix(rnorm(6), nrow = 3),
    zeros = matrix(rep(0L, 15), nrow = 3)
  ),
  uns = list(
    a = 1,
    b = data.frame(f = 10),
    c = list(c.a = 3, c.b = 4)
  )
)
# private <- ad$.__enclos_env__$private

value <- matrix(1:6, nrow = 2)

test_that("read and change X", {
  expect_true(all(ad$X == 0:5))
  ad$X <- value
  expect_true(all(ad$X == 1:6))
})

test_that("read and change layer", {
  expect_true(all(ad$layers[["spliced"]] == 4:9))
  ad$layers[["spliced"]] <- value
  expect_true(all(ad$layers[["spliced"]] == 1:6))
  ad$layers[["spliced"]] <- NULL
  expect_false("spliced" %in% names(ad$layers))
})

test_that("add new layer", {
  # expect_error(ad$layers["test"])
  expect_null(ad$layers[["test"]]) # difference w.r.t. anndata py: R lists return NULL when item is not found, not errors
  ad$layers[["test"]] <- value
  expect_true(all(ad$layers[["test"]] == 1:6))
  ad$layers[["test"]] <- NULL
  expect_false("test" %in% names(ad$layers))
})

test_that("test common R functions", {
  expect_equal(dimnames(ad), list(c("s1", "s2"), c("var1", "var2", "var3")))
  expect_equal(dim(ad), c(2L, 3L))

  expect_true(all(as.matrix(ad) == 1:6))

  expect_true(all(as.matrix(ad, layer = "unspliced") == 8:13))

  expect_true(all(
    as.data.frame(ad) == list(var1 = 1:2, var2 = 3:4, var3 = 5:6)
  ))

  expect_true(all(
    as.data.frame(ad, layer = "unspliced") ==
      list(var1 = 8:9, var2 = 10:11, var3 = 12:13)
  ))

  expect_equal(ad$X[, 1], c(s1 = 1, s2 = 2))
  expect_equal(ad$X[1, ], c(var1 = 1, var2 = 3, var3 = 5))
})

test_that("anndata works with sparse data", {
  sp <- as(matrix(0:5, nrow = 2), "CsparseMatrix")
  ad <- AnnData(
    X = sp,
    obs = data.frame(group = c("a", "b"), row.names = c("s1", "s2")),
    var = data.frame(
      type = c(1L, 2L, 3L),
      row.names = c("var1", "var2", "var3")
    ),
    layers = list(
      spliced = matrix(4:9, nrow = 2) %>% as("RsparseMatrix"),
      unspliced = matrix(8:13, nrow = 2)
    )
  )
  expect_is(ad$X, "sparseMatrix")
  expect_is(ad$layers[["spliced"]], "sparseMatrix")
  expect_is(ad$layers[["unspliced"]], "matrix")
})

test_that("uns python objects get converted", {
  b <- ad$uns$b
  expect_is(b, "data.frame")

  # change object
  ad$uns$b <- data.frame(f = 8, z = 10)
  ad$uns$b$a <- 3

  expect_is(b, "data.frame")
  expect_true(all(c("f", "z", "a") %in% colnames(ad$uns$b)))

  ad$uns$b <- list(a = data.frame(f = 1), b = 2)
})


test_that("test writing and reading h5ad", {
  tmp1 <- tempfile()
  on.exit(file.remove(tmp1))
  ad$write_h5ad(tmp1)

  ad2 <- read_h5ad(tmp1)
  expect_equal(ad$X, ad2$X)

  tmp2 <- tempfile()
  on.exit(file.remove(tmp2))
  write_h5ad(ad, tmp2)

  ad3 <- read_h5ad(tmp2)
  expect_equal(ad$X, ad3$X)
})
