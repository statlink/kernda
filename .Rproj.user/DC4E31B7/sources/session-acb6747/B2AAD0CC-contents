lr.kde3 <- function(y, x, h = seq(0.01, 2, by = 0.01), ncores = 1) {

  est <- kernreg::kern_reg(x, y, x, h, ncores = ncores)
  perf <- Rfast::colaucs(y, est)
  names(perf) <- paste("h=", h, sep = "")

  plot(h, perf, xlab = "Bandwidth (h) values", ylab = "AUC values", type = "l", lwd = 2,
       cex.lab = 1.3, cex.axis = 1.3)
  abline(h = seq(min(perf, na.rm = FALSE), max(perf, na.rm = FALSE), length = 10), lty = 2, col = "lightgrey" )
  abline(v = h[which.max(perf)], col = 3, lwd = 2)
  list(perf = perf, hopt = h[which.max(perf)])

}
