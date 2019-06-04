#' Automatic placement of calls at beggining of sound window
#' 
#' @description Recreate each \code{wave} file on a given folder while placing calls at the beggining of sound window.
#' 
#' @param f sampling frequency of \code{wave} files (in Hz). By default: \code{f = 44100}
#' @param wl length of the window for the analysis. By default: \code{wl} = 512.
#' @param ovlp overlap between two successive windows (in \%) for increased spectrogram resolution. By default: \code{ovlp = 70}
#' @param dBlevel absolute amplitude value to be used as relative amplitude contour, which will serve as reference for call placement. By default: \code{dBlevel = 25}
#' @param wav.at filepath to the folder where \code{wave} files are stored. Should be presented between quotation marks. By default: \code{wav.at = getwd()} (i.e. use current working directory)
#' @param wav.to name of the folder where new \code{wave} files will be stored. Should be presented between quotation marks. By default: \code{wav.to = "Aligned"}
#' @param time.length intended length in seconds for the time (X-axis) so that it encompasses all sounds in the study. By default: \code{time.length = 4}
#' @param time.perc slight time gap (in \%) relative to the intended length that encompass all sounds in the study (i.e. \code{time.length}). Intervals are added before and after the minimum and maximum time coordinates (X-values) of the selected curve of relative amplitude (\code{dBlevel}). By default: \code{time.perc = 0.005} (i.e. 0.5\%)
#' 
#' @author Pedro Rocha
#' 
#' @seealso 
#' \code{\link{threeDshape}}, \code{\link{twoDshape}}, \code{\link{eigensound}}
#' 
#' @examples 
#' library(seewave) 
#' library(tuneR)
#' 
#' data("tico")
#' 
#' # Select acoustic units to be analyzed
#' cut.tico1 <- cutw(tico, f=44100, from=0, to=0.22, output = "Wave")
#' cut.tico2 <- cutw(tico, f=44100, from=0.22, to=0.44, output = "Wave")
#' cut.tico3 <- cutw(tico, f=44100, from=0.44, to=0.66, output = "Wave")
#'
#' # Create folder to store wave files
#' dir.create("C:/R/example align.wave")
#' 
#' # Create folder to store results
#' dir.create("C:/R/example align.wave/output")
#'
#' # Export new wave files containing acoustic units and store on previosly created folder
#' writeWave(cut.tico1, filename = "C:/R/example align.wave/cut.tico1.wav", extensible = FALSE)
#' writeWave(cut.tico2, filename = "C:/R/example align.wave/cut.tico2.wav", extensible = FALSE)
#' writeWave(cut.tico3, filename = "C:/R/example align.wave/cut.tico3.wav", extensible = FALSE)
#' 
#' # Align acoustic units selected at 3% of time window
#' align.wave(wav.at = "C:/R/example align.wave", wav.to = "Aligned",
#'            time.length = 0.3, time.perc = 0.03, dBlevel = 20)
#'            
#' # Verify alignment
#' eigensound(analysis.type = "twoDshape", flim=c(0, 12), tlim=c(0,0.3), dBlevel = 20, 
#'           wav.at = "C:/R/example align.wave/Aligned", 
#'           store.at = "C:/R/example align.wave/output",
#'           plot.exp = TRUE, plot.as = "jpeg")
#' 
#' # To see jpeg files created, check folder specified by store.at
#' 
#' 
#' @references 
#' MacLeod, N., Krieger, J. & Jones, K. E. (2013). Geometric morphometric approaches to acoustic signal analysis in mammalian biology. \emph{Hystrix, the Italian Journal of Mammalogy, 24}(1), 110-125.
#' 
#' Rocha, P. & Romano, P. (\emph{in prep}) The shape of sound: A new \code{R} package that crosses the bridge between Geometric Morphometrics and Bioacoustics. \emph{Methods in Ecology and Evolution}.
#' 
#' 
#' @export
#' 
align.wave <- function(wav.at=getwd(), wav.to="Aligned", dBlevel=25, time.length=4, time.perc=0.005, f=44100, wl=512, ovlp=70)  {

  # Create folder to store aligned calls
  if(!dir.exists(file.path(wav.at, wav.to))) dir.create(file.path(wav.at, wav.to))
  
  # Replace sounds for each wave file in a folder
  for(file in list.files(wav.at, pattern = ".wav")){
    
    orig.wav0 <- tuneR::readWave(paste(wav.at,"/", file, sep=""))
    
    # Add silence to fill sound window and prevent error
    orig.wav <- seewave::addsilw(orig.wav0, f=f, at="end", d=(time.length*10), output = "Wave")
  
    # create spectro object
    orig.spec <- seewave::spectro(orig.wav, f=f, wl=wl, ovlp=ovlp, osc=F, grid=F, plot=F) 
    
    # Acquire contours
    cont.spec <- grDevices::contourLines(x=orig.spec$time, y=orig.spec$freq, z=t(orig.spec$amp), 
                              levels=seq(-dBlevel,-dBlevel,1))
    
    # vectors to store minimum and maximum time values
    min.spec <- numeric(length(cont.spec)) 
    max.spec <- numeric(length(cont.spec)) 
    
    # minimum and maximum time values among contours detected
    for(i in 1:length(min.spec)){min.spec[i] <- min(cont.spec[[i]]$x)} 
    for(i in 1:length(max.spec)){max.spec[i] <- max(cont.spec[[i]]$x)} 
    
    # minimum and maximum time values 
    t.min <- min(min.spec)
    t.max <- max(max.spec)
    
    if((t.min-(time.perc*time.length))<=0)
      stop("Time percentage is too large. Consider a smaller value of 'time.perc'")
    
    # cut wave file using minimum and maximum time values
    short.wav0 <- seewave::deletew(orig.wav, f=f, output = "Wave",
                          from = (t.max+(time.perc*time.length)), to = max(orig.spec$time))
    
    short.wav <- seewave::deletew(short.wav0, f=f, output = "Wave",
                         from = 0, to = (t.min-(time.perc*time.length)))
    
    
    # Add silence to fill sound window
    final.wav <- seewave::addsilw(short.wav, f=f, at="end", d=time.length, output = "Wave")
    
    tuneR::writeWave(final.wav, file.path(wav.at, wav.to, file), extensible = F)
  
    } #end loop
  
  } #end function


  
  
  
  
  