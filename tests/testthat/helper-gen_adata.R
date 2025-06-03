gen_vstr_recarray <- function(m, n, dtype = NULL) {
  size <- m * n
  lengths <- as.integer(runif(size, 3, 5))
  let <- c(letters, LETTERS)
  gen_word <- function(l) paste(sample(let, l, replace = TRUE), collapse = "")
  colnam <- sapply(seq_len(n), function(i) gen_word(5))
  arr <- matrix(
    sapply(lengths, gen_word),
    nrow = m,
    dimnames = list(NULL, colnam)
  )
  df <- as.data.frame(arr)
  pd <- reticulate::import("pandas", convert = FALSE)
  df <- pd$DataFrame(arr, columns = colnam)
  df
  # TODO: add records class
  # rec <- df$to_records(index = FALSE, column_dtypes = dtype)
  # rec
}

gen_typed_df <- function(n, index = NULL) {
  let <- c(letters, LETTERS)
  if (n > length(let)) {
    let <- let[seq_len(n / 2)]
  }

  sam1 <- sample(let, n, replace = TRUE)
  data.frame(
    row.names = index,
    cat = factor(sample(let, n, replace = TRUE)),
    cat_ordered = factor(sam1, levels = sort(unique(sam1))),
    int = as.integer(runif(n, -50, 50)),
    float = runif(n)
    # uint8 = ... how to, in r?
  )
}

gen_adata <- function(
  shape,
  obsm_types = c("matrix", "sparseMatrix", "data.frame"),
  varm_types = c("matrix", "sparseMatrix", "data.frame"),
  layer_types = c("matrix", "sparseMatrix")
) {
  M <- shape[[1]]
  N <- shape[[2]]

  obs_names <- paste0("cell", seq_len(M))
  var_names <- paste0("gene", seq_len(N))
  obs <- gen_typed_df(M, obs_names)
  var <- gen_typed_df(N, var_names)
  # for #147
  obs$obs_cat <- obs$cat
  obs$cat <- NULL
  var$var_cat <- var$cat
  var$cat <- NULL

  obsm <- list(
    array = matrix(runif(M * 50), nrow = M),
    sparse = Matrix::rsparsematrix(M, 100, density = 0.1),
    df = gen_typed_df(M, obs_names)
  )
  for (key in names(obsm)) {
    type_match <- sapply(obsm_types, function(typ) inherits(obsm[[key]], typ))
    if (!any(type_match)) {
      obsm[[key]] <- NULL
    }
  }
  varm <- list(
    array = matrix(runif(N * 50), nrow = N),
    sparse = Matrix::rsparsematrix(N, 100, density = 0.1),
    df = gen_typed_df(N, var_names)
  )
  for (key in names(varm)) {
    type_match <- sapply(varm_types, function(typ) inherits(varm[[key]], typ))
    if (!any(type_match)) {
      varm[[key]] <- NULL
    }
  }
  layers <- list(
    array = matrix(runif(M * N), nrow = M),
    sparse = Matrix::rsparsematrix(M, N, density = 0.1)
  )
  obsp <- list(
    array = matrix(runif(M * M), nrow = M),
    sparse = Matrix::rsparsematrix(M, M, density = 0.1)
  )
  varp <- list(
    array = matrix(runif(N * N), nrow = N),
    sparse = Matrix::rsparsematrix(N, N, density = 0.1)
  )
  uns <- list(
    O_recarray = gen_vstr_recarray(N, 5) # ,
    # U_recarray=gen_vstr_recarray(N, 5, "U4")
  )

  ad <- AnnData(
    X = Matrix::Matrix(
      matrix(rbinom(M * N, 100, 0.005), nrow = M),
      sparse = TRUE
    ),
    obs = obs,
    var = var,
    obsm = obsm,
    varm = varm,
    layers = layers,
    obsp = obsp,
    varp = varp,
    uns = uns
  )

  ad
}
