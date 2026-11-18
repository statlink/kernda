cv.kdeda <- function(groups, x, h = seq(0.1, 1, length = 10), nfolds = 10,
                     folds = NULL, ncores = 1) {

  x <- .num_matrix(x, "x")
  if ( ncol(x) != 1 )  stop("'x' must be a numeric vector.", call. = FALSE)
  x <- as.vector(x)
  .check_h(h)
  if ( length(groups) != length(x) )  stop("'groups' and 'x' must have the same length.", call. = FALSE)
  if ( anyNA(groups) )  stop("'groups' must not contain missing values.", call. = FALSE)

  groups <- as.integer( as.factor(groups) )  ## any labels become 1, 2, ...
  folds <- .get_folds(groups, length(x), nfolds, folds)
  nfolds <- length(folds)
  cv <- matrix( nrow = nfolds, ncol = length(h) )
  colnames(cv) <- paste("h=", h, sep = "")

  for ( vim in 1:nfolds ) {
    xtest <- x[ folds[[ vim ]] ]   ## test sample
    groupstest <- groups[ folds[[ vim ]] ] ## groups of test sample
    xtrain <- x[ -folds[[ vim ]] ]  ## training sample
    groupstrain <- groups[ -folds[[ vim ]] ]   ## groups of training sample
    est <- kernda::kde_da(xtest, groupstrain, xtrain, h = h, ncores = ncores)$class
    cv[vim, ] <- Rfast::colmeans(est == groupstest)
  }

  perf <- Rfast::colmeans(cv)
  names(perf) <- paste("h=", h, sep = "")
  list( cv = cv, perf = perf, hopt = h[which.max(perf)] )
}
