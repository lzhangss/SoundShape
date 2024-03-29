#' Hypothetical three-dimensional plots of sound surfaces
#'
#' @description
#' Using the coordinates acquired by \code{eigensound(analysis.type = "threeDshape")}, this function creates three-dimensional plots containing hypothetical sound surfaces that represent minimum and maximum deformations relative to Principal Components.
#'
#' \strong{Note:} The output of \code{hypo.surf} must be interpreted along with the ordination of Principal Components (e.g. \code{\link{pca.plot}}), both featuring the same object used for \code{threeD.out}. By doing so, \code{hypo.surf} enhance the comprehension on how sound shape changed along the ordination plot .
#'
#' @param threeD.out the output of \code{\link{eigensound}} analysis with \code{analysis.type = "threeDshape"}. By default: \code{threeD.out = NULL} (i.e. output must be specified before ploting)
#' @param PC Principal Component intended for the plot. By default: \code{PC = 1}
#' @param flim modifications of the frequency limits (Y-axis). Vector with two values in kHz. Should be the same employed on \code{eigensound(analysis.type="threeDshape")} By default: \code{flim = c(0, 10)}
#' @param tlim modifications of the time limits (X-axis). Vector with two values in seconds. Should be the same employed on \code{eigensound(analysis.type="threeDshape")}. By default: \code{tlim = c(0, 1)}
#' @param x.length length of sequence (i.e. number of cells per side on sound window) to be used as sampling grid coordinates on the time (X-axis). Should be the same employed on \code{eigensound(analysis.type="threeDshape")}. By default: \code{x.length = 100}
#' @param y.length length of sequence (i.e. number of cells per side on sound window) to be used as sampling grid coordinates on the frequency (Y-axis). Should be the same employed on \code{eigensound(analysis.type="threeDshape")}. By default: \code{y.length = 70}
#' @param log.scale a logical. If \code{TRUE}, \code{hypo.surf} will use a logarithmic scale on the time (X-axis), which is recommeded when the analyzed sounds present great variation on this axis (e.g. emphasize short duration sounds). If \code{FALSE}, a linear scale is used instead (same as MacLeod et al., 2013). Should be the same employed on \code{eigensound(analysis.type="threeDshape")}. By default: \code{log.scale = TRUE}
#' @param f sampling frequency of \code{".wav"} files (in Hz). Should be the same employed on \code{eigensound(analysis.type="threeDshape")}. By default: \code{f = 44100}
#' @param wl length of the window for the analysis. Should be the same employed on \code{eigensound(analysis.type="threeDshape")}. By default: \code{wl = 512}
#' @param ovlp overlap between two successive windows (in \%) for increased spectrogram resolution. Should be the same employed on \code{eigensound(analysis.type="threeDshape")}. By default: \code{ovlp = 70}
#' @param plot.exp a logical. If \code{TRUE}, exports the three-dimensional output plot containing minimum and maximum deformations for the desired Principal Component. Exported plot will be stored on the folder indicated by \code{store.at}. By default: \code{plot.exp = FALSE}
#' @param plot.as only applies when \code{plot.exp = TRUE}. \code{plot.as = "jpeg"} will generate compressed images for quick inspection; \code{plot.as = "tiff"} or \code{"tif"} will generate uncompressed high resolution images that can be edited and used for publication. By default: \code{plot.as = "jpeg"}
#' @param store.at only applies when \code{plot.exp = TRUE}. Filepath to the folder where output plots will be stored. Should be presented between quotation marks. By default: \code{store.at = getwd()} (i.e. use current working directory)
#' @param rotate.Xaxis rotation of the X-axis. Same as \code{theta} from \code{\link{persp3D}} (\code{\link{plot3D}} package). By default: \code{rotate.Xaxis = 60}
#' @param rotate.Yaxis rotation of the Y-axis. Same as \code{phi} from \code{\link{persp3D}} (\code{\link{plot3D}} package). By default: \code{rotate.Yaxis = 40}
#'
#' @note
#' Some of codes from \code{hypo.surf} were adapted from \code{\link{plotTangentSpace}} (\code{\link{geomorph}} package). More specifically, the chunk related to the acquisition of hypothetical point configurations for each Principal Component (calculated by \code{\link{prcomp}}, \code{\link{stats}} package) is exactly the same as in \code{\link{plotTangentSpace}}.
#'
#'
#'
#' @seealso
#' \code{\link{plotTangentSpace}}, \code{\link{geomorph}}, \code{\link{eigensound}}, \code{\link{threeDshape}}, \code{\link{pca.plot}}
#'
#' Useful links:
#' \itemize{
#'   \item{\url{https://github.com/p-rocha/SoundShape}}
#'   \item{Report bugs at \url{https://github.com/p-rocha/SoundShape/issues}}}

