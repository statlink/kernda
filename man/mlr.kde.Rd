\name{mlr.kde}
\alias{mlr.kde}
\title{
Kernel regression with a multinomial response
}

\description{
Kernel regression with a multinomial response.
}

\usage{
mlr.kde(xnew, groups, x, h, ncores = 1)
}

\arguments{
\item{xnew}{
A numeric matrix, data.frame or vector with the new predictor variables, whose class probabilities
are to be estimated.
}
\item{groups}{
The multinomial response values (either a factor or a numerical vector).
}
\item{x}{
A numeric matrix, data.frame or vector with the available predictor variables.
Missing values are not allowed.
}
\item{h}{
The bandwidth value(s) to use.
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
A list including:
\item{prob}{
The estimated probabilities of belonging to class 1.
}
\item{cl}{
The estimated classes.
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
\code{\link{lr.kde}}
}

\examples{
groups <- iris[, 5]
x <- iris[, 1:4]
est <- mlr.kde(x, groups, x, h = c(0.1, 0.2) )
}
