aecheck <- function(a, b, field) {
  e <- all.equal(a, b)
  if (!isTRUE(e)) {
    paste0("Field ", field, " mismatch: ", e)
  } else {
    e
  }
}

`%&%` <- function(a, b) {
  if (isTRUE(a)) {
    if (isTRUE(b)) {
      a
    } else {
      b
    }
  } else {
    if (isTRUE(b)) {
      a
    } else {
      c(a, b)
    }
  }
}
