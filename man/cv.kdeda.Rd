\name{cv.kdeda}
\alias{cv.kdeda}
\title{
Cross-validation for the kernel discrimininant analysis
}

\description{
Cross-validation for the kernel discrimininant analysis.
}

\usage{
cv.kdeda(groups, x, h = seq(0.1, 1, length = 10), nfolds = 10,
         folds = NULL, seed = NULL, ncores = 1)
}

\arguments{
\item{groups}{
A variable indicating the groupings.
}
\ite{x}{
A numerical vector with the data.
}
\item{h}{
A vector with the bandwidth parameter values of the Gaussian kernel.
}
\item{nfolds}{
How many folds to create?
}
\item{folds}{
Do you already have a list with the folds? If not, leave this NULL.
}
\item{seed}{
If seed is TRUE, the results will always be the same.
}
\item{ncores}{
The number of cores to use.
}
}

\details{
This is described in Chapter 8.2 of Hansen (2019). The idea is to inimise the sum of squares of the residuals under the constraint \eqn{R^\top \bm{\beta} = c}. As mentioned above, be careful with the input you give in the x matrix and the R vector. The cls() function performs a single regression model, whereas the mcls() function performs a regression for each column of y. Each regression is independent of the others.
}

\value{
A list including:
\item{cv}{
A numerical matrix with the percentage of correct classification for each fold and bandwidth value.
}
\item{perf}{
The average percentage of correct classification for each bandwidth value.
}
\itme{hopt}{
The optimal bandwidh value.
}
}

\references{
Hansen, B. E. (2022). Econometrics, Princeton University Press.
}

\author{
Michail Tsagris.

R implementation and documentation: Michail Tsagris \email{mtsagris@uoc.gr}.
}

%\note{
%%  ~~further notes~~
%}

\seealso{
\code{\link{pls}, \link{int.cls}
}
}

\examples{
x <- iris[, 4]
groups <- as.numeric(iris[, 5])
a <- cv.kdeda(groups, x)
}
