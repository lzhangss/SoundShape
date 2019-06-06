#' Advertisement call of \emph{Physalaemus centralis}
#'
#' Recording of \emph{Physalaemus centralis} (Amphibia, Anura, Leptodactylidae) advertisement call containing three notes emitted in a sequence. Edited from original \code{Wave} file for optimal sinal to noise ratio and reduced time duration.
#'
#' @docType data
#'
#' @usage data(centralis)
#'
#' @keywords datasets
#'
#' @details
#' Duration = 2.89 s. Sampling Frequency = 44100 Hz. Air temperature 25ºC.
#'
#' Recorded at Formoso do Araguaia Municipality, Tocantins State, Brazil, on 9 December 1992.
#'
#' @format
#' An object of the class \code{"Wave"} (\code{\link{tuneR}} package.
#'
#' @source
#' Original recording housed at Fonoteca Neotropical Jacques Vielliard (FNJV-0031188). Recorded by Adão José Cardoso.
#'
#' @examples
#' data(centralis)
#'
#' seewave::oscillo(centralis, f=22050)
#' seewave::spectro(centralis, f=22050)
"centralis"
