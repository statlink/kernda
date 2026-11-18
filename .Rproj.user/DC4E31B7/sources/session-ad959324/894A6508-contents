lr.kde <- function(xnew, groups, x, h, ncores = 1) {
  x <- .num_matrix(x, "x")
  xnew <- .new_matrix(xnew, x)
  y <- .binary_response(groups, nrow(x), multi = TRUE, both = FALSE)
  .check_h(h)
  mod <- kernreg::kern_reg(xnew, y, x, h, type = "gauss", ncores = ncores)
  cl <- if ( is.list(mod) )  lapply(mod, round)  else  round(mod)
  list( prob = mod, cl = cl )
}
