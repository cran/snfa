% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/fit.boundary.R
\name{fit.boundary}
\alias{fit.boundary}
\title{Multivariate smooth boundary fitting with additional constraints}
\usage{
fit.boundary(X.eval, y.eval, X.bounded, y.bounded, X.constrained = NA,
  X.fit = NA, y.fit.observed = NA, H.inv = NA, H.mult = 1,
  method = "u", scale.constraints = TRUE)
}
\arguments{
\item{X.eval}{Matrix of inputs used for fitting}

\item{y.eval}{Vector of outputs used for fitting}

\item{X.bounded}{Matrix of inputs where bounding constraints apply}

\item{y.bounded}{Vector of outputs where bounding constraints apply}

\item{X.constrained}{Matrix of inputs where monotonicity/concavity constraints apply}

\item{X.fit}{Matrix of inputs where curve is fit; defaults to X.constrained}

\item{y.fit.observed}{Vector of outputs corresponding to observations in X.fit; used for efficiency calculation}

\item{H.inv}{Inverse of the smoothing matrix (must be positive definite); defaults to rule of thumb}

\item{H.mult}{Scaling factor for rule of thumb smoothing matrix}

\item{method}{Constraints to apply; "u" for unconstrained, "m" for monotonically increasing, and "mc" for monotonically increasing and concave}

\item{scale.constraints}{Boolean, whether to scale constraints by their average value, can help with convergence}
}
\value{
Returns a list with the following elements
\item{y.fit}{Estimated value of the frontier at X.fit}
\item{gradient.fit}{Estimated gradient of the frontier at X.fit}
\item{efficiency}{Estimated efficiencies of y.fit.observed}
\item{solution}{Boolean; TRUE if frontier successfully estimated}
\item{X.eval}{Matrix of inputs used for fitting}
\item{X.constrained}{Matrix of inputs where monotonicity/concavity constraints apply}
\item{X.fit}{Matrix of inputs where curve is fit}
\item{H.inv}{Inverse smoothing matrix used in fitting}
\item{method}{Method used to fit frontier}
\item{scaling.factor}{Factor by which constraints are multiplied before quadratic programming}
}
\description{
Fits boundary of data with kernel smoothing, imposing monotonicity and/or concavity constraints.
}
\details{
This method fits a smooth boundary of the data (with all data points below the boundary)
while imposing specified monotonicity and concavity constraints. The procedure is
derived from Racine et al. (2009), which develops kernel smoothing methods with
bounding, monotonicity and concavity constraints. Specifically, the smoothing procedure
involves finding optimal weights for a Nadaraya-Watson estimator of the form 

\deqn{\hat{y} = m(x) = \sum_{i=1}^N p_i A(x, x_i) y_i,}

where \eqn{x} are inputs, \eqn{y} are outputs, \eqn{p} are weights, subscripts
index observations, and 

\deqn{A(x, x_i) = \frac{K(x, x_i)}{\sum_{h=1}^N K(x, x_h)}}

for a kernel \eqn{K}. This method uses a multivariate normal kernel of the form

\deqn{K(x, x_h) = \exp\left(-\frac12 (x - x_h)'H^{-1}(x - x_h)\right),}

where \eqn{H} is a bandwidth matrix. Bandwidth selection is performed via Silverman's
(1986) rule-of-thumb, in the function \code{H.inv.select}.

Optimal weights \eqn{\hat{p}} are selected by solving the quadratic programming problem

\deqn{\min_p \mbox{\ \ }-\mathbf{1}'p + \frac12 p'p.}

This method always imposes bounding constraints as specified points, given by

\deqn{m(x_i) - y_i = \sum_{h=1}^N p_h A(x_i, x_h) y_h - y_i \geq 0 \mbox{\ \ \ \ }\forall i.}

Additionally, monotonicity constraints of the following form can be imposed at 
specified points:

\deqn{\frac{\partial m(x)}{\partial x^j} = \sum_{h=1}^N p_h \frac{\partial A(x, x_h)}{\partial x^j} y_h \geq 0 \mbox{\ \ \ \ }\forall x, j,}

where superscripts index inputs. Finally concavity constraints of the following form can also be imposed using Afriat's
(1967) conditions:

\deqn{m(x) - m(z) \leq \nabla_x m(z) \cdot (x - z) \mbox{\ \ \ \ }\forall x, z.}

The gradient of the frontier at a point \eqn{x} is given by 

\deqn{\nabla_x m(x) = \sum_{i=1}^N \hat{p}_i \nabla_x A(x, x_i) y_i,}

where \eqn{\hat{p}_i} are estimated weights.
}
\examples{
data(univariate)

#Set up data for fitting

X <- as.matrix(univariate$x)
y <- univariate$y

N.fit <- 100
X.fit <- as.matrix(seq(min(X), max(X), length.out = N.fit))

#Reflect data for fitting
reflected.data <- reflect.data(X, y)
X.eval <- reflected.data$X
y.eval <- reflected.data$y

#Fit frontiers
frontier.u <- fit.boundary(X.eval, y.eval, 
                           X.bounded = X, y.bounded = y,
                           X.constrained = X.fit,
                           X.fit = X.fit,
                           method = "u")
                          
frontier.m <- fit.boundary(X.eval, y.eval, 
                           X.bounded = X, y.bounded = y,
                           X.constrained = X.fit,
                           X.fit = X.fit,
                           method = "m")
                          
frontier.mc <- fit.boundary(X.eval, y.eval, 
                            X.bounded = X, y.bounded = y,
                            X.constrained = X.fit,
                            X.fit = X.fit,
                            method = "mc")

#Plot frontier
library(ggplot2)

frontier.df <- data.frame(X = rep(X.fit, times = 3),
                          y = c(frontier.u$y.fit, frontier.m$y.fit, frontier.mc$y.fit),
                          model = rep(c("u", "m", "mc"), each = N.fit))

ggplot(univariate, aes(X, y)) +
  geom_point() +
  geom_line(data = frontier.df, aes(color = model))

#Plot slopes
slope.df <- data.frame(X = rep(X.fit, times = 3),
                       slope = c(frontier.u$gradient.fit,
                                 frontier.m$gradient.fit,
                                 frontier.mc$gradient.fit),
                       model = rep(c("u", "m", "mc"), each = N.fit))

ggplot(slope.df, aes(X, slope)) +
  geom_line(aes(color = model))
  
}
\references{
\insertRef{ParmeterRacine}{snfa}
}
