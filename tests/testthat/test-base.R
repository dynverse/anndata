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
  ad <- AnnData(Matrix::Matrix(Matrix::diag(2)))
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
  expect_true("test" %in% names(adata$uns))
})

test_that("create with dfs", {
  X <- matrix(rep(1, 18), nrow = 6)
  obs <- data.frame(cat_anno = factor(c("a", "a", "a", "a", "b", "a")))
  adata <- AnnData(X = X, obs = obs)
  # expect_equal(rownames(adata$obs), rownames(obs))
  expect_equal(rownames(adata$obs), as.character(0:5)) # python arrays start from 0
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
  full <- gen_adata(c(30, 30))
  # Empty has just X, obs_names, var_names
  #empty <- AnnData(full$X, obs = full$obs[,integer(0)], var = full$var[,integer(0)])
  # TODO: allow passing empty data frames??
  empty <- AnnData(full$X)
  empty$obs_names <- full$obs_names
  empty$var_names <- full$var_names

  expect_not_equal(full, empty)
  expect_not_equal(full$obs, empty$obs)
  full$obs <- NULL
  expect_equal(full$obs, empty$obs)

  expect_not_equal(full, empty)
  expect_not_equal(full$var, empty$var)
  full$var <- NULL
  expect_equal(full$var, empty$var)

  expect_not_equal(full, empty)
  expect_not_equal(full$obsm, empty$obsm)
  full$obsm <- NULL
  expect_equal(full$obsm, empty$obsm)

  expect_not_equal(full, empty)
  expect_not_equal(full$varm, empty$varm)
  full$varm <- NULL
  expect_equal(full$varm, empty$varm)

  expect_not_equal(full, empty)
  expect_not_equal(full$obsp, empty$obsp)
  full$obsp <- NULL
  expect_equal(full$obsp, empty$obsp)

  expect_not_equal(full, empty)
  expect_not_equal(full$varp, empty$varp)
  full$varp <- NULL
  expect_equal(full$varp, empty$varp)

  expect_not_equal(full, empty)
  expect_not_equal(full$layers, empty$layers)
  full$layers <- NULL
  expect_equal(full$layers, empty$layers)

  expect_not_equal(full, empty)
  expect_not_equal(full$uns, empty$uns)
  full$uns <- NULL
  expect_equal(full$uns, empty$uns)

  expect_equal(full, empty)
})

test_that("setting index names", {
  li <- list(
    list(names = c("a", "b"), after = NULL),
    list(names = c("AAD", "CCA"), after = "barcodes")
  )
  attr(li[[2]]$names, "name") <- "barcodes"

  for (i in seq_along(li)) {
    names <- li[[i]]$names
    after <- li[[i]]$after

    adata <- adata_dense$copy()

    # do it for obs_names
    expect_null(attr(adata$obs_names, "name"))
    adata$obs_names <- names
    expect_equal(attr(adata$obs_names, "name"), after)

    new <- adata[,]
    expect_true(new$is_view)
    new$obs_names <- names
    expect_equal(new, adata)
    expect_false(new$is_view)

    # do it for var_names
    expect_null(attr(adata$var_names, "name"))
    adata$var_names <- names
    expect_equal(attr(adata$var_names, "name"), after)

    new <- adata[,]
    expect_true(new$is_view)
    new$obs_names <- names
    expect_equal(new, adata)
    expect_false(new$is_view)
  }
})

test_that("setting index names error", {
  orig <- adata_sparse[1:2, 1:2]
  adata <- adata_sparse[1:2, 1:2]

  expect_null(attr(adata$obs_names, "name"))
})

test_that("setting dim index for obs", {
  orig <- gen_adata(c(5, 5))
  orig$raw <- orig
  curr <- orig$copy()
  view <- orig[,]
  new_idx <- letters[1:5]

  curr$obs_names <- new_idx
  expect_equal(curr$obs_names, new_idx)
  expect_equal(rownames(curr$obsm$df), new_idx)
  expect_equal(curr$obs_names, curr$raw$obs_names)

  # Testing view behaviour
  view$obs_names <- new_idx
  expect_false(view$is_view)
  expect_equal(view$obs_names, new_idx)
  expect_equal(rownames(view$obsm$df), new_idx)
  expect_not_equal(view$obs_names, orig$obs_names)
  expect_equal(view, curr)
})

test_that("setting dim index for var", {
  orig <- gen_adata(c(5, 5))
  orig$raw <- orig
  curr <- orig$copy()
  view <- orig[,]
  new_idx <- letters[1:5]

  curr$var_names <- new_idx
  expect_equal(curr$var_names, new_idx)
  expect_equal(rownames(curr$varm$df), new_idx)
  expect_equal(curr$obs_names, curr$raw$obs_names) # obs names instead of var names is intentional

  # Testing view behaviour
  view$var_names <- new_idx
  expect_false(view$is_view)
  expect_equal(view$var_names, new_idx)
  expect_equal(rownames(view$varm$df), new_idx)
  expect_not_equal(view$var_names, orig$var_names)
  expect_equal(view, curr)
})

test_that("indices dtypes", {
  adata <- AnnData(
    matrix(
      1:6, nrow = 2, byrow = TRUE,
      dimnames = list(
        c("A", "B"),
        c("a", "b", "c")
      )
    )
  )
  adata$obs_names <- c("ö", "a")
  expect_equal(adata$obs_names, c("ö", "a"))
})

