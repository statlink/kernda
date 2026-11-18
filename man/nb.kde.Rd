\name{nb.kde}
\alias{nb.kde}
\title{
Kernel naive Bayes discriminant analysis
}

\description{
Kernel naive Bayes discriminant analysis.
}

\usage{
nb.kde(xnew, groups, x, h = NULL, ncores = 1L)
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
A vector with one or more positive values for the bandwidth parameter of the Gaussian kernel.
}
\item{ncores}{
The number of cores to use. It has an effect only if the package was compiled with OpenMP support.
}
}

\details{
The density of each group is estimated with a Gaussian kernel, using the same bandwidth for all groups,
and each new value is allocated to the group with the highest estimated posterior probability, using
the sample proportions as prior probabilities. The bandwidth is on the scale of x, since x is not
standardised. For values of xnew very far from the data the estimated densities may underflow to 0,
but the predicted groups are still computed correctly.
}

\value{
A list including:
\item{class}{
A vector with the predicted groups, one for each row of xnew.
}
\item{score}{
A matrix with one row for each row of xnew and one column for each group. It contains the sum of the
logarithms of the kernel density estimates over the variables plus the logarithm of the prior probability
of each group, that is, the logarithm of the unnormalised posterior probabilities.
}
}

\references{
Wand M.P. and Jones M.C. (1995). Kernel smoothing. CRC Press.
}

\author{
Michail Tsagris.

R implementation and documentation: Michail Tsagris \email{mtsagris@uoc.gr}.
}

%\note{
%%  ~~further notes~~
%}

\seealso{
\code{\link{kde_da}}
}

\examples{
x <- iris[, 1:4]
groups <- as.numeric(iris[, 5])
a <- nb.kde(x, groups, x, h = NULL )
}
