% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/gene.stats.R
\name{gene.stats}
\alias{gene.stats}
\title{Make statistical information for each gene across all the cells (SD, mean, expression, etc.)}
\usage{
gene.stats(x = NULL, which.data = "raw.data")
}
\arguments{
\item{x}{An object of class scSeqR.}

\item{which.data}{Choose from "raw.data" or "main.data", defult = "raw.data".}
}
\value{
An object of class scSeqR.
}
\description{
This function takes an object of class scSeqR and provides some statistical information for the genes.
}
\examples{
\dontrun{
my.obj <- gene.stats(my.obj, which.data = "main.data")
}
}
