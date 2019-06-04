#' Acquire frequency values for any quantile of energy
#'
#' @description
#' Calculation of frequency values that represent as many energy quantiles as desired. Codes adapted from \code{\link{specprop}} (\code{\link{seewave}} package).
#'
#'
#'
#' @param spec a data set resulting of a spectral analysis obtained with functions \code{\link{spec}} or \code{\link{meanspec}} (\code{\link{seewave}} package) (not in dB)
#' @param f sampling frequency of \code{spec} (in Hz)
#' @param mel a logical, if \code{TRUE} the (htk-)mel scale is used.
#' @param flim a vector of length 2 to specify the frequency limits of the analysis (in kHz)
#' @param EQ a vector of energy quantiles to be calculated (with 0 < \code{EQ} < 1). By default: \code{EQ = c(0.05, 0.15, 0.3, 0.5, 0.7, 0.85, 0.95)}
#'
#' @note
#' Codes of \code{frequencies} were adapted from \code{\link{specprop}} (\code{\link{seewave}} package) so that it returns a \code{data.frame} with frequency values that represent as many energy quantiles (\code{EQ}) as desired.
#'
#' In addition, arguments \code{spec}, \code{f}, \code{mel} and \code{flim} are the same as in \code{\link{specprop}}.
#'
#' @seealso
#' \code{\link{specprop}}, \code{\link{spec}}, \code{\link{meanspec}}, \code{\link{seewave}} package
#'
#' Useful links:
#' \itemize{
#'   \item{\url{https://github.com/p-rocha/SoundShape}}
#'   \item{Report bugs at \url{https://github.com/p-rocha/SoundShape/issues}}}
#'
#' @examples
#' library(seewave)
#'
#' data(tico)
#' sample.sound <- spec(tico)
#'
#' # assign result to object
#' sample.freq <- frequencies(sample.sound)
#'
#' # print result
#' print(sample.freq)
#'
#' # a given energy quantile
#' sample.freq2 <- frequencies(sample.sound, EQ = 0.2)
#'
#' # multiple energy quantiles
#' sample.freq3 <- frequencies(sample.sound, EQ = c(0.2, 0.4, 0.6, 0.8))
#'
#' # multiple energy quantiles within a predefined frequency bandwidth
#' sample.freq4 <- frequencies(sample.sound, EQ = 0.5, f=44100, flim = c(2.5, 10))
#'
#'
#' @references
#' Rocha, P. & Romano, P. (\emph{in prep}) The shape of sound: A new \code{R} package that crosses the bridge between Geometric Morphometrics and Bioacoustics.
#'
#' Sueur J., Aubin T., Simonis C. (2008). Seewave: a free modular tool for sound analysis and synthesis. \emph{Bioacoustics, 18}: 213-226
#'
#' @export
#'
frequencies <-  function (spec, EQ= c(0.05, 0.15, 0.3, 0.5, 0.7, 0.85, 0.95),
                          f = NULL, mel = FALSE, flim = NULL)
{
  fhz <- f
  if (!is.null(f) & mel) {f <- 2 * mel(f/2)}
  if (is.null(f)) {
    if (is.vector(spec))
      stop("'f' is missing")
    else if (is.matrix(spec))
      f <- spec[nrow(spec), 1] * 2000 * nrow(spec)/(nrow(spec) - 1)
  }
  if (is.matrix(spec)) {
    freq <- spec[, 1]
    freq = freq * 1000
    spec <- spec[, 2]
  }
  L <- length(spec)
  wl <- L * 2
  if (any(spec < 0))
    stop("The frequency spectrum to be analysed should not be in dB")
  if (!is.null(flim)) {
    if (flim[1] < 0 || flim[2] > fhz/2)
      stop("'flim' should range between 0 and f/2")
    if (mel)
      flim <- mel(flim * 1000)/1000
  }
  else {flim <- c(0, f/2000)}

  spec <- spec[(flim[1] * 1000 * wl/f):(flim[2] * 1000 * wl/f)]
  amp <- spec/sum(spec)
  cumamp <- cumsum(amp)
  freq <- seq(from = flim[1] * 1000, to = flim[2] * 1000, length.out = length(spec))

  for(i in EQ) # Frequency values according to desired energy quantiles
  { if(!exists("Qlist")) {Qlist <- data.frame()}
    if(exists("Qlist")) {
      Qtemp <- data.frame("Quantiles" = paste("EQ-", i, sep=""),
                          "Frequency values" = freq[length(cumamp[cumamp <= i]) + 1])
      Qlist <- rbind(Qlist, Qtemp)
      rm(Qtemp)
    }
  }
  results <- Qlist
}
