#' Semilandmarks from a two-dimensional curve of relative amplitude
#'
#' @description
#' For each \code{".wav"} file on a given folder, compute spectrogram data and acquire semilandmarks using cross-correlation between energy quantiles and a two-dimensional curve of relative amplitude (\code{dBlevel}).
#'
#' @param wav.at filepath to the folder where \code{".wav"} files are stored. Should be presented between quotation marks. By default: \code{wav.at = getwd()} (i.e. use current working directory)
#' @param store.at filepath to the folder where \code{tps} file and spectrogram plots will be stored. Should be presented between quotation marks. By default: \code{store.at = getwd()} (i.e. use current working directory)
#' @param add.points a logical. If \code{TRUE}, \code{twoDshape} will compute semilandmarks acquired by cross-correlation between energy quantiles (i.e. \code{EQ}) and a curve of relative amplitude (i.e. \code{dBlevel}). If \code{plot.exp = TRUE}, semilandmarks will be included in spectrogram plots. By default: \code{add.points = FALSE} (see \code{Details}).
#' @param add.contour only applies when \code{plot.exp = TRUE}. A logical. If \code{TRUE}, exported spectrogram plots will include the longest curve of relative amplitude at the level specified by \code{dBlevel}. By default: \code{add.contour = TRUE}
#' @param dBlevel absolute amplitude value to be used as relative amplitude contour, which will serve as reference for semilandmark acquisition. By default: \code{dBlevel = 25}
#' @param flim modifications of the frequency limits (Y-axis). Vector with two values in kHz. By default: \code{flim = c(0, 10)}
#' @param tlim modifications of the time limits (X-axis). Vector with two values in seconds. By default: \code{tlim = c(0, 1)}
#' @param trel set the relative scale to be used on the time (X-axis); relative to the numbers displayed on the X-axis of spectrogram plots. By default: \code{trel == tlim}
#' @param mag.time optional argument for magnifying the time coordinates. This is sometimes desired for small sound windows (e.g. less than 1 s), in which time coordinates will be on a different scale than that of frequency coordinates. In those cases, it is recommended to include \code{mag.time = 10} or \code{mag.time = 100}, depending on lenght of sound window. By default: \code{mag.time = 1} (i.e. no magnification is performed)
#' @param EQ only applies when \code{add.points = TRUE}. A vector of energy quantiles intended (with \code{0 < EQ < 1}). By default: \code{EQ = c(0.05, 0.15, 0.3, 0.5, 0.7, 0.85, 0.95)} \strong{Note:} When dealing with narrow banded calls, any additional values could cause an error in subsequent steps of the analysis.
#' @param f sampling frequency of \code{Wave}'s for the analysis (in Hz). By default: \code{f = 44100}
#' @param wl length of the window for the analysis. By default: \code{wl = 512}
#' @param ovlp overlap between two successive windows (in percentage) for increased spectrogram resolution. By default: \code{ovlp = 70}
#' @param plot.exp a logical. If \code{TRUE}, for each \code{".wav"} file on the folder indicated by \code{wav.at}, \code{twoDshape} will store a spectrogram image on the folder indicated by \code{store.at}. Plots consist of spectrograms images and may include the longest curve of relative amplitude (\code{add.contour = TRUE}) and semilandmarks as points (\code{add.points = TRUE}). By default: \code{plot.exp = TRUE}
#' @param plot.as only applies when \code{plot.exp = TRUE}. \code{plot.as = "jpeg"} will generate compressed images for quick inspection of semilandmarks; \code{plot.as = "tiff"} or \code{"tif"} will generate uncompressed high resolution images that can be edited and used for publication. By default: \code{plot.as = "jpeg"}
#' @param TPS.file only applies when \code{add.points = TRUE}. Desired name for the \code{tps} file containing semilandmark coordinates. Should be presented between quotation marks. By default: \code{TPS.file = NULL} (i.e. prevents \code{twoDshape} from creating a \code{tps} file)

