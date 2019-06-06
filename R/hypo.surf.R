#' Three-dimensional plot of hypothetical sound surface for desired Principal Components
#'
#' @description
#'
#' @param threeD.out
#' @param PC
#' @param flim modifications of the frequency limits (Y-axis). Vector with two values in kHz. By default: \code{flim = c(0, 10)}
#' @param tlim modifications of the time limits (X-axis). Vector with two values in seconds. By default: \code{tlim = c(0, 1)}
#' @param x.length length of sequence (i.e. number of cells per side on sound window) to be used as sampling grid coordinates on the time (X-axis). Should be the same employed on \code{eigensound(analysis.type="threeDshape")}. By default: \code{x.length = 100}
#' @param y.length length of sequence (i.e. number of cells per side on sound window) to be used as sampling grid coordinates on the frequency (Y-axis). Should be the same employed on \code{eigensound(analysis.type="threeDshape")}. By default: \code{y.length = 70}
#' @param log.scale a logical. If \code{TRUE}, \code{eigensound} will use a logarithmic scale on the time (X-axis), which is recommeded when the analyzed sounds present great variation on this axis (e.g. emphasize short duration sounds). If \code{FALSE}, a linear scale is used instead (same as MacLeod et al., 2013). Should be the same employed on \code{eigensound(analysis.type="threeDshape")}. By default: \code{log.scale = TRUE}
#' @param f sampling frequency of \code{Wave} files (in Hz). By default: \code{f = 44100}
#' @param wl length of the window for the analysis. By default: \code{wl} = 512.
#' @param ovlp overlap between two successive windows (in \%) for increased spectrogram resolution. By default: \code{ovlp = 70}
#' @param main main title of output plot. By default: \code{main=PC} (i.e. same as intended PC)
#'
#'
#' @examples
#'
#'
#' @export
#'
hypo.surf <- function(threeD.out=NULL, PC=NULL, flim=c(0, 4), tlim=c(0, 0.8), y.length=60, x.length=80, log.scale=TRUE, f=44100, wl=512, ovlp=70, main=PC)
{
  if(is.null(threeD.out))
  {stop('Please define threeD.out as an object containing the output of eigensound function with analysis.type = "threeDshape')}

  if(is.null(PC))
  {stop('Specify which Principal Component will be used to generate hypothetical semilandmark configurations')}

  # Use sample as reference for hypothetical 3D surface
  data("cuvieri")

  # Acquire spectrogram values
  e <- seewave::spectro(cuvieri, f=f, wl=wl, ovlp=ovlp, flim=flim, tlim=tlim, plot=F)

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

  # Transform calculated PC into matrix of amplitude values
  if(PC=="PC1min"){hyp.threeD <- matrix(shapes$PC1min[,3], nrow=y.length, ncol=x.length, byrow = T)}
  if(PC=="PC1max"){hyp.threeD <- matrix(shapes$PC1max[,3],
                                        nrow=y.length, ncol=x.length, byrow = T)}
  if(PC=="PC2min"){hyp.threeD <- matrix(shapes$PC2min[,3],
                                        nrow=y.length, ncol=x.length, byrow = T)}
  if(PC=="PC2max"){hyp.threeD <- matrix(shapes$PC2max[,3],
                                        nrow=y.length, ncol=x.length, byrow = T)}
  if(PC=="PC3min"){hyp.threeD <- matrix(shapes$PC3min[,3],
                                        nrow=y.length, ncol=x.length, byrow = T)}
  if(PC=="PC3max"){hyp.threeD <- matrix(shapes$PC3max[,3],
                                        nrow=y.length, ncol=x.length, byrow = T)}

  # Hypothetical sound surface for desired Principal Component
  plot3D::persp3D(x=time.sub, y=freq.sub, z=t(hyp.threeD), theta=30, phi=35, resfac=1, r=3,
                  expand=0.5, scale=T, axes=T, ticktype="detailed", nticks=4,
                  cex.axis=0.7, border="black", lwd=0.1, col=seewave::spectro.colors(n=100),
                  xlab="Time coordinates", ylab="Frequency coordinates", zlab="Amplitude coordinates",
                  clab=expression('Amplitude'), main=main)

} #end function
