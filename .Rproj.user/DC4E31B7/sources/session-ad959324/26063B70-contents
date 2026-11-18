lr.kde2 <- function(groups, x, h, nfolds = 10, folds = NULL, seed = NULL, ncores = 1) {

  x <- .num_matrix(x, "x")
  y <- as.vector( .binary_response(groups, nrow(x)) )
  .check_h(h)
  if ( length(h) != 2  ||  h[1] >= h[2] )
    stop("'h' must be an interval, c(lower, upper), with lower < upper.", call. = FALSE)
  folds <- .get_folds(y, nrow(x), nfolds, folds)

  ## the same folds are used for every bandwidth value
  fun <- function(h)  mean( .cv_auc(y, x, h, folds, ncores), na.rm = TRUE )

  mod <- optimize(fun, h, maximum = TRUE)
  res <- c(mod$maximum, mod$objective)
  names(res) <- c("hopt", "auc")
  res
}
