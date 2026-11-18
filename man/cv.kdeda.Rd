\name{cv.kdeda}
\alias{cv.kdeda}
\title{
Cross-validation for the kernel discriminant analysis
}

\description{
Cross-validation for the kernel discriminant analysis.
}

\usage{
cv.kdeda(groups, x, h = seq(0.1, 1, length = 10), nfolds = 10, folds = NULL, ncores = 1)
}

\arguments{
\item{groups}{
A variable indicating the groupings. Any labels are allowed, but not missing values.
}
\item{x}{
A numerical vector with the data. Missing values are not allowed.
}
\item{h}{
A vector with the bandwidth parameter values of the Gaussian kernel.
}
\item{nfolds}{
How many folds to create? This is ignored if folds is supplied.
}
\item{folds}{
Do you already have a list with the folds? If not, leave this NULL.
}
\item{ncores}{
The number of cores to use.
}
}

\details{
A k-fold cross-validation of \code{\link{kde_da}} is performed, with stratified folds, and the
proportion of correct classification is computed for each bandwidth value. The bandwidth is on the
scale of x, so the default values may need to be changed for data on a different scale. If many
bandwidth values have the same performance, the first of them is returned.
}

\value{
A list including:
\item{cv}{
A numerical matrix with the proportion of correct classification for each fold and bandwidth value.
}
\item{perf}{
The average proportion of correct classification for each bandwidth value.
}
\item{hopt}{
The optimal bandwidth value.
}
}

\references{
Wand M.P. and Jones M.C. (1995). Kernel smoothing. CRC Press.

Hastie T., Tibshirani R. and Friedman J. (2009). The elements of statistical learning.
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
\code{\link{kde_da}, \link{lr.kde}}
}

\examples{
x <- iris[, 4]
groups <- as.numeric( iris[, 5] )
a <- cv.kdeda(groups, x)
}
