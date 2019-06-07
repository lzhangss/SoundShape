#' Sound Waves Onto Morphometric Data
#'
#' @description
#' A set of functions that crosses the bridge between Bioacoustics and Geometric Morphometrics:
#'
#' \itemize{
#'   \item{\code{\link{align.wave}}: Automatic placement of calls at beggining of sound window.}
#'   \item{\code{\link{eigensound}}: Calculate spectrogram data for each \code{Wave} file on a given folder and acquire semilandmarks using either a three-dimensional representation of sound, or the cross-correlation between energy quantiles and a curve of relative amplitude.}
#'   \item{\code{\link{pca.plot}}: Plot ordination of Principal Components with convex hulls.}
#'   \item{\code{\link{hypo.surf}}}: Hypothetical three-dimensional plots of sound surfaces.
#'   \item{\code{\link{threeDspectro}}}: Colorful spectrograms from a single object of class \code{"Wave"}.
#' }
#'
#' @docType package
#' @name SoundShape
"_PACKAGE"
#'
#' @section Useful links:
#' \itemize{
#'  \item{\url{https://github.com/p-rocha/SoundShape}}
#'  \item{Report bugs at \url{https://github.com/p-rocha/SoundShape/issues}}}
#'  }
#'
#'  @author
#'  Pedro Rocha \email{p.rocha1990@gmail.com}
#'
#'  @references
#'  Rocha, P. & Romano, P. (\emph{in prep}) The shape of sound: A new \code{R} package that crosses the bridge between Geometric Morphometrics and Bioacoustics.
#'
#'  @export
#'
