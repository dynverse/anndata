context("testing backed mode")

skip_if_no_anndata()


test_that("backed indexing", {
  tmp_path <- tempfile()
  dir.create(tmp_path, recursive = TRUE)
  on.exit(unlink(tmp_path, recursive = TRUE))

  csr_path <- paste0(tmp_path, "/csr.h5ad")
  csc_path <- paste0(tmp_path, "/csc.h5ad")
  dense_path <- paste0(tmp_path, "/dense.h5ad")

  m <- Matrix::rsparsematrix(50, 50, density = 0.1)
  dimnames(m) <- list(paste0("cell", seq_len(nrow(m))), paste0("gene", seq_len(ncol(m))))

  csc_mem <- AnnData(X = m)
  csr_mem <- AnnData(X = as(as(as(m, "dMatrix"), "generalMatrix"), "RsparseMatrix"))

  csr_mem$write_h5ad(csr_path)
  csc_mem$write_h5ad(csc_path)
  csc_mem$write_h5ad(dense_path, as_dense = "X")

  csr_disk <- read_h5ad(csr_path, backed = "r")
  csc_disk <- read_h5ad(csc_path, backed = "r")
  dense_disk <- read_h5ad(dense_path, backed = "r")

  obs_idx <- csc_mem$obs_names # ??
  var_idx <- csc_mem$var_names # ??

  expect_equivalent(csc_mem$X, csc_disk$X) # extra test added by me
  expect_equivalent(as.matrix(csc_mem$X), dense_disk$X) # extra test added by me
  expect_equivalent(csc_mem[obs_idx, var_idx]$X, csr_disk[obs_idx, var_idx]$X)
  expect_equivalent(csc_mem[obs_idx, var_idx]$X, csc_disk[obs_idx, var_idx]$X)
  expect_equivalent(as.matrix(csc_mem[, var_idx]$X), dense_disk[, var_idx]$X)
  expect_equivalent(as.matrix(csc_mem[obs_idx, ]$X), dense_disk[obs_idx, ]$X) # why does dense disk only allow one idx?
})
#
# adpy <- csc_disk$.__enclos_env__$private$.anndata
# adpy$X %>% class
# adpy %>% class
#
# adpy$X

# adpy2 <- dense_disk$.__enclos_env__$private$.anndata
# adpy2$X %>% class
# adpy2 %>% class

# private <- list(self = csc_disk$.__enclos_env__$private$.anndata$X)
