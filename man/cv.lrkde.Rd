\name{cv.lrkde}
\alias{cv.lrkde}
\title{
Cross-validation for the kernel regression with a binary response
}

\description{
Cross-validation for the kernel regression with a binary response.
}

\usage{
cv.lrkde(groups, x, h = seq(0.1, 1, length = 10), nfolds = 10,
folds = NULL, graph = FALSE, ncores = 1)
}

\arguments{
\item{groups}{
A vector with the binary response (0s and 1s).
}
\item{x}{
A numeric matrix, data.frame or vector with the available predictor variables.
Missing values are not allowed.
}
\item{h}{
A vector with the bandwidth value(s) \eqn{h} to consider.
}
\item{nfolds}{
The number of folds. Set to 10 by default. This is ignored if folds is supplied.
}
\item{folds}{
If you have the list with the folds supply it here. You can also leave it NULL and it will create folds.
}
\item{graph}{
If graph is TRUE a plot will appear. The default value is FALSE.
}
\item{ncores}{
The number of cores to use. Default value is 1.
}
}

\details{
A k-fold cross-validation for the kernel regression with a binary response is performed
and the AUC is computed. The predictor variables are standardised by the function
\code{kern_reg} of the package \pkg{kernreg}, using the training sample, so the bandwidth is in
standard deviation units. A test fold containing one class only has no AUC and it is ignored
when averaging.
}

\value{
A list including:
\item{cv}{
A numerical matrix with the AUC for each fold and bandwidth value.
}
\item{perf}{
The average AUC for each bandwidth value.
}
\item{hopt}{
The optimal bandwidth value.
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
groups <- as.numeric( iris[1:100, 5] ) - 1
x <- iris[1:100, 2:4]
cv.lrkde(groups, x)
}
