context("testing the base functionality")

skip_if_no_anndata()

# some test objects that we use below
adata_dense <- AnnData(rbind(c(1, 2), c(3, 4)))
adata_dense$layers["test"] <- adata_dense$X
adata_sparse <- AnnData(
  Matrix::Matrix(c(0, 2, 3, 0, 5, 6), byrow = TRUE, nrow = 2, sparse = TRUE),
  list(obs_names=c("s1", "s2"), anno1=c("c1", "c2")),
  list(var_names=c("a", "b", "c"))
)

test_that("test creation", {
  ad <- AnnData(rbind(c(1, 2), c(3, 4)))
  ad <- AnnData(rbind(c(1, 2), c(3, 4)), list(), list())
  ad <- AnnData(rbind(c(1, 2), c(3, 4)), uns = list(mask = c(0, 1, 1, 0)))
  # TODO: fix
  # ad <- AnnData(Matrix::Matrix(Matrix::diag(2)))
  X <- rbind(c(1, 2, 3), c(4, 5, 6))
  adata <- AnnData(
    X = X,
    obs = list(Obs = c("A", "B")),
    var = list(Feat = c("a", "b", "c")),
    obsm = list(X_pca = rbind(c(1, 2), c(3, 4))),
    raw = list(X = X, var = list(var_names = c("a", "b", "c")))
  )

  expect_equal(adata$raw$X, X)
  expect_equal(adata$raw$var_names, c("a", "b", "c"))

  expect_error({
    AnnData(rbind(c(1, 2), c(3, 4)), list(TooLong = c(1, 2, 3, 4)))
  }, "ValueError: Shape of passed values")

  # init with empty data matrix
  shape <- c(3, 5)
  adata <- AnnData(NULL, uns = list(test = c(3, 3)), shape = shape)
  expect_null(adata$X)
  expect_equal(adata$shape, shape)
  # TODO: fix
  # expect_true("test" %in% names(adata$uns))
})

test_that("create with dfs", {
  X <- matrix(rep(1, 18), nrow = 6)
  obs <- data.frame(cat_anno = factor(c("a", "a", "a", "a", "b", "a")))
  adata <- AnnData(X = X, obs = obs)
  # TODO: fix
  # expect_equal(rownames(adata$obs), rownames(obs))
})

test_that("create from df", {
  df <- data.frame(row.names = c("a", "b", "c"), A = c(1, 1, 1), B = c(1, 1, 1))
  ad <- AnnData(df)
  expect_equal(ad$X, as.vector(as.matrix(df)), check.attributes = FALSE)
  expect_equal(ad$var_names, colnames(df))
  expect_equal(ad$obs_names, rownames(df))
})

test_that("create from sparse", {
  s <- Matrix::rsparsematrix(20, 30, density = 0.2)
  obs_names <- paste0("obs", seq_len(20))
  var_names <- paste0("var", seq_len(30))
  df <- s
  dimnames(df) <- list(obs_names, var_names)
  a <- AnnData(df)
  b <- AnnData(s, obs = list(obs_names = obs_names), var = list(var_names = var_names))
  expect_equal(a, b)
  expect_is(a$X, "sparseMatrix")
})

test_that("create from df with obs and var", {
  df <- data.frame(row.names = c("a", "b", "c"), A = c(1, 1, 1), B = c(1, 1, 1))
  obs <- data.frame(row.names = rownames(df), C = c(1, 1, 1))
  var <- data.frame(row.names = colnames(df), D = c(1, 1))
  ad <- AnnData(df, obs = obs, var = var)
  expect_equal(ad$X, as.vector(as.matrix(df)), check.attributes = FALSE)
  expect_equal(ad$var_names, colnames(df))
  expect_equal(ad$obs_names, rownames(df))
  expect_equal(ad$obs, obs, check.attributes = FALSE)
  expect_equal(ad$var, var, check.attributes = FALSE)

  expect_error(regexp = "Index of obs must match index of X.", {
    AnnData(df, obs = data.frame(C = c(1, 1, 1)))
  })
  expect_error(regexp = "Index of var must match columns of X.", {
    AnnData(df, var = data.frame(C = c(1, 1)))
  })
})

test_that("from df and dict", {
  df <- data.frame(a = c(0.1, 0.2, 0.3), b = c(1.1, 1.2, 1.3))
  adata <- AnnData(df, list(species = factor(c("a", "b", "a"))))
  expect_equal(adata$obs[["species"]], c("a", "b", "a"))
})

# warning is not generated consistently
# test_that("df warnings", {
#   df <- data.frame(A = c(1L, 2L, 3L), B = c(1, 2, 3), row.names = c("a", "b", "c"))
#   expect_warning(regex = "X.*dtype float64", {
#     ad <- AnnData(df)
#   })
# })

test_that("attr deletion", {
  full <-1
})
