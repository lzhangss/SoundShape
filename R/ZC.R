#' Cross-correlation between the curve of relative amplitude and a frequency value
#'
#' @description
#' Return the intersections between a \code{\link{polygon}} and a frequency value (Y value).
#'
#' @param x an equation in the form \code{c(y.values) - frequency.value}, in which \code{y.values} is a vector containing the Y coordinates from a selected contour (i.e. \code{polygon})
#'
#' @details
#' This function has been developed by Jerome Sueur.
#'
#' @author
#' Jerome Sueur
#'
#' @seealso
#' \code{\link{twoDshape}}, \code{\link{eigensound}}
#'
#' Useful links:
#' \itemize{
#'   \item{\url{https://github.com/p-rocha/SoundShape}}
#'   \item{Report bugs at \url{https://github.com/p-rocha/SoundShape/issues}}}
#'
#' @examples
#' plot(x=c(0, 10), y=c(0, 10), type="n")
#' polygon(x=c(4, 4.5, 6, 8, 6), y=c(2, 6, 8, 1, 2))
#' ZC(c(2, 6, 8, 1, 2) - 5) # y values from the polygon minus any given value
#'
#' @references
#' Rocha, P. & Romano, P. (\emph{in prep}) The shape of sound: A new \code{R} package that crosses the bridge between Geometric Morphometrics and Bioacoustics.
#'
#' @export
#'
ZC <- function(x) {
  sign <- ifelse(x >= 0, 1, -1)
  res <- abs(diff(sign))
  return(res)
}
