#' Knee plot of raw cell barcode frequencies
#'
#' Plot the raw cell barcode frequencies in decreasing order, and indicate a
#' predetermined breakpoint (indicating barcodes included in the original
#' whitelist) using color as well as a label.
#'
#' @author Charlotte Soneson
#'
#' @param cbTable \code{data.frame} with raw barcode frequencies (such as the
#'     \code{cbTable} returned by \code{readAlevinQC} or
#'     \code{readAlevinFryQC}).
#' @param firstSelColName Character scalar indicating the name of the logical
#'     column in \code{cbTable} that corresponds to the original selection of
#'     barcodes for quantification.
#'
#' @export
#'
#' @importFrom ggplot2 ggplot geom_line aes scale_x_log10 xlab ylab theme_bw
#'     theme scale_color_manual geom_label element_text geom_rug
#' @import dplyr
#' @importFrom rlang .data
#'
#' @return A ggplot object
#'
#' @examples
#' alevin <- readAlevinQC(system.file("extdata/alevin_example_v0.14",
#'                                    package = "alevinQC"))
#' plotAlevinKneeRaw(alevin$cbTable)
#'
plotAlevinKneeRaw <- function(cbTable,
                              firstSelColName = "inFirstWhiteList") {
    ## Check input arguments
    .assertVector(x = cbTable, type = "data.frame")
    .assertScalar(x = firstSelColName, type = "character",
                  validValues = colnames(cbTable))
    .assertVector(x = cbTable[[firstSelColName]], type = "logical")
    stopifnot(all(c("ranking", "originalFreq") %in%
                      colnames(cbTable)))

    ## If all the barcodes in the first white list are in the top of the ranking,
    ## make a line plot. Otherwise, indicate the barcodes in the first whitelist
    ## with a rug
    if (max(cbTable$ranking[cbTable[[firstSelColName]]], na.rm = TRUE) <
        min(cbTable$ranking[!cbTable[[firstSelColName]]], na.rm = TRUE)) {
        g <- ggplot2::ggplot(cbTable,
                        ggplot2::aes(x = .data$ranking,
                                     y = .data$originalFreq)) +
            ggplot2::geom_line(linewidth = 2,
                               ggplot2::aes(color = .data[[firstSelColName]])) +
            ggplot2::scale_x_log10() +
            ggplot2::scale_y_log10() +
            ggplot2::xlab("Cell barcode rank") +
            ggplot2::ylab("Cell barcode frequency") +
            ggplot2::theme_bw() +
            ggplot2::theme(legend.position = "none",
                           axis.title = ggplot2::element_text(size = 12)) +
            ggplot2::scale_color_manual(values = c(`TRUE` = "red",
                                                   `FALSE` = "black"))
        if (any(!cbTable[[firstSelColName]])) {
            g <- g + ggplot2::geom_label(
                data = cbTable %>%
                    dplyr::filter(.data[[firstSelColName]]) %>%
                    dplyr::filter(ranking == max(ranking)),
                ggplot2::aes(label = paste0("(", ranking, ", ",
                                            originalFreq, ")")),
                hjust = 0, nudge_x = 0.1)
        }
    } else {
        g <- ggplot2::ggplot(cbTable,
                        ggplot2::aes(x = .data$ranking,
                                     y = .data$originalFreq)) +
            ggplot2::geom_line(linewidth = 2, color = "black") +
            ggplot2::scale_x_log10() +
            ggplot2::scale_y_log10() +
            ggplot2::xlab("Cell barcode rank") +
            ggplot2::ylab("Cell barcode frequency") +
            ggplot2::theme_bw() +
            ggplot2::theme(legend.position = "none",
                           axis.title = ggplot2::element_text(size = 12)) +
            ggplot2::geom_rug(data = cbTable %>%
                                  dplyr::filter(.data[[firstSelColName]]),
                              color = "red")
    }
    g
}
