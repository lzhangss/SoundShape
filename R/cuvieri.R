#' Advertisement call of \emph{Physalaemus cuvieri}
#'
#' Recording of \emph{Physalaemus cuvieri} (Amphibia, Anura, Leptodactylidae) advertisement call containing three notes emitted in a sequence. Edited from original \code{Wave} file for optimal sinal to noise ratio and reduced time duration.
#'
#' @docType data
#'
#' @usage data(cuvieri)
#'
#' @keywords datasets
#'
#' @details
#' Duration = 2.37 s. Sampling Frequency = 22050 Hz. Air temperature 22ºC.
#'
#' Recorded at São José dos Campos Municipality, São Paulo State, Brazil, on 24 September 2013.
#'
#' @format
#' An object of class \code{"Wave"}; see (\code{\link{tuneR}} package).
#'
#' @source
#' Original recording housed at Coleção Bioacústica da Universidade Federal de Minas Gerais (CBUFMG-00196). Recorded by Pedro Rocha.
#'
#' @examples
#' data(cuvieri)
#'
#' seewave::oscillo(cuvieri, f=22050)
#' seewave::spectro(cuvieri, f=22050)
"cuvieri"
