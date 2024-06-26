#' Summary plot of cell barcode collapsing
#'
#' Plot the original frequency of each cell barcode in the original whitelist
#' against the frequency after collapsing similar cell barcodes.
#'
#' @author Charlotte Soneson
#'
#' @param cbTable \code{data.frame} (such as the \code{cbTable} returned by
#'     \code{readAlevinQC} or \code{readAlevinFryQC}) with barcode frequencies
#'     before and after collapsing.
#' @param firstSelColName Character scalar indicating the name of the logical
#'     column in \code{cbTable} that corresponds to the original selection of
#'     barcodes for quantification.
#' @param countCol Character scalar indicating the name of the column in
#'     \code{cbTable} that corresponds to the collapsed barcode frequencies.
#'
#' @export
#'
#' @importFrom ggplot2 ggplot aes geom_abline geom_point theme_bw theme
#'     element_text xlab ylab geom_label
#' @importFrom rlang .data
#' @import dplyr
#'
#' @return A ggplot object
#'
#' @examples
#' alevin <- readAlevinQC(system.file("extdata/alevin_example_v0.14",
#'                                    package = "alevinQC"))
#' plotAlevinBarcodeCollapse(alevin$cbTable)
#'
plotAlevinBarcodeCollapse <- function(cbTable,
                                      firstSelColName = "inFirstWhiteList",
                                      countCol = "collapsedFreq") {
    ## Check input arguments
    .assertVector(x = cbTable, type = "data.frame")
    .assertScalar(x = firstSelColName, type = "character",
                  validValues = colnames(cbTable))
    .assertScalar(x = countCol, type = "character",
                  validValues = colnames(cbTable))
    .assertVector(x = cbTable[[firstSelColName]], type = "logical")
    stopifnot(all(c(countCol, "originalFreq") %in%
                      colnames(cbTable)))

    ## Get selected BCs and calculate the average read gain
    mrg <- cbTable %>% dplyr::filter(.data[[firstSelColName]]) %>%
        dplyr::summarize(
            mrg = signif(100 * mean(.data[[countCol]]/.data$originalFreq - 1,
                                    na.rm = TRUE), 4)) %>%
        dplyr::pull(mrg)

    ## Plot
    ggplot2::ggplot(cbTable %>% dplyr::filter(.data[[firstSelColName]]),
                    ggplot2::aes(x = .data$originalFreq,
                                 y = .data[[countCol]])) +
        ggplot2::geom_abline(slope = 1, intercept = 0) +
        ggplot2::geom_point() +
        ggplot2::theme_bw() +
        ggplot2::theme(axis.title = ggplot2::element_text(size = 12)) +
        ggplot2::xlab("Observed cell barcode frequency") +
        ggplot2::ylab("Cell barcode frequency, following reassignment") +
        ggplot2::geom_label(data = data.frame(x = -Inf, y = Inf),
                            aes(x = .data$x, y = .data$y,
                                label = paste0("Mean read gain per CB: ",
                                               mrg, "%")),
                            hjust = -0.05, vjust = 1.3)
}
