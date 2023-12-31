% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/plotAlevinQuantPairs.R
\name{plotAlevinQuantPairs}
\alias{plotAlevinQuantPairs}
\title{Pairs plot with quantification summary statistics}
\usage{
plotAlevinQuantPairs(
  cbTable,
  colName = "inFinalWhiteList",
  firstSelColName = "inFirstWhiteList"
)
}
\arguments{
\item{cbTable}{\code{data.frame} (such as the \code{cbTable} returned by
\code{readAlevinQC} or \code{readAlevinFryQC}) with collapsed barcode
frequencies, the total UMI count and the number of detected genes
for each cell.}

\item{colName}{Character scalar giving the name of a logical column of
\code{cbTable} to use for coloring the points.}

\item{firstSelColName}{Character scalar indicating the name of the logical
column in \code{cbTable} that corresponds to the original selection of
barcodes for quantification.}
}
\value{
A ggmatrix object
}
\description{
Pairs plot with quantification summary statistics
}
\examples{
alevin <- readAlevinQC(system.file("extdata/alevin_example_v0.14",
                                   package = "alevinQC"))
plotAlevinQuantPairs(alevin$cbTable, colName = "inFinalWhiteList")

}
\author{
Charlotte Soneson
}
