#' Advertisement call of \emph{Physalaemus kroyeri}
#'
#' Recording of \emph{Physalaemus kroyeri} (Amphibia, Anura, Leptodactylidae) advertisement call containing three notes emitted in a sequence. Edited from original \code{Wave} file for optimal sinal to noise ratio and reduced time duration.
#'
#' @docType data
#'
#' @usage data(kroyeri)
#'
#' @keywords datasets
#'
#' @details
#' Duration = 3.91 s. Sampling Frequency = 44100 Hz. Air temperature 24ºC.
#'
#' Recorded at Ilhéus Municipality, Bahia State, Brazil, on 05 August 1972.
#'
#' @format
#' An object of the class \code{"Wave"} (\code{\link{tuneR}} package.
#'
#' @source
#' Original recording housed at Fonoteca Neotropical Jacques Vielliard (FNJV-0032047). Recorded by Werner Bokermann.
#'
#' @examples
#' data(kroyeri)
#'
#' seewave::oscillo(kroyeri, f=22050)
#' seewave::spectro(kroyeri, f=22050)
"kroyeri"