test_that("slicing", {
  orig <- matrix(1:6, nrow = 2, byrow = TRUE, dimnames = list(c("0", "1"), c("0", "1", "2")))
  adata <- AnnData(orig)

  expect_equal(adata[1, 1]$X, orig[1, 1, drop = FALSE])
  expect_equal(adata[1, ]$X, orig[1, , drop = FALSE])
  expect_equal(adata[, 1]$X, orig[, 1, drop = FALSE])

  expect_equal(adata[, 1:2]$X, orig[, 1:2, drop = FALSE])
  expect_equal(adata[, c(1, 3)]$X, orig[, c(1, 3), drop = FALSE])
  expect_equal(adata[, c(FALSE, TRUE, TRUE)]$X, orig[, 2:3, drop = FALSE])
  expect_equal(adata[, 2:3]$X, orig[, 2:3, drop = FALSE])

  expect_equal(adata[1:2, ][, 1:2]$X, orig[, 1:2, drop = FALSE])
  expect_equal(adata[1, ][, 1:2]$X, orig[1, 1:2, drop = FALSE])
  expect_equal(adata[1, ][, 1]$X, orig[1, 1, drop = FALSE])
  expect_equal(adata[, 1:2][1:2, ]$X, orig[, 1:2, drop = FALSE])
  expect_equal(adata[, 1:2][1, ]$X, orig[1, 1:2, drop = FALSE])
  expect_equal(adata[, 1][1, ]$X, orig[1, 1, drop = FALSE])
})

test_that("boolean_slicing", {
  orig <- matrix(1:6, nrow = 2, byrow = TRUE, dimnames = list(c("0", "1"), c("0", "1", "2")))
  adata <- AnnData(orig)

  obs_selector <- c(TRUE, FALSE)
  vars_selector <- c(TRUE, FALSE, FALSE)
  expect_equal(adata[obs_selector, ][, vars_selector]$X, orig[1, 1, drop = FALSE])
  expect_equal(adata[, vars_selector][obs_selector, ]$X, orig[1, 1, drop = FALSE])
  expect_equal(adata[obs_selector, ][, 1]$X, orig[1, 1, drop = FALSE])
  expect_equal(adata[, 1][obs_selector, ]$X, orig[1, 1, drop = FALSE])
  expect_equal(adata[1, ][, vars_selector]$X, orig[1, 1, drop = FALSE])
  expect_equal(adata[, vars_selector][1, ]$X, orig[1, 1, drop = FALSE])

  obs_selector <- c(TRUE, FALSE)
  vars_selector <- c(TRUE, TRUE, FALSE)
  expect_equal(adata[obs_selector, ][, vars_selector]$X, orig[1, 1:2, drop = FALSE])
  expect_equal(adata[, vars_selector][obs_selector, ]$X, orig[1, 1:2, drop = FALSE])
  expect_equal(adata[obs_selector, ][, 1:2]$X, orig[1, 1:2, drop = FALSE])
  expect_equal(adata[, 1:2][obs_selector, ]$X, orig[1, 1:2, drop = FALSE])
  expect_equal(adata[1, ][, vars_selector]$X, orig[1, 1:2, drop = FALSE])
  expect_equal(adata[, vars_selector][1, ]$X, orig[1, 1:2, drop = FALSE])

  obs_selector <- c(TRUE, TRUE)
  vars_selector <- c(TRUE, TRUE, FALSE)
  expect_equal(adata[obs_selector, ][, vars_selector]$X, orig[, 1:2, drop = FALSE])
  expect_equal(adata[, vars_selector][obs_selector, ]$X, orig[, 1:2, drop = FALSE])
  expect_equal(adata[obs_selector, ][, 1:2]$X, orig[, 1:2, drop = FALSE])
  expect_equal(adata[, 1:2][obs_selector, ]$X, orig[, 1:2, drop = FALSE])
  expect_equal(adata[1:2, ][, vars_selector]$X, orig[, 1:2, drop = FALSE])
  expect_equal(adata[, vars_selector][1:2, ]$X, orig[, 1:2, drop = FALSE])
})

test_that("oob boolean slicing", {
  len <- sample.int(100, 2, replace = FALSE)
  expect_error({
    empty_mat <- matrix(rep(0, len[[1]] * 100), nrow = len[[1]])
    sel <- sample(c(TRUE, FALSE), len[[2]], replace = TRUE)
    AnnData(empty_mat)[sel, ]
  }, regexp = "does not match.*shape along this dimension")

  expect_error({
    empty_mat <- matrix(rep(0, len[[1]] * 100), nrow = len[[1]])
    sel <- sample(c(TRUE, FALSE), len[[2]], replace = TRUE)
    AnnData(empty_mat)[, sel]
  }, regexp = "does not match.*shape along this dimension")
})

test_that("slicing strings", {
  orig <- matrix(1:6, byrow = TRUE, nrow = 2, dimnames = list(c("A", "B"), c("a", "b", "c")))
  adata <- AnnData(orig)

  expect_equal(adata["A", "a"]$X, orig[1, 1, drop = FALSE])
  expect_equal(adata["A", ]$X, orig[1, , drop = FALSE])
  expect_equal(adata[, "a"]$X, orig[, 1, drop = FALSE])
  expect_equal(adata[, c("a", "b")]$X, orig[, 1:2, drop = FALSE])
  # assert adata[:, "b":"c"].X.tolist() == [[2, 3], [5, 6]]
  # ↑ can't do this in R

  expect_error(adata[, "X"], regexp = "KeyError: 'X'")
  expect_error(adata["X", ], regexp = "KeyError: 'X'")
  # ↓ can't do this in R
  # with pytest.raises(KeyError):
  #   _ = adata["A":"X", :]
  # with pytest.raises(KeyError):
  #   _ = adata[:, "a":"X"]

  # Test if errors are helpful
  expect_error(adata[, c("a", "b", "not_in_var")], regexp = "not_in_var")
  expect_error(adata[c("A", "B", "not_in_obs"), ], regexp = "not_in_obs")
})

test_that("slicing graphs", {

})
