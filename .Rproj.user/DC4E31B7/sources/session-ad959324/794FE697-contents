nb.kde <- function(xnew, groups, x, h = NULL, ncores = 1L) {
  xnew <- as.matrix(xnew)
  x <- as.matrix(x)
  if ( dim(xnew)[2] == 1 )  xnew <- t(xnew)
  groups <- as.numeric(groups)
  ni <- tabulate(groups)
  n <- sum(ni)
  prior <- ni/n
  k <- max(groups)
  score <- matrix(0, nrow = dim(xnew)[1], ncol = k)
  d <- dim(x)[2]
  for ( j in 1:d ) score <- score + kernda::kde_da(xnew[, j], groups, x[, j], h, ncores)$kde$bw.nrd
  score <- score + Rfast::eachrow(score, prior, oper = "+")
  list(class = Rfast::rowMaxs(score), score = score)
}
