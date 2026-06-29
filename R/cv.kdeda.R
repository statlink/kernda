cv.kdeda <- function(groups, x, h = seq(0.1, 1, length = 10), nfolds = 10,
                     folds = NULL, seed = NULL, ncores = 1) {

  if ( is.null(folds) )  folds <- Compositional::makefolds(groups, nfolds = nfolds,
                                                           stratified = TRUE, seed = seed)
  groups <- as.numeric(groups)
  cv <- matrix( nrow = nfolds, ncol = length(h) )
  colnames(cv) <- paste("h=", h, sep = "")

  for ( vim in 1:nfolds ) {
    xtest <- x[ folds[[ vim ]] ]   ## test sample
    groupstest <- groups[ folds[[ vim ]] ] ## groups of test sample
    xtrain <- x[ -folds[[ vim ]] ]  ## training sample
    groupstrain <- groups[ -folds[[ vim ]] ]   ## groups of training sample
    est <- kernda::kde_da(xtest, groupstrain, xtrain, h = h, ncores = ncores)
    cv[vim, ] <- mean(est == groupstest)
  }

  perf <- Rfast::colmeans(cv)
  names(perf) <- paste("h=", h, sep = "")
  list( cv = cv, perf = perf, hopt = h[which.max(perf)] )
}
