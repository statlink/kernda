kde.da2.R <- function(groups, x, h) {

  groups <- as.numeric(groups)
  k <- max(groups)
  n <- length(x)
  prob <- tabulate(groups) / n
  f <- matrix(nrow = n, ncol = k)
  a <- list()
  for ( i in 1:k )  a[[ i ]] <- exp( -0.5 * Rfast::dista(x, x[groups==i], square = TRUE) )

  fun <- function(h, groups, x, a, prob, f) {
    for ( i in 1:k )  f[, i] <- prob[i] * Rfast::rowmeans(a[[ i ]]^ (1 / h) ) / h
    est <- Rfast::rowMaxs(f)
    mean(est == groups)
  }

  mod <- optimize(fun, h, groups = groups, x = x, a = a, prob = prob, f = f, maximum = TRUE)
  res <- c(mod$maximum, perf = mod$objective)
  names(res) <- c("hopt", "percentage")
  res
}
