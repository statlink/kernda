\name{kde_da}
\alias{kde_da}
\title{
Kernel discriminant analysis
}

\description{
Kernel discriminant analysis for a univariate predictor.
}

\usage{
kde_da(xnew, groups, x, h = NULL, ncores = 1L, logged = FALSE)
}

\arguments{
\item{xnew}{
A numeric vector with the new values whose group is to be predicted. Missing values are allowed.
}
\item{groups}{
A vector with the groups (labels) of the data, given as positive integers (1, 2, ...) or as a factor.
Zeros, negative values and missing values are not allowed.
}
\item{x}{
A numeric vector with continuous data, of the same length as groups. Missing values are not allowed.
}
\item{h}{
A vector with one or more positive values for the bandwidth parameter of the Gaussian kernel. Each value
is used for all groups. If h is NULL (the default), each group gets its own bandwidth, computed with
\code{\link[stats]{bw.nrd}}. Each group must then have at least 2 observations and a non-zero bandwidth.
}
\item{ncores}{
The number of cores to use. It has an effect only if the package was compiled with OpenMP support.
}
\item{logged}{
Should the logarithm of the kernel density estimates be returned? The default is FALSE. This argument
does not affect the predicted groups.
}
}

\details{
The density of each group is estimated with a Gaussian kernel, using either the same bandwidth for all
groups or, if h is NULL, the bandwidth given by \code{\link[stats]{bw.nrd}} for each group, and each new value is allocated to the group with the highest estimated posterior probability, using
the sample proportions as prior probabilities. The bandwidth is on the scale of x, since x is not
standardised. For values of xnew very far from the data the estimated densities may underflow to 0,
but the predicted groups are still computed correctly. With logged = TRUE the log-densities are computed
without this underflow.
}

\value{
A list including:
\item{class}{
An integer matrix with the predicted groups. It has one row for each value of xnew and one column
for each value of h, or a single column if h is NULL. Missing values of xnew receive NA.
}
\item{kde}{
A list with one matrix for each value of h, even if h is a single number. The names of the list are
the values of h. If h is NULL the list has one matrix, named "bw.nrd". Each matrix has one row for each value of xnew and one column for each group, and it
contains the kernel density estimates of the groups at xnew, or their logarithms if logged is TRUE. A group
number without observations receives 0, or -Inf if logged is TRUE. Missing values of xnew receive NA.
}
\item{h}{
The bandwidth values used. If h is NULL, this is a named vector with the bandwidth of each group, with
NA for a group number without observations. Otherwise it is the supplied h.
}
}

\references{
Wand M.P. and Jones M.C. (1995). Kernel smoothing. CRC Press.
}

\author{
Michail Tsagris and Nikolaos Kontemeniotis.

R implementation and documentation: Michail Tsagris \email{mtsagris@uoc.gr}
and Nikolaos Kontemeniotis \email{kontemeniotisn@gmail.com}.
}

%\note{
%%  ~~further notes~~
%}

\seealso{
\code{\link{cv.kdeda}}
}

\examples{
x <- iris[, 4]
groups <- as.numeric(iris[, 5])
a <- kde_da(x, groups, x, h = c(0.1, 0.2))
b <- kde_da(x, groups, x, h = NULL)
d <- kde_da(x, groups, x, h = NULL, logged = TRUE)
}
