lr.kde2 <- function(y, x, h) {

  fun <- function(h, y, x) {
    est <- kernreg::kern_reg(x, y, x, h, ncores = 1)
    Rfast::auc(y, est)
  }

  mod <- optimize(fun, h, y = y, x = x, maximum = TRUE)
  res <- c(mod$maximum, auc = mod$objective)
  names(res) <- c("hopt", "auc")
  res
}
