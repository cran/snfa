% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/data.R
\docType{data}
\name{USMacro}
\alias{USMacro}
\title{US Macroeconomic Data}
\format{A data frame with 89 observations of four variables.
\describe{
  \item{Year}{Year}
  \item{Y}{Real GDP, in billions of dollars}
  \item{K}{Capital stock, in billions of dollars}
  \item{K.price}{Annual cost of $1 billion of capital, using 10-year treasury}
  \item{L}{Labor force, in thousands of people}
  \item{L.price}{Annual wage for one thousand people}
}}
\source{
\url{https://fred.stlouisfed.org/}
}
\usage{
USMacro
}
\description{
A dataset of real output, labor force, capital stock,
wages, and interest rates for the U.S. between 1929 and 2014, 
as available. All nominal values converted to 2010 U.S. dollars
using GDP price deflator.
}
\keyword{datasets}
