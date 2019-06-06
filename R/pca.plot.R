#' Plot ordination of Principal Components with convex hulls
#'
#' @description
#' Ordination of Principal Components from the output of a PCA performed by \code{\link{prcomp}} function (\code{\link{stats}} package).
#'
#' @author Pedro Rocha
#'
#' @param PCA.out the output of a Principal Components Analysis performed by \code{\link{prcomp}} function (\code{\link{stats}} package). By default: \code{PCA.out = NULL} (i.e. output must be specified before ploting)
#' @param groups groups to use as colors and/or convex hulls. Must be a \code{factor} object with the same length as the number of rows in the coordinates of \code{PCA.out} (i.e. \code{length(groups) == nrow(PCA.out$x)}). By default: \code{groups = NULL} (i.e. \code{factor} must be specified before ploting)
#' @param col.gp a \code{factor} object with the colours intended for \code{groups}. Must be the same length as the number of levels from \code{groups} (i.e. \code{length(col.gp) == length(levels(groups))}). By default: \code{col.gp = grDevices::rainbow(length(levels(groups)))} (i.e. colors defined automatically)
#' @param conv.hulls groups to use for convex hulls. Must be a \code{factor} object with the same length as the number of rows in the coordinates of \code{PCA.out} (i.e. \code{length(conv.hulls) == nrow(PCA.out$x)}). By default: \code{conv.hulls = NULL} (i.e. plot without convex hulls)
#' @param col.conv a \code{factor} object with the colours intended for \code{conv.hulls}. Must be the same length as the number of levels in \code{conv.hulls} (i.e. \code{length(col.conv) == length(levels(conv.hulls))}). By default: \code{col.conv = grDevices::rainbow(length(levels(conv.hulls)))} (i.e. colors defined automatically)
#' @param PCs a vector of length two with the Principal Components intended for the plot. By default: \code{PCs = c(1, 2)}
#' @param main main title of output plot. Should be presented between quotation marks. By default: \code{main = "Ordination of PCA coordinates"}
#' @param leg a logical. If \code{TRUE}, a legend is added to plot. By default: \code{leg = FALSE}
#' @param leg.labels only applies when \code{leg = TRUE}. Must be the same length of levels in \code{groups} (i.e. \code{length(leg.labels) == length(levels(groups))}). By default: \code{leg.labels = groups} (i.e. labels will be the same as the levels from \code{groups})
#' @param leg.pos specify legend location in the plot by using a keyword from the list: \code{"bottomright"}, \code{"bottom"}, \code{"bottomleft"}, \code{"left"}, \code{"topleft"}, \code{"top"}, \code{"topright"}, \code{"right"} and \code{"center"}. Alternatively, a single value can be provided and used for both margins, or two values, in which the first is used for X distance, and the second for Y distance. See also \code{\link{legend}} for details. By default: \code{leg.pos = "topright"}
#' @param sp.as enables one to choose between ploting elements as \code{"points"} or \code{"text"}. If \code{sp.as = "text"}, then one must also input a \code{factor} of characters to use as text (i.e. \code{sp.text}). By default: \code{sp.as = "points"}
#' @param sp.text only applies when \code{sp.as = "text"}. A \code{factor} including elements as texts intended in the plot. Has to be the same length as the number of rows in the coordinates of \code{PCA.out} (i.e. \code{length(sp.text) == nrow(PCA.out$x)}) . By default: \code{sp.text = NULL}
#'
#' @return
#' Require the output of \code{prcomp} and a vector with \code{groups} to plot. In addition, it is also possible to include convex hulls around each group (i.e. \code{conv.hulls}) and to control the colors intended for each group (i.e. \code{col.gp}) and for each convex hull (i.e. \code{col.conv}).
#'
#' @seealso
#' \code{\link{prcomp}}, \code{\link{palette}}, \code{\link{rgb}}, \code{\link{rainbow}}, \code{\link{legend}}
#'
#' Useful links:
#' \itemize{
#'   \item{\url{https://github.com/p-rocha/SoundShape}}
#'   \item{Report bugs at \url{https://github.com/p-rocha/SoundShape/issues}}}
#'
#' @references
#' Rocha, P. & Romano, P. (\emph{in prep}) The shape of sound: A new \code{R} package that crosses the bridge between Geometric Morphometrics and Bioacoustics.
#'
#' @examples
#' library(seewave)
#' library(tuneR)
#'
#' # Create folder at current working directory to store Wave files
#' wav.at <- file.path(getwd(), "example SoundShape")
#' dir.create(wav.at)
#'
#' # Create folder to store results
#' store.at <- file.path(getwd(), "example SoundShape/output")
#' dir.create(store.at)
#'
#' # Select acoustic units to be analyzed
#' data(cuvieri)
#' spectro(cuvieri, flim = c(0,4)) # Visualize sound data that will be used
#'
#' # Cut acoustic units from original Wave
#' data(cuvieri)
#' spectro(cuvieri, flim = c(0,4))
#' cut.cuvieri1 <- cutw(cuvieri, f=44100, from=0, to=0.5, output = "Wave")
#' cut.cuvieri2 <- cutw(cuvieri, f=44100, from=0.7, to=1.2, output = "Wave")
#' cut.cuvieri3 <- cutw(cuvieri, f=44100, from=1.4, to=1.9, output = "Wave")
#'
#' data("centralis")
#' spectro(centralis, flim = c(0,4))
#' cut.centralis1 <- cutw(centralis, f=44100, from=0.1, to=0.8, output = "Wave")
#' cut.centralis2 <- cutw(centralis, f=44100, from=1.05, to=1.75, output = "Wave")
#' cut.centralis3 <- cutw(centralis, f=44100, from=2.1, to=2.8, output = "Wave")
#'
#' data("kroyeri")
#' spectro(kroyeri, flim = c(0,4))
#' cut.kroyeri1 <- cutw(kroyeri, f=44100, from=0.1, to=1, output = "Wave")
#' cut.kroyeri2 <- cutw(kroyeri, f=44100, from=1.5, to=2.3, output = "Wave")
#' cut.kroyeri3 <- cutw(kroyeri, f=44100, from=2.9, to=3.8, output = "Wave")
#'
#' # Export Wave files containing acoustic units and store on previosly created folder
#' writeWave(cut.cuvieri1, filename = file.path(wav.at, "cut.cuvieri1.wav"), extensible = FALSE)
#' writeWave(cut.cuvieri2, filename = file.path(wav.at, "cut.cuvieri2.wav"), extensible = FALSE)
#' writeWave(cut.cuvieri3, filename = file.path(wav.at, "cut.cuvieri3.wav"), extensible = FALSE)
#' writeWave(cut.centralis1, filename = file.path(wav.at, "cut.centralis1.wav"), extensible = FALSE)
#' writeWave(cut.centralis2, filename = file.path(wav.at, "cut.centralis2.wav"), extensible = FALSE)
#' writeWave(cut.centralis3, filename = file.path(wav.at, "cut.centralis3.wav"), extensible = FALSE)
#' writeWave(cut.kroyeri1, filename = file.path(wav.at, "cut.kroyeri1.wav"), extensible = FALSE)
#' writeWave(cut.kroyeri2, filename = file.path(wav.at, "cut.kroyeri2.wav"), extensible = FALSE)
#' writeWave(cut.kroyeri3, filename = file.path(wav.at, "cut.kroyeri3.wav"), extensible = FALSE)
#'
#' # Place sounds at beggining of sound window before analysis
#' align.wave(wav.at = wav.at, wav.to = "Aligned",
#'            time.length = 0.8, time.perc = 0.005, dBlevel = 25)
#'
#' # Verify alignment using analysis.type = "twoDshape"
#' eigensound(analysis.type = "twoDshape", wav.at = file.path(wav.at, "Aligned"),
#'            store.at = store.at, flim=c(0, 4), tlim=c(0, 0.8), f=44100,
#'            plot.exp = TRUE, plot.as = "jpeg", dBlevel = 25)
#' # Go to folder specified by store.at and check jpeg files created
#'
#' # Run eigensound function using analysis.type = "threeDshape" on aligned wave files
#' # Store results as R object and tps file
#' eig.sample <- eigensound(analysis.type="threeDshape", flim=c(0, 4), tlim=c(0, 0.8), dBlevel = 25,
#'                         wav.at = file.path(wav.at, "Aligned"), store.at = store.at,
#'                         x.length = 80, y.length = 60, plot.exp = TRUE, plot.type = "surface",
#'                         TPS.file = "eigensound.sample.tps", log.scale = TRUE)
#' # Go to folder specified by store.at and check jpeg files created
#'
#' # PCA using three-dimensional semilandmark coordinates
#' pca.eig.sample <- prcomp(geomorph::two.d.array(eig.sample))
#'
#' # Create factor to use as groups in subsequent eigensound
#' sample.gr <- factor(c(rep("centralis", 3), rep("cuvieri", 3), rep("kroyeri", 3)))
#'
#' # Clear current R plot to prevent errors
#' dev.off()
#'
#' # Plot result of Principal Components Analysis
#' pca.plot(PCA.out = pca.eig.sample, groups = sample.gr, conv.hulls = sample.gr,
#'          main="PCA of 3D coordinates", leg=TRUE, leg.pos = "top")
#'
#' @export
#'
pca.plot <- function(PCA.out=NULL, PCs=c(1,2), groups=NULL, col.gp = grDevices::rainbow(length(levels(groups))),
                     conv.hulls=NULL, col.conv=grDevices::rainbow(length(levels(conv.hulls))),
                     leg=FALSE, leg.labels=groups, leg.pos="topright",
                     main="Ordination of PCA coordinates", sp.as="points", sp.text=NULL){

  if(is.null(PCA.out))
  {stop('Please define PCA.out as an object containing the output of a Principal
        Components Analysis performed by prcomp function')}

  if(is.null(groups))
  {stop('Please define a vector to be used as groups')}

  # Store PC scores as new object
  PCscores <- summary(PCA.out)$importance

  # Use PC scores as labels in PCA visualization
  xlab = paste("Principal Component ", as.character(PCs[1]), " (",
               round(PCscores[2,PCs[1]]*100, 1), "%)", sep="")
  ylab = paste("Principal Component ", as.character(PCs[2])," (",
               round(PCscores[2,PCs[2]]*100, 1), "%)", sep="")

  # create a colour vector to colour the groups
  names(col.gp) = levels(groups)  # dimension labels
  col.groups = col.gp[match(groups, names(col.gp))]  # assign a colour to each specimen

  #Principal components species distribution
  graphics::plot(PCA.out$x[,PCs[1]], PCA.out$x[,PCs[2]], type='n', las=1, xlab=xlab, ylab=ylab, main=main,
       cex.axis=1.1, cex.lab=1.55, cex.main=1.8)

  # Add convex hulls
  if(!is.null(conv.hulls)){ for(j in 1:nlevels(conv.hulls)) {
    # Get edge points (used to plot convex hull):
    edge_points = rownames(PCA.out$x[which(conv.hulls == levels(conv.hulls)[j]),])[
      grDevices::chull(PCA.out$x[which(conv.hulls == levels(conv.hulls)[j]), PCs])]
    # Plot convex hull as polygon:
    graphics::polygon(PCA.out$x[edge_points, PCs], col = grDevices::adjustcolor(col.conv[j], alpha.f = 0.1), border = col.conv[j])
  }}
  if(sp.as=="points"){graphics::points(PCA.out$x[,PCs[1]], PCA.out$x[,PCs[2]], pch=21, cex=1.5, bg=col.groups)}
  if(sp.as=="text"){graphics::text(PCA.out$x[,PCs[1]], PCA.out$x[,PCs[2]], as.factor(sp.text), col=col.groups, cex=1.4)}

  # Add legend
  if(leg==TRUE){graphics::legend(x=leg.pos, legend=unique(leg.labels), pch=21, pt.bg=unique(col.groups))}
}