#'
#' @details
#' When \code{add.points = TRUE}, \code{twoDshape} will compute spectrogram data and acquire semilandmarks through cross-correlation between energy quantiles (i.e. \code{EQ}) and a curve of relative amplitude (i.e. \code{dBlevel}). However, this is often subtle and prone to incur in errors (e.g. bad alignment of acoustic units; inappropriate X and Y coordinates for the sound window; narrow banded calls). Therefore, a more robust protocol for error verification is achieved using \code{add.points = FALSE} and \code{add.contour = TRUE} (default), which allow for quick verification of acoustic units alignment and the shape of each curve of relative amplitude (specified by \code{dBlevel}).
#'
#' @note
#' In order to store the results from \code{twoDshape} function and proceed with the Geometric Morphometric steps of the analysis (e.g. \code{\link{geomorph}} package; Adams et al., 2017), one can simultaneosly assign the function's output to an \code{R} object and/or store them as a \code{tps} file to be used by numerous softwares of geometric analysis of shape, such as the TPS series (Rohlf, 2015).
#'
#' Additionally, one might also export spectrogram images with contour and semilandmarks ploted, which is very useful as a protocol for error verification through semilandmark inspection (see Zelditch et al., 2012 for protocols of error verification in Geometric Morphometrics). These images can be exported as \code{jpeg} (compressed image) or \code{tiff} (uncompressed image) file formats.
#'
#' @author Pedro Rocha
#'
#' @references
#' Adams, D. C., M. L. Collyer, A. Kaliontzopoulou & Sherratt, E. (2017) \emph{Geomorph: Software for geometric morphometric analyses}. R package version 3.0.5. https://cran.r-project.org/package=geomorph.
#'
#' Rocha, P. & Romano, P. (\emph{in prep}) The shape of sound: A new \code{R} package that crosses the bridge between Geometric Morphometrics and Bioacoustics.
#'
#' Rohlf, F.J. (2015) The tps series of software. \emph{Hystrix 26}, 9-12.
#'
#' Zelditch, M. L., Swiderski, D. L., Sheets, H. D. & Fink, W. L. (2012). \emph{Geometric morphometrics for biologists: A primer.} Elsevier (Second Edition). Elsevier, San Diego.
#'
#' @seealso
#' \code{\link{threeDshape}}, \code{\link{eigensound}}, \code{\link{geomorph}}
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
#' # Run twoDshape and store semilandmark coordinates on tps file
#' twoDshape(wav.at = wav.at, store.at = store.at, add.points=TRUE,
#'           flim=c(0, 3), tlim=c(0,0.5), plot.exp = TRUE, plot.as = "jpeg",
#'           TPS.file = "twoDshape-example.tps")
#' # Go to folder specified by store.at and check jpeg files created
#'
#' @export
#'
twoDshape <- function(wav.at = getwd(), store.at = getwd(), add.points=FALSE, add.contour=FALSE, dBlevel=25, flim=c(0, 10), tlim=c(0, 1), trel=tlim, EQ= c(0.05, 0.15, 0.3, 0.5, 0.7, 0.85, 0.95), mag.time=1, f=44100, wl=512, ovlp=70, plot.exp=TRUE, plot.as="jpeg", TPS.file=NULL)  {

  # Create TPS file before analysis
  if(!is.null(TPS.file) && add.points==FALSE)
    stop("Must set add.points = TRUE to acquire two-dimensional semilandmarks and store them on a '.tps' file")

  if(!is.null(TPS.file)){
    TPS.path <- paste(store.at, "/", TPS.file, ".tps",  sep="")
    file.create(TPS.path, showWarnings = TRUE)
  } # end create TPS.file

  # Zero crossing for each file on a given folder
  for(file in list.files(wav.at, pattern = ".wav"))
  {
    Wav <- tuneR::readWave(paste(wav.at,"/", file, sep=""))

    # Store spectrogram as R object
    s <- seewave::spectro(Wav, f=f, wl=wl, ovlp=ovlp, flim=flim, tlim=tlim, plot=FALSE)

    # Selection of longest relative amplitude contour
    if(add.contour==TRUE||add.points==TRUE){
      con <- grDevices::contourLines(x=s$time, y=s$freq, z=t(s$amp), levels=seq(-dBlevel, -dBlevel, 1))
      n <- numeric(length(con))
      for(i in 1:length(con)) n[i] <- length(con[[i]]$x)
      n.max <- which.max(n)
      con <- con[[n.max]]
    } # end add.contour=TRUE

    if(add.points==TRUE){
      # Initial and final time values within relative amplitude contour
      t.beg <- min(con$x)
      t.end <- max(con$x)

      # Minimum and maximum frequency values within relative amplitude contour
      f.min <- min(con$y) # Minimum frequency
      t.min <- con$x[con$y==f.min] # Time value associated

      f.max <- max(con$y) # Maximum frequency
      t.max <- con$x[con$y==f.max] # Time value associated

      # Power spectrum calculated within maximum and minimum frequency values, and initial and final time      values within the longest contour
      pwr.spec <- seewave::spec(Wav, f=f, wl=wl, from=t.beg, to=t.end, plot=F)
      fvalues <- frequencies(pwr.spec, f=f, flim=c(f.min, f.max))
      fvalues$Frequency.values <- (fvalues$Frequency.values)/1000 # Convert values to kHz

      # Acquire zero crossing between calculated frequency quantiles and relative amplitude contour
      for(i in seq_along(fvalues$Frequency.values)) {
        zc.res <- ZC(con$y - fvalues$Frequency.values[i])
        t.pos <- which(zc.res==2)

        if(!exists("t1")|!exists("t2")){
          t1 <- vector(mode="integer", length=length(fvalues$Frequency.values))
          t2 <- vector(mode="integer", length=length(fvalues$Frequency.values))
        }

        if(exists("t1")|exists("t2")){
          t1[i] <- min(con$x[t.pos])
          t2[i] <- max(con$x[t.pos])
        }
      } # end loop of frequency values

      # Coordinates for plotting
      SM1 <- data.frame(cbind(fvalues, "Time"= t1))
      SM2 <- data.frame(cbind(fvalues, "Time"= t2))

      # Re-order SM1 so that points ploting will be anticlockwise
      SM1 <- SM1[order(SM1[,2], decreasing=T), ]

      # Store SM-min and SM-max in a data.frame
      SM.min <- data.frame("Quantiles" = "EQ-min", "Frequency.values"= f.min, "Time"= t.min)
      SM.max <- data.frame("Quantiles" = "EQ-max", "Frequency.values"= f.max, "Time"= t.max)

      # Semilandmark numbers
      SM.numbers <- as.factor(1:((length(EQ)*2) + 2)) # Twice the length of EQ plus the SM-min and SM-max

      # Complete data.frame with coordinates of x and y
      SM <- cbind(SM.numbers, data.frame(rbind(SM.max, SM1, SM.min, SM2)))

      # Magnify time coordinates
      SM[,4] <- SM[,4]*mag.time

      # Store semilandmark coordinates as array of matrices
      SM.mtx <- as.matrix(SM[,4:3])
      ifelse(!exists('coord2D'),
             coord2D <- array(data=SM.mtx, dim=c(dim(SM.mtx), 1)),
             coord2D <- abind::abind(coord2D, SM.mtx, along=3))
    } # end add.points = TRUE

    # Plot over spectrogram
    if(plot.exp == TRUE){
      if(plot.as == "jpeg"){grDevices::jpeg(width =5000,height = 3500, units = "px", res = 500,
                                 filename=paste(store.at,"/", sub(".wav","",file), ".jpg", sep=""))} # compressed images
      if(plot.as=="tiff"|plot.as=="tif"){grDevices::tiff(width=5000, height=3500, units="px", res=500,
                                              filename=paste(store.at, "/", sub(".wav", "", file), ".tif", sep=""))} # uncompressed images
      seewave::spectro(Wav, f=f, wl=wl, ovlp=ovlp, osc=F, scale=F, grid=F,
              main= sub(".wav", "", file), trel=trel, flim=flim, tlim=tlim)
      if(add.contour==TRUE){graphics::polygon(x=con$x, y=con$y, lwd=1.5)} # end contour
      if(add.points==TRUE){graphics::points(x=(SM$Time)/mag.time, y=SM$Frequency.values,
                                  pch=21, col="black", bg="red", cex=1.1)
        graphics::text(x=(SM$Time)/mag.time, y=SM$Frequency.values,cex=0.7,
             labels=SM$SM.numbers,
             pos=c(3, rep(2, dim(SM1)[1]), 1, rep(4, dim(SM2)[1]))) ## SM numbers
      } # end points

      grDevices::dev.off() } # end plot.exp = TRUE

    # Export semilandmark coordinates as TPS file
    if(!is.null(TPS.file)){
      lmline <- paste("LM=", dim(SM)[1], sep="")
      write(lmline, TPS.path, append = TRUE)
      utils::write.table(SM[,4:3], TPS.path, col.names = FALSE, row.names = FALSE, append = TRUE)
      idline <- paste("ID=", sub(".wav", "", file), sep="")
      write(idline, TPS.path, append = TRUE)
      write("", TPS.path, append = TRUE)
      rm(lmline, idline, SM)
    } # end update TPS.file

  } # end loop for each ".wav" file

  # Assign names to arrays' third dimension
  if(add.points==TRUE){
    dimnames(coord2D)[[3]] <- sub(".wav","",
                                  list.files(wav.at, pattern = ".wav"))
    coord <- coord2D
    } # end add.poins = TRUE
  else( coord <- NULL)

  results <- coord
}