#' @author
#' Pedro Rocha
#'
#'
#' @examples
#' data(eig.sample)
#'
#' # PCA using three-dimensional semilandmark coordinates
#' pca.eig.sample <- stats::prcomp(geomorph::two.d.array(eig.sample))
#'
#' # Verify names for each acoustic unit and the order in which they appear
#' dimnames(eig.sample)[[3]]
#'
#' # Create factor to use as groups in subsequent ordination plot
#' sample.gr <- factor(c(rep("centralis", 3), rep("cuvieri", 3), rep("kroyeri", 3)))
#'
#' # Clear current R plot to prevent errors
#' grDevices::dev.off()
#'
#' # Plot result of Principal Components Analysis
#' pca.plot(PCA.out = pca.eig.sample, groups = sample.gr, conv.hulls = sample.gr,
#'          main="PCA of 3D coordinates", leg=TRUE, leg.pos = "top")
#'
#' # Verify hypothetical sound surfaces using hypo.surf
#' hypo.surf(threeD.out=eig.sample, PC=1, flim=c(0, 4), tlim=c(0, 0.8), x.length=80, y.length=60)
#'
#'
#' @export
#'
hypo.surf <- function(threeD.out=NULL, PC=1, flim=c(0, 4), tlim=c(0, 0.8), x.length=80, y.length=60, log.scale=TRUE, f=44100, wl=512, ovlp=70, plot.exp=FALSE, plot.as="jpeg", store.at = getwd(), rotate.Xaxis=60, rotate.Yaxis=40)
{
  PCmax <- PC*2
  PCmin <- (PC*2)-1

  if(is.null(threeD.out))
  {stop('Please define threeD.out as an object containing the output of eigensound function with analysis.type="threeDshape')}

  if(is.null(PC))
  {stop('Verify hypo.surf documentation and choose a mininum or maximum Principal Component to generate hypothetical semilandmark configurations')}

  # Use sample as reference for hypothetical 3D surface
  #data("cuvieri")

  # Acquire spectrogram values
  e <- seewave::spectro(SoundShape::cuvieri, f=f, wl=wl, ovlp=ovlp, flim=flim, tlim=tlim, plot=F)

  # Create new sequences representing the sampling grid
  freq.seq <- seq(1, length(e$freq), length=y.length)
  ifelse(isTRUE(log.scale),
         time.seq <- 10^(seq(log10(1), log10(length(e$time)), length.out = x.length)),#log
         time.seq <- seq(1, length(e$time), length.out = x.length)) # linear scale

  # Subset original coordinates using new sequences
  time.sub <- e$time[time.seq]
  freq.sub <- e$freq[freq.seq]

  # Principal Components Analysis (PCA) using point coordinates
  PCA.out = stats::prcomp(geomorph::two.d.array(threeD.out))

  # Acquisition of hypothetical shapes (codes adapted from geomorph::plotTangentSpace)
  pcdata = PCA.out$x
  ref = geomorph::mshape(threeD.out)
  p = dim(threeD.out)[1]
  k = dim(threeD.out)[2]

  shapes <- shape.names <- NULL
  for (i in 1:ncol(pcdata)) {
    pcaxis.min <- min(pcdata[, i])
    pcaxis.max <- max(pcdata[, i])
    pc.min <- pc.max <- rep(0, dim(pcdata)[2])
    pc.min[i] <- pcaxis.min
    pc.max[i] <- pcaxis.max
    pc.min <- as.matrix(pc.min %*% (t(PCA.out$rotation))) +
      as.vector(t(ref))
    pc.max <- as.matrix(pc.max %*% (t(PCA.out$rotation))) +
      as.vector(t(ref))
    shapes <- rbind(shapes, pc.min, pc.max)
    shape.names <- c(shape.names, paste("PC", i, "min", sep = ""),
                     paste("PC", i, "max", sep = ""))
  }
  shapes <- geomorph::arrayspecs(shapes, p, k)
  shapes <- lapply(seq(dim(shapes)[3]), function(x) shapes[, , x])
  names(shapes) <- shape.names

  if(PC > (length(shapes)/2)){
    stop('Invalid number of Principal Components')}

  # Transform calculated PC into matrix of amplitude values
  min.hPC <- matrix(shapes[[PCmin]][,3], nrow=y.length, ncol=x.length, byrow = T)
  max.hPC <- matrix(shapes[[PCmax]][,3], nrow=y.length, ncol=x.length, byrow = T)

  # Hypothetical sound surfaces for desired Principal Component
  if(plot.exp==TRUE){
    if(plot.as == "jpeg"){
      grDevices::jpeg(width=8000,height=3500,units="px",res=500,
                      filename=paste(store.at,"/", "Hypothetical surfaces - PC", PC, ".jpg", sep=""))} # compressed images
    if(plot.as=="tiff"|plot.as=="tif"){
      grDevices::tiff(width=8000, height=3500, units="px", res=500,
                      filename=paste(store.at,"/", "Hypothetical surfaces - PC", PC,".tif", sep=""))} # uncompressed images
  } # end plot.exp=TRUE
  graphics::par(mfrow=c(1,2))
  plot3D::persp3D(x=time.sub, y=freq.sub, z=t(min.hPC), theta=rotate.Xaxis, phi=rotate.Yaxis, resfac=1, r=3,
                  expand=0.5, scale=T, axes=T, ticktype="detailed", nticks=4,
                  cex.axis=0.7, border="black", lwd=0.1, col=seewave::spectro.colors(n=100),
                  xlab="Time coordinates", ylab="Frequency coordinates", zlab="Amplitude coordinates",
                  clab=expression('Amplitude'), main=paste("PC", PC, " - Minimum", sep=""))

  plot3D::persp3D(x=time.sub, y=freq.sub, z=t(max.hPC), theta=rotate.Xaxis, phi=rotate.Yaxis, resfac=1, r=3,
                  expand=0.5, scale=T, axes=T, ticktype="detailed", nticks=4,
                  cex.axis=0.7, border="black", lwd=0.1, col=seewave::spectro.colors(n=100),
                  xlab="Time coordinates", ylab="Frequency coordinates", zlab="Amplitude coordinates",
                  clab=expression('Amplitude'), main=paste("PC", PC, " - Maximum", sep=""))
  if(plot.exp==TRUE){grDevices::dev.off()}

} #end function
