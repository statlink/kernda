\name{lr.kde}
\alias{lr.kde}
\alias{lr.kde2}
\alias{lr.kde3}
\title{
Kernel regression with a binary response
}

\description{
Kernel regression with a binary response.
}

\usage{
lr.kde(xnew, groups, x, h, ncores = 1)
lr.kde2(groups, x, h, nfolds = 10, folds = NULL, ncores = 1)
lr.kde3(groups, x, h = seq(0.01, 2, by = 0.01), nfolds = 10,
folds = NULL, ncores = 1)
}

\arguments{
\item{xnew}{
A numeric matrix, data.frame or vector with the new predictor variables, whose class probabilities
are to be estimated.
}
\item{groups}{
The binary response values (0s and 1s). This is a vector, while lr.kde() also accepts a matrix
with many binary responses.
}
\item{x}{
A numeric matrix, data.frame or vector with the available predictor variables.
Missing values are not allowed.
}
\item{h}{
For lr.kde() the bandwidth value(s) to use. For lr.kde2() a vector with the lower and the upper
end of the interval to search. For lr.kde3() the bandwidth values to consider.
}
\item{nfolds}{
The number of folds used to choose the bandwidth. This is ignored if folds is supplied.
}
\item{folds}{
If you have the list with the folds supply it here. You can also leave it NULL and it will create folds.
}
\item{ncores}{
The number of cores to use. If greater than 1, parallel computing will take
place. It is advisable to use it if you have many observations and or many
variables, otherwise it will slow down the process. The default is 1, meaning
that code is executed serially.
}
}

\details{
The Nadaraya-Watson estimator is applied. The predictor variables are standardised by the function
\code{kern_reg} of the package \pkg{kernreg}, so the bandwidth is in standard deviation units.

The function lr.kde2() chooses the bandwidth value that maximizes the cross-validated AUC, using the
command optimize(). The AUC is a step function of the bandwidth and it may have many local maxima, so
optimize() may not find the global maximum. The function lr.kde3() computes the cross-validated AUC
for given bandwidth values and plots the results. Cross-validation is used because the AUC computed
on the training data favours ever smaller bandwidth values and approaches 1, even for pure noise.
}

\value{
For lr.kde() a list including:

\item{prob}{
The estimated probabilities of belonging to class 1.
}
\item{cl}{
The estimated classes.
}

For lr.kde2() a vector with the optimal bandwidth (hopt) and its cross-validated AUC (auc).

For lr.kde3() a list including:

\item{perf}{
The cross-validated AUC for each bandwidth value.
}
\item{hopt}{
The optimal bandwidth value.
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
\code{\link{cv.lrkde}}
}

\examples{
groups <- as.numeric( iris[51:150, 5] ) - 2
x <- iris[51:150, 2:4]
est <- lr.kde(x, groups, x, h = c(0.1, 0.2) )
lr.kde2(groups, x, h = c(0.05, 2), nfolds = 5, seed = 1)
lr.kde3(groups, x, h = seq(0.1, 1, by = 0.1), nfolds = 5, seed = 1)
}
