#' Semilandmarks from a three-dimensional surface of sound
#'
#' @description
#' For each \code{".wav"} file on a given folder, compute spectrogram data and acquire semilandmarks using a three-dimensional representation of sound (same as in MacLeod et al., 2013).
#'
#' @param wav.at filepath to the folder where \code{".wav"} files are stored. Should be presented between quotation marks. By default: \code{wav.at = getwd()} (i.e. use current working directory)
#' @param store.at filepath to the folder where spectrogram plots and \code{tps} file will be stored. Should be presented between quotation marks. By default: \code{store.at = getwd()} (i.e. use current working directory)
#' @param dBlevel absolute amplitude value to be used as relative amplitude contour, which will serve as reference for semilandmark acquisition. By default: \code{dBlevel = 25}
#' @param flim modifications of the frequency limits (Y-axis). Vector with two values in kHz. By default: \code{flim = c(0, 10)}
#' @param tlim modifications of the time limits (X-axis). Vector with two values in seconds. By default: \code{tlim = c(0, 1)}
#' @param x.length length of sequence (i.e. number of cells per side on sound window) to be used as sampling grid coordinates on the time (X-axis).  By default: \code{x.length = 80}
#' @param y.length length of sequence (i.e. number of cells per side on sound window) to be used as sampling grid coordinates on the frequency (Y-axis). By default: \code{y.length = 60}
#' @param log.scale a logical. If \code{log.scale = TRUE}, \code{threeDshape} will use a logarithmic scale on the time (X-axis), which is recommeded when the analyzed sounds present great variation on this axis (i.e. emphasize short duration sounds). If \code{log.scale = FALSE}, a linear scale is used instead (same as MacLeod et al., 2013). By default: \code{log.scale = TRUE}
#' @param f sampling frequency of \code{Wave}'s for the analysis (in Hz). By default: \code{f = 44100}
#' @param wl length of the window for the analysis. By default: \code{wl = 512}
#' @param ovlp overlap between two successive windows (in \%) for increased spectrogram resolution. By default: \code{ovlp = 70}
#' @param plot.exp a logical. If \code{TRUE}, for each \code{".wav"} file on the folder indicated by \code{wav.at}, \code{threeDshape} will store a spectrogram image on the folder indicated by \code{store.at}. Plots consist of three-dimensional graphs in which semilandmards are represented either as points or as sound surface (see \code{plot.type}). By default: \code{plot.exp = TRUE}
#' @param plot.as only applies when \code{plot.exp = TRUE}. \code{plot.as = "jpeg"} will generate compressed images for quick inspection of semilandmarks; \code{plot.as = "tiff"} or \code{"tif"} will generate uncompressed high resolution images that can be edited and used for publication. By default: \code{plot.as = "jpeg"}
#' @param plot.type only applies when \code{plot.exp = TRUE}. \code{plot.type = "surface"} will produce simplified three-dimensional sound surfaces from the calculated semilandmarks (same output employed by MacLeod et al., 2013); \code{plot.type = "points"} will produce three-dimensional graphs with semilandmarks as points. By default: \code{plot.type = "surface"}
#' @param rotate.Xaxis only applies when \code{plot.exp = TRUE}. Rotation of the X-axis. Same as \code{theta} from \code{\link{persp3D}} (\code{\link{plot3D}} package). By default: \code{rotate.Xaxis = 60}
#' @param rotate.Yaxis only applies when \code{plot.exp = TRUE}. Rotation of the Y-axis. Same as \code{phi} from \code{\link{persp3D}} (\code{\link{plot3D}} package). By default: \code{rotate.Yaxis = 40}
#' @param TPS.file desired name for the \code{tps} file containing semilandmark coordinates. Should be presented between quotation marks. By default: \code{TPS.file = NULL} (i.e. prevents \code{threeDshape} from creating a \code{tps} file)
#'
#'
#' @note
#' In order to store the results from \code{threeDshape} function and proceed with the Geometric Morphometric steps of the analysis (e.g. \code{\link{geomorph}} package; Adams et al., 2017), one can simultaneosly assign the function's output to an \code{R} object and/or store them as a \code{tps} file to be used by numerous softwares of geometric analysis of shape, such as the TPS series (Rohlf, 2015).
#'
#' Additionally, one might also export three-dimensional plots of semilandmarks (if \code{plot.exp = TRUE}) either as simplified sound surfaces or as points (see \code{plot.type}). These images can be exported as \code{jpeg} (compressed image) or \code{tiff} (uncompressed image) file formats, which can be edited for publication purposes.
#'
#' @author Pedro Rocha
#'
#' @references
#' Adams, D. C., M. L. Collyer, A. Kaliontzopoulou & Sherratt, E. (2017) \emph{Geomorph: Software for geometric morphometric analyses}. R package version 3.0.5. https://cran.r-project.org/package=geomorph.
#'
#' MacLeod, N., Krieger, J. & Jones, K. E. (2013). Geometric morphometric approaches to acoustic signal analysis in mammalian biology. \emph{Hystrix, the Italian Journal of Mammalogy, 24}(1), 110-125.
#'
#' Rocha, P. & Romano, P. (\emph{in prep}) The shape of sound: A new \code{R} package that crosses the bridge between Geometric Morphometrics and Bioacoustics.
#'
#' Rohlf, F.J. (2015) The tps series of software. \emph{Hystrix 26}, 9-12.
#'
#' @seealso
#' \code{\link{twoDshape}}, \code{\link{eigensound}}, \code{\link{geomorph}}
#'
#' Useful links:
#' \itemize{
#'   \item{\url{https://github.com/p-rocha/SoundShape}}
#'   \item{Report bugs at \url{https://github.com/p-rocha/SoundShape/issues}}}
#'
#' @examples
#' library(seewave)
#' library(tuneR)
#'
#' # Create folder at current working directory to store ".wav" files
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
#' # Export ".wav" files containing selected acoustic units and store on previosly created folder
#' writeWave(cut.cuvieri1, filename = file.path(wav.at, "cut.cuvieri1.wav"), extensible = FALSE)
#' writeWave(cut.cuvieri2, filename = file.path(wav.at, "cut.cuvieri2.wav"), extensible = FALSE)
#' writeWave(cut.cuvieri3, filename = file.path(wav.at, "cut.cuvieri3.wav"), extensible = FALSE)
#'
#' # Align acoustic units selected at 1% of time window
#' align.wave(wav.at = wav.at, wav.to = "Aligned",
#'            time.length = 0.5, time.perc = 0.01, dBlevel = 25)
#'
#' # Verify alignment using twoDshape function
#' twoDshape(wav.at = file.path(wav.at, "Aligned"), store.at = store.at,
#'           flim=c(0, 3), tlim=c(0,0.5), dBlevel = 25, plot.exp = TRUE)
#' # To see jpeg files created, check folder specified by store.at
#'
#' # Run threeDshape function on aligned ".wav" files
#' # Store results as R object and tps file
#' threeD.sample <- threeDshape(wav.at = file.path(wav.at, "Aligned"), store.at = store.at,
#'                       x.length = 80, y.length = 60, TPS.file = "threeDshape.sample.tps",
#'                       flim=c(0, 4), tlim=c(0, 0.8), f=44100, dBlevel = 25, log.scale = FALSE,
#'                       plot.exp = TRUE, plot.as = "jpeg", plot.type = "surface")
#' # Go to folder specified by store.at and check jpeg files created
#'
#' @export
#'
threeDshape <- function(wav.at = getwd(), store.at = getwd(), dBlevel=25, flim=c(0, 10), tlim = c(0, 1), x.length=80, y.length=60, log.scale=TRUE, f=44100, wl=512, ovlp=70, plot.exp = TRUE, plot.as = "jpeg", plot.type = "surface", rotate.Xaxis=60, rotate.Yaxis=40, TPS.file = NULL){

# Create TPS file before analysis
if(!is.null(TPS.file)){
  TPS.path <- paste(store.at, "/", TPS.file, ".tps",  sep="")
  file.create(TPS.path, showWarnings = TRUE)
}

# Loop to acquire semilandmark coordinates for each ".wav" file on a given folder
for(file in list.files(wav.at, pattern = ".wav"))
{
  Wav <- tuneR::readWave(paste(wav.at,"/", file, sep=""))

  # Store spectrogram as R object
  e <- seewave::spectro(Wav, f=f, wl=wl, ovlp=ovlp, flim=flim, tlim=tlim, plot=F)

  # Create sequences to use as new grid
  freq.seq <- seq(1, length(e$freq), length = y.length)

  ifelse(isTRUE(log.scale),
         time.seq <- 10^(seq(log10(1), log10(length(e$time)), length.out = x.length)),#log
         time.seq <- seq(1, length(e$time), length.out = x.length)) # linear scale

  # Subset original coordinates by new sequences
  time.sub <- e$time[time.seq]
  freq.sub <- e$freq[freq.seq]

  # Subset matrix of amplitude values using new sequences
  amp.sub <- e$amp[freq.seq, time.seq]

  # Reassign background amplitude values
  for(i in 1:length(amp.sub)){if(amp.sub[i] == -Inf |amp.sub[i] <= -dBlevel)
  {amp.sub[i] <- -dBlevel}}

  # Assign time and frequency coordinates as column and row names of amplitude matrix
  colnames(amp.sub) <- time.sub
  rownames(amp.sub) <- freq.sub

  # Transform amplitude matrix into semilandmark 3D coordinates
  ind.3D <- as.matrix(stats::setNames(reshape2::melt(t(amp.sub)), c('time', 'freq', 'amp')))

  # Store semilandmark coordinates in array
  ifelse(!exists('coord3D'),
         coord3D <- array(data=ind.3D, dim=c(dim(ind.3D), 1)),
         coord3D <- abind::abind(coord3D, ind.3D, along=3))


  # Plot semilandmarks as points or sound surface
  if(plot.exp==TRUE){
    if(plot.as == "jpeg"){grDevices::jpeg(width =5000,height = 3500, units = "px", res = 500,
       filename=paste(store.at,"/", sub(".wav","",file), ".jpg", sep=""))} # compressed images
    if(plot.as=="tiff"|plot.as=="tif"){grDevices::tiff(width=5000, height=3500, units="px", res=500,
       filename=paste(store.at, "/", sub(".wav", "", file), ".tif", sep=""))} # uncompressed images
    if(plot.type=="surface"){plot3D::persp3D(x=time.sub, y=freq.sub, z=t(amp.sub),
       border="black", lwd=0.1, theta=rotate.Xaxis, phi=rotate.Yaxis, resfac=1, r=3,expand=0.5, cex.axis=0.7,
       scale=T, axes=T, col=seewave::spectro.colors(n=100), ticktype="detailed", nticks=4,
       xlab="Time (s)", ylab="Frequency (kHz)", zlab="Amplitude (dB)",
       main= sub(".wav", "", file), clab=expression('Amplitude dB'))}
    if(plot.type=="points"){plot3D::scatter3D(x=ind.3D[,1], y=ind.3D[,2], z=ind.3D[,3],
       pch=21, cex=0.5, theta=rotate.Xaxis, phi=rotate.Yaxis, resfac=1, r=3, expand=0.5, cex.axis=0.7,
       scale=T, axes=T, col=seewave::spectro.colors(n=100), ticktype="detailed", nticks=4,
       xlab="Time (s)", ylab="Frequency (kHz)", zlab="Amplitude (dB)",
       main= sub(".wav", "", file), clab=expression('Amplitude dB'))}

    grDevices::dev.off()
  } #end plot

  # Export semilandmark coordinates as TPS file
  if(!is.null(TPS.file)){
    lmline <- paste("LM=", dim(ind.3D)[1], sep="")
    write(lmline, TPS.path, append = TRUE)
    utils::write.table(ind.3D, TPS.path, col.names = FALSE, row.names = FALSE, append =TRUE)
    idline <- paste("ID=", sub(".wav", "", file), sep="")
    write(idline, TPS.path, append = TRUE)
    write("", TPS.path, append = TRUE)
    rm(lmline, idline)
  } #end tps file
} #end loop

# Assign names to arrays' third dimension
dimnames(coord3D)[[3]] <- sub(".wav","", list.files(wav.at, pattern = ".wav"))
results <- coord3D

} #end function
