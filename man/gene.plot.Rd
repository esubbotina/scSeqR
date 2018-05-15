% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/gene.plot.R
\name{gene.plot}
\alias{gene.plot}
\title{Find optimal number of clusters.}
\usage{
gene.plot(x = NULL, gene = "NULL", box.to.test = 0,
  box.pval = "sig.signs")
}
\arguments{
\item{x}{An object of class scSeqR.}

\item{clust.num}{Number of clusters}
}
\value{
An object of class scSeqR.
}
\description{
This function takes an object of class scSeqR and finds optimal number of clusters based on three methods.
}
\examples{
\dontrun{
gene.plot(my.obj, gene = "NULL", box.to.test = 0, box.pval = "sig.signs")
}
}