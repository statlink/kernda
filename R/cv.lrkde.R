cv.lrkde <- function(y, x, h = seq(0.1, 1, length = 10), nfolds = 10,
             folds = NULL, seed = NULL, ncores = 1) {

  if ( is.null(folds) )  folds <- Compositional::makefolds(y, nfolds = nfolds,
                                  stratified = TRUE, seed = seed)

  x <- as.matrix(x)
  cv <- matrix( nrow = nfolds, ncol = length(h) )
  colnames(cv) <- paste("h=", h, sep = "")

  for ( i in 1:nfolds ) {
    xtest <- x[ folds[[ i ]], , drop = FALSE ]   ## test sample
    ytest <- y[ folds[[ i ]] ] ## groups of test sample
    xtrain <- x[ -folds[[ i ]], , drop = FALSE]  ## training sample
    ytrain <- y[ -folds[[ i ]] ]   ## groups of training sample
    est <- kernreg::kern_reg(xtest, ytrain, xtrain, h = h, ncores = ncores)
    cv[i, ] <- Rfast::colaucs(ytest, est)
  }

  perf <- Rfast::colmeans(cv)
  names(perf) <- paste("h=", h, sep = "")
  list( cv = cv, perf = perf, hopt = h[which.max(perf)] )
}
