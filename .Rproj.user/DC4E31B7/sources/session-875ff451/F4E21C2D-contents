\name{kde_da}
\alias{kde_da}
\title{
Kernel discrimininant analysis
}

\description{
Kernel discrimininant analysis.
}

\usage{
kde_da(xnew, groups, x, h, ncores = 1L)
}

\arguments{
\item{xnew}{
The values of a new vector for which the group is to be predicted.
}
\item{x}{
A numeric vector with continuous data.
}
\item{groups}{
A vector with the groups (labels) of the data.
}
\item{h}{
A vector with one or more values for the bandwidth parameter of the Gaussian kernel.
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
\item{be}{
A numerical matrix with the constrained beta coefficients.
}
\item{mse}{
A numerical vector with the mean squared error.
}
}

\references{
Wand M.P. and Jones M.C. (1995). Kernel smoothing. CRC Press.
}

\author{
Michail Tsagris and Nikolas Kontemeniotis.

R implementation and documentation: Michail Tsagris \email{mtsagris@uoc.gr}
and Nikolas Kontemeniotis \email{kontemeniotisn@gmail.com}.
}

%\note{
%%  ~~further notes~~
%}

\seealso{
\code{\link{cv.kdeda}
}
}

\examples{
x <- iris[, 4]
groups <- as.numeric(iris[, 5])
a <- kde_da(x, groups, x, h = c(0.1, 0.2))
}
