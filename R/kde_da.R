kde_da <- function(xnew, groups, x, h = NULL, ncores = 1L) {

  groups <- as.integer(groups)
  if ( length(x) == 0 )  stop("'x' must not be empty.", call. = FALSE)
  if ( length(groups) != length(x) )
    stop("'groups' and 'x' must have the same length.", call. = FALSE)
  if ( anyNA(groups)  ||  any(groups < 1) )
    stop("'groups' must be positive integers (1, 2, ...) without NAs.", call. = FALSE)
  if ( !all( is.finite(x) ) )
    stop("'x' must not contain missing or infinite values.", call. = FALSE)

  k <- max(groups)

  if ( is.null(h) ) {   ## a separate bandwidth for each group
    h <- .group_bw(x, groups, k)
    H <- matrix(h, ncol = 1)
    nam <- "bw.nrd"
  } else {              ## the same bandwidth for all groups
    .check_h(h)
    H <- matrix( h, nrow = k, ncol = length(h), byrow = TRUE )
    nam <- h
  }

  res <- .kde_da_cpp(xnew, groups, x, H, ncores)
  names(res$kde) <- nam
  res$h <- h
  res
}


## bw.nrd() applied to each group. A group without observations gets NA.
.group_bw <- function(x, groups, k) {
  ni <- tabulate(groups, k)
  if ( any(ni == 1) )
    stop( "bw.nrd() needs at least 2 observations per group, see group(s) ",
          paste(which(ni == 1), collapse = ", "), ". Supply 'h' instead.", call. = FALSE )
  h <- rep(NA_real_, k)
  for ( g in which(ni > 0) )  h[g] <- bw.nrd( x[groups == g] )
  zero <- which(h == 0)
  if ( length(zero) > 0 )
    stop( "bw.nrd() returned a zero bandwidth for group(s) ", paste(zero, collapse = ", "),
          ". Supply 'h' instead.", call. = FALSE )
  names(h) <- paste("group", 1:k, sep = "")
  h
}
