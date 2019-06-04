#' Sound waves onto morphometric data
#' 
#' @description 
#' For each \code{wave} file on a given folder, compute spectrogram data and acquire semilandmarks using a three-dimensional representation of sound (\code{analysis.type = "threeDshape"}), or the cross-correlation between energy quantiles and a curve of relative amplitude (\code{analysis.type = "twoDshape"}).
#' 
#' @param analysis.type type of analysis intended. If \code{analysis.type = "threeDshape"}, semilandmarks are acquired from spectrogram data using a three-dimensional representation of sound (MacLeod et al., 2013). If \code{analysis.type = "twoDshape"}, semilandmarks are acquired using energy quantiles and a two-dimensional curve of relative amplitude. By default: \code{analysis.type = NULL} (i.e. method must be specified before the analysis).
#' @param f sampling frequency of \code{wave} files (in Hz). By default: \code{f = 44100}
#' @param wl length of the window for the analysis. By default: \code{wl} = 512.
#' @param ovlp overlap between two successive windows (in \%) for increased spectrogram resolution. By default: \code{ovlp = 70}
#' @param dBlevel absolute amplitude value to be used as relative amplitude contour, which will serve as reference for semilandmark acquisition in both \code{"threeDshape"} and \code{"twoDshape"}. By default: \code{dBlevel = 25}
#' @param wav.at filepath to the folder where \code{wave} files are stored. Should be presented between quotation marks. By default: \code{wav.at = getwd()} (i.e. use current working directory)
#' @param store.at filepath to the folder where \code{tps} file and spectrogram plots will be stored. Should be presented between quotation marks. By default: \code{store.at = getwd()} (i.e. use current working directory)
#' @param flim modifications of the frequency limits (Y-axis). Vector with two values in kHz. By default: \code{flim = c(0, 10)}
#' @param tlim modifications of the time limits (X-axis). Vector with two values in seconds. By default: \code{tlim = c(0, 1)}
#' @param trel only applies when \code{analysis.type = "twoDshape"}. When \code{tlim} is not null, set the relative scale to be used in the time (X-axis); relative to the numbers displayed on the time (X-axis) of spectrogram plots. By default: \code{trel = tlim} 
#' @param mag.time only applies when \code{analysis.type = "twoDshape"}. Optional argument for magnifying the time coordinates (X-axis). This is sometimes desired for small sound windows (e.g. less than 1 s), in which the time coordinates will be on a different scale than that of frequency coordinates. In those cases, it is recommended to include \code{mag.time = 10} or \code{mag.time = 100}, depending on the lenght of sound window. By default: \code{mag.time = 1} (i.e. no magnification is performed)
#' @param EQ only applies when \code{analysis.type = "twoDshape"} and \code{add.points = TRUE}. A vector of energy quantiles intended (with \code{0 < EQ < 1}). By default: \code{EQ = c(0.05, 0.15, 0.3, 0.5, 0.7, 0.85, 0.95)} \strong{Note:} When dealing with narrow banded calls, consider reducing the number of quantiles to prevent errors in the analysis.
#' @param x.length only applies when \code{analysis.type = "threeDshape"}. Length of sequence (i.e. number of cells per side on sound window) to be used as sampling grid coordinates on the time (X-axis).  By default: \code{x.length = 100}
#' @param y.length only applies when \code{analysis.type = "threeDshape"}. Length of sequence (i.e. number of cells per side on sound window) to be used as sampling grid coordinates on the frequency (Y-axis). By default: \code{y.length = 70}
#' @param log.scale only applies when \code{analysis.type = "threeDshape"}. A logical. If \code{TRUE}, \code{eigensound} will use a logarithmic scale on the time (X-axis), which is recommeded when the analyzed sounds present great variation on this axis (e.g. emphasize short duration sounds). If \code{FALSE}, a linear scale is used instead (same as MacLeod et al., 2013). By default: \code{log.scale = TRUE}
#' @param plot.exp a logical. If \code{TRUE}, for each \code{wave} file on the folder indicated by \code{wav.at}, \code{eigensound} will store a spectrogram image on the folder indicated by \code{store.at}. Depending on the \code{analysis.type}, plots may consist of two or three-dimensional spectrogram images. By default: \code{plot.exp = TRUE}
#' @param plot.type only applies when \code{analysis.type = "threeDshape"} and  \code{plot.exp = TRUE}. \code{plot.type = "surface"} will produce a simplified three-dimensional sound surface from the calculated semilandmarks (same output employed by MacLeod et al., 2013); \code{plot.type = "points"} will produce three-dimensional graphs with semilandmarks as points. By default: \code{plot.type = "surface"}
#' @param plot.as only applies when \code{plot.exp = TRUE}. \code{plot.as = "jpeg"} will generate compressed images for quick inspection of semilandmarks; \code{plot.as = "tiff"} or \code{"tif"} will generate uncompressed high resolution images that can be edited and used for publication. By default: \code{plot.as = "jpeg"}
#' @param add.contour only applies when \code{analysis.type = "twoDshape"} and  \code{plot.exp = TRUE}. A logical. If \code{TRUE}, exported spectrogram plots will include the longest curve of relative amplitude at the level specified by \code{dBlevel}. By default: \code{add.contour = TRUE}
#' @param add.points only applies when \code{analysis.type = "twoDshape"}. A logical. If \code{TRUE}, \code{eigensound} will compute semilandmarks acquired by cross-correlation between energy quantiles (i.e. \code{EQ}) and a curve of relative amplitude (i.e. \code{dBlevel}). If \code{plot.exp = TRUE}, semilandmarks will be included in spectrogram plots. By default: \code{add.points = FALSE} (see \strong{Details})
#' @param TPS.file Desired name for the \code{tps} file containing semilandmark coordinates. Should be presented between quotation marks. \strong{Note:} Whenever \code{analysis.type = "twoDshape"}, it will only work if \code{add.points = TRUE}. By default: \code{TPS.file = NULL} (i.e. prevents \code{eigensound} from creating a \code{tps} file)
#' 
#' @details 
#' When \code{analysis.type = "twoDshape"} and \code{add.points = TRUE}, \code{eigensound} will compute semilandmarks acquired by cross-correlation between energy quantiles (i.e. \code{EQ}) and a curve of relative amplitude (i.e. \code{dBlevel}). However, this is often subtle and prone to incur in errors (e.g. bad alignment of acoustic units; inappropriate X and Y coordinates for the sound window; narrow banded calls). Therefore, a more robust protocol of error verification is achieved using \code{add.points = FALSE} and \code{add.contour = TRUE} (default), which allow for quick verification of acoustic units alignment and the shape of each curve of relative amplitude (specified by \code{dBlevel}). 
#' 
#' @note 
#' In order to store the results from \code{eigensound} function and proceed with the Geometric Morphometric steps of the analysis (e.g. \code{\link{geomorph}} package; Adams et al., 2017), one can simultaneosly assign the function's output to an \code{R} object and/or store them as a \code{tps} file to be used by numerous softwares of geometric analysis of shape, such as the TPS series (Rohlf, 2015).
#' 
#' Additionally, one might also export two or three-dimensional plots as \code{jpeg} (compressed image) or \code{tiff} (uncompressed image) file formats, which can be edited for publication purposes.
#' 
#' 
#' @author 
#' Pedro Rocha
#' 
#' @references 
#' Adams, D. C., M. L. Collyer, A. Kaliontzopoulou & Sherratt, E. (2017) \emph{Geomorph: Software for geometric morphometric analyses}. R package version 3.0.5. https://cran.r-project.org/package=geomorph.
#' 
#' MacLeod, N., Krieger, J. & Jones, K. E. (2013). Geometric morphometric approaches to acoustic signal analysis in mammalian biology. \emph{Hystrix, the Italian Journal of Mammalogy, 24}(1), 110-125.
#' 
#' Rocha, P. & Romano, P. (\emph{in prep}) The shape of sound: A new \code{R} package that crosses the bridge between Geometric Morphometrics and Bioacoustics. \emph{Methods in Ecology and Evolution}.
#' 
#' Rohlf, F.J. (2015) The tps series of software. \emph{Hystrix 26}, 9-12. 
#' 
#' @seealso 
#' \code{\link{twoDshape}}, \code{\link{threeDshape}}, \code{\link{align.wave}}, \code{\link{geomorph}}, \code{\link{seewave}}
#' 
#' @examples 
#' library(seewave) 
#' library(tuneR)
#' 
#' # Create folder to store wave files
#' dir.create("C:/R/example eigensound")
#' 
#' # Create folder to store results
#' dir.create("C:/R/example eigensound/output")
#' 
#' # Select three acoustic units within each sound data
#' data("tico")
#' cut.tico1 <- cutw(tico, f=44100, from=0, to=0.22, output = "Wave")
#' cut.tico2 <- cutw(tico, f=44100, from=0.22, to=0.44, output = "Wave")
#' cut.tico3 <- cutw(tico, f=44100, from=0.44, to=0.66, output = "Wave")
#' 
#' data("orni")
#' cut.orni1 <- cutw(orni, f=44100, from=0, to=0.08, output = "Wave")
#' cut.orni2 <- cutw(orni, f=44100, from=0.12, to=0.22, output = "Wave")
#' cut.orni3 <- cutw(orni, f=44100, from=0.21, to=0.29, output = "Wave")
#' 
#' # Export new wave files containing acoustic units and store on previosly created folder
#' writeWave(cut.tico1, filename = "C:/R/example eigensound/cut.tico1.wav", extensible = FALSE)
#' writeWave(cut.tico2, filename = "C:/R/example eigensound/cut.tico2.wav", extensible = FALSE)
#' writeWave(cut.tico3, filename = "C:/R/example eigensound/cut.tico3.wav", extensible = FALSE)
#' writeWave(cut.orni1, filename = "C:/R/example eigensound/cut.orni1.wav", extensible = FALSE)
#' writeWave(cut.orni2, filename = "C:/R/example eigensound/cut.orni2.wav", extensible = FALSE)
#' writeWave(cut.orni3, filename = "C:/R/example eigensound/cut.orni3.wav", extensible = FALSE)
#' 
#' # Place sounds at beggining of sound window before analysis
#' align.wave(wav.at = "C:/R/example eigensound", wav.to = "Aligned", 
#'            time.length = 0.3, time.perc = 0.01, dBlevel = 25)
#'            
#' # Verify alignment using analysis.type = "twoDshape"
#' eigensound(analysis.type = "twoDshape", wav.at = "C:/R/example eigensound/Aligned", 
#'            store.at = "C:/R/example eigensound/output", flim=c(3, 18), tlim=c(0,0.22),
#'            plot.exp = TRUE, plot.as = "jpeg", dBlevel = 25)
#'            
#' # Run eigensound function using analysis.type = "threeDshape" on aligned wave files
#' # Store results as R object and tps file
#' eig.sample <- eigensound(analysis.type="threeDshape", wav.at = "C:/R/example eigensound/Aligned",
#'                  store.at = "C:/R/example eigensound/output", 
#'                  x.length = 80, y.length = 60, TPS.file = "eigensound.sample.tps", log.scale = TRUE,
#'                  flim=c(3, 18), tlim=c(0,0.22), , dBlevel = 25,
#'                  plot.exp = TRUE, plot.as = "jpeg", plot.type = "surface")
#'                          
#' # PCA using three-dimensional semilandmark coordinates
#' pca.eig.sample <- prcomp(geomorph::two.d.array(eig.sample))
#' 
#' # Create factor to use as groups in subsequent eigensound
#' sample.gr <- factor(c(rep("orni", 3), rep("tico", 3)))
#' 
#' # Plot result of Principal Components Analysis
#' pca.plot(PCA.out = pca.eig.sample, groups = sample.gr, conv.hulls = sample.gr,
#'          main="PCA of 3D coordinates", leg=TRUE, leg.pos = "bottomleft")
#' 
#' @export
#' 
eigensound <- function(analysis.type = NULL, dBlevel=25, wav.at = getwd(), store.at = getwd(), flim=c(0, 10), tlim = c(0, 1), trel=tlim, mag.time=1, x.length=100, y.length=70, log.scale=TRUE, add.points=FALSE, add.contour=TRUE, EQ= c(0.05, 0.15, 0.3, 0.5, 0.7, 0.85, 0.95), f=44100, wl=512, ovlp=70, plot.exp = TRUE, plot.as = "jpeg", plot.type = "surface", TPS.file = NULL){
  
  # Create TPS file before analysis
  if(analysis.type == "twoDshape"){
    if(!is.null(TPS.file) && add.points==FALSE)
      stop("Must set add.points = TRUE to acquire two-dimensional semilandmarks and store them on a '.tps' file") 
  }
  
  
  if(!is.null(TPS.file)){
    TPS.path <- paste(store.at, "/", TPS.file, ".tps",  sep="")
    file.create(TPS.path, showWarnings = TRUE)
  }
  
  # Define analysis type
  if(is.null(analysis.type)) {stop('Method undefined in analysis.type')}
  
  # Eigensound analysis
  if(analysis.type == "threeDshape"){
    
    # Acquire 3D semilandmark coordinates for each wave file on a given folder
    for(file in list.files(wav.at, pattern = ".wav"))
    {
      threeD <- tuneR::readWave(paste(wav.at,"/", file, sep=""))
      
      # Store spectrogram as R object
      e <-  seewave::spectro(threeD, f=f, wl=wl, ovlp=ovlp, flim=flim, tlim=tlim, plot=F)
      
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
                                         border="black", lwd=0.1, theta=30, phi=35, resfac=1, r=3,expand=0.5, cex.axis=0.7,
                                         scale=T, axes=T, col=seewave::spectro.colors(n=100), ticktype="detailed", nticks=4,            xlab="Time (s)", ylab="Frequency (kHz)", zlab="Amplitude (dB)",         
                                         main= sub(".wav", "", file), clab=expression('Amplitude dB'))}
        if(plot.type=="points"){plot3D::scatter3D(x=ind.3D[,1], y=ind.3D[,2], z=ind.3D[,3], 
                                          pch=21, cex=0.5, theta=30, phi=35, resfac=1, r=3, expand=0.5, cex.axis=0.7,
                                          scale=T, axes=T, col=seewave::spectro.colors(n=100), ticktype="detailed", nticks=4,
                                          xlab="Time (s)", ylab="Frequency (kHz)", zlab="Amplitude (dB)",  
                                          main= sub(".wav", "", file), clab=expression('Amplitude dB'))}
        
        grDevices::dev.off()  } # end threeDshape plot of each wave file
      
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
      
    } #end threeDshape loop
    
    # Assign names to arrays' third dimension
    dimnames(coord3D)[[3]] <- sub(".wav","", list.files(wav.at, pattern = ".wav"))
    
  } # End threeDshape
  
  # two-dimensional analysis
  if(analysis.type == "twoDshape"){
 
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
        
        # Power spectrum calculated within maximum and minimum frequency values, and initial and final time values within the longest contour
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
        }
        
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
        
        grDevices::dev.off()
      } # end plot
      
      # Export semilandmark coordinates as TPS file
      if(!is.null(TPS.file)){
        lmline <- paste("LM=", dim(SM)[1], sep="")
        write(lmline, TPS.path, append = TRUE)
        utils::write.table(SM[,4:3], TPS.path, col.names = FALSE, row.names = FALSE, append = TRUE)
        idline <- paste("ID=", sub(".wav", "", file), sep="")
        write(idline, TPS.path, append = TRUE)
        write("", TPS.path, append = TRUE)
        rm(lmline, idline, SM) 
      } # end tps file
      
    } # end loop
    
    # Assign names to arrays' third dimension
    if(add.points==TRUE){
      dimnames(coord2D)[[3]] <- sub(".wav","", 
                                    list.files(wav.at, pattern = ".wav"))} # end add.poins = TRUE
    
  } # End twoDshape
  
 
  if(analysis.type == "twoDshape" && add.points == TRUE){ coord <- coord2D }
    else( coord <- NULL )# twoDshape results 
  if(analysis.type == "threeDshape"){ coord <- coord3D } # threeDshape results
  
  results <- coord
  
} # End eigensound function
