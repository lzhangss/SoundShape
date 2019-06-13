<img align="right" height="300" width="300" src="figures/logo.png" />

# Welcome to *SoundShape*!
Here, you will find informations on a promising, yet little explored method for biacoustical analysis: the *eigensound* protocol ([MacLeod *et al.*, 2013](http://www.italian-journal-of-mammalogy.it/Geometric-Morphometric-Approaches-to-Acoustic-Signal-Analysis-in-Mammalian-Biology,77249,0,2.html)). 

*Eigensound* is a multidisciplinary approach that crosses the bridge between Bioacoustics and Geometric Morphometrics, thus enabling the direct comparison between stereotyped calls from different species. Although well described by Macleod *et al.*, the method still lacked a viable platform to run the analysis, meaning that the bridge was still not *crossable* for those unfamiliar with programming codes.

`SoundShape` was built to fill this gap. It feature functions that enable anyone to easily go from sound waves to Principal Components, using tools extracted from traditional Bioacoustics (*i.e.* [tuneR](https://cran.r-project.org/web/packages/tuneR/index.html) and [seewave](http://rug.mnhn.fr/seewave/) packages), Geometric Morphometrics (*i.e.* [geomorph](https://cran.r-project.org/web/packages/geomorph/index.html) package) and multivariate analysis (*e.g.* [stats](https://stat.ethz.ch/R-manual/R-devel/library/stats/html/00Index.html) package). In addition to the original description (MacLeod *et al.,* 2013), we are currently developing a throughout paper detailing `SoundShape` (Rocha & Romano *in prep*).

*Thanks for using* `SoundShape` *and enjoy your reading!* 

**Note:** This is still an early version of `SoundShape`. Should you experience problems running any function, please feel free to report any [issues here](https://github.com/p-rocha/SoundShape/issues).

# Getting started


## Instalation
`SoundShape` is available on [R platform](https://www.r-project.org/) as a development version from GitHub. In order to download it, make sure to have already installed an updated `R` version (>=3.3.1) and [devtools](https://www.rstudio.com/products/rpackages/devtools) package. 

```r
# devtools - In case you don't have it
install.packages("devtools")

# SoundShape - Install the development version from GitHub
devtools::install_github("p-rocha/SoundShape")
```

## Workflow using `SoundShape`
The method described by MacLeod *et al.* (2013) considers the graphical representation of sound (*i.e.* a spectrogram) as complex three-dimensional (3D) surfaces from which topologically homologous semilandmarks (SM) can be acquired using a predefined sampling grid.

`threeDspectro` provide an easy way to visualize sound waves as 3D graphs with or without a sampling grid, and also to view the sampled 3D SM as colored points.

<p align="center">
  <img height="180" width="827" src="figures/spectros.jpg" />
</p>

#### Codes for the images:
```r
# Sample data from SoundShape
data(cuvieri)

# Select stereotyped acoustic unit from sample
cuvieri.cut <- seewave::cutw(cuvieri, f=44100, from = 0.05, to=0.45, output="Wave")

# a. Oscillogram
seewave::oscillo(cuvieri.cut)

# b. 2D spectrogram
seewave::spectro(cuvieri.cut, flim=c(0, 2.5), grid=FALSE, scale=FALSE)

# c. 3D spectrogram
threeDspectro(cuvieri.cut, flim=c(0, 2.5), rotate.Xaxis=60, rotate.Yaxis=40)

# d. 3D spectrogram - sampled surface
threeDspectro(cuvieri.cut, samp.grid=TRUE, x.length=70, y.length=50,
              flim=c(0, 2.5), rotate.Xaxis=60, rotate.Yaxis=40)

# e. 3D spectrogram - semilandmarks from sampled surface
threeDspectro(cuvieri.cut, samp.grid=TRUE, x.length=70, y.length=50, plot.type="points",
              flim=c(0, 2.5), rotate.Xaxis=60, rotate.Yaxis=40)
```

The `eigensound` function, on the other hand, focus on the acquisition of SM coordinates from multiple `".wav"` files, which must be stored on the same folder. This folder can be created at the current [working directory](http://rprogramming.net/set-working-directory-in-r/) using `dir.create`. We also create a subfolder to store the upcoming outputs from `eigensound`.

```r
# Create folder to store ".wav" files
wav.at <- file.path(getwd(), "example SoundShape")
dir.create(wav.at)

# Create subfolder to store results
store.at <- file.path(getwd(), "example SoundShape/output")
dir.create(store.at)
```

### Stereotyped acoustic units as separate `".wav"` files
Unlike most traditional protocols of bioacoustical analysis (*e.g.* Köhler *et al.,* 2017), *eigensound* is centered around stereotyped (*i.e.* homologous) acoustic units. Therefore, the first and foremost step in sound shape study is the careful definition of units from which analysis will be conducted. Although there is no universal concept of a homologous unit of biological sound encompassing the majority of calling organisms, each higher taxon has its own approaches for homologous sound comparison (Rocha & Romano *in prep*).

Once the stereotyped units have been defined, a reasonable number of units should be selected from the sample and stored as new `".wav"` file. Each `".wav"` file should represent a single acoustic unit selected from the original sound wave. 

In the `cuvieri` sample, for instance, there are three stereotyped calls of *Physalaemus cuvieri* (Amphibia, Anura, Leptodactylidae) emitted in a sequence, each constituting a comparable acoustic unit.

<img height="250" width="752" src="figures/Acoustic units - cuvieri.jpg" />

#### Codes for the image:
```r
# Sample data from SoundShape
data(cuvieri)

# Plot spectro from sample and highlight acoustic units
seewave::spectro(cuvieri, flim = c(0,2.5))
graphics::abline(v=c(0.05, 0.45, 0.73, 1.13, 1.47, 1.87), lty=2)
```

Once the acoustic units have been defined, the selection can be performed on numerous softwares of acoustic analysis outside `R` platform (*e.g.* [Audacity](https://www.audacityteam.org/), [Raven Pro](http://ravensoundsoftware.com/software/raven-pro/)). 

Or, we can use some functions from [seewave](http://rug.mnhn.fr/seewave/):

```r
# Select acoustic units
cut.cuv1 <- seewave::cutw(cuvieri, f=44100, from=0.05, to=0.45, output = "Wave")
cut.cuv2 <- seewave::cutw(cuvieri, f=44100, from=0.73, to=1.13, output = "Wave")
cut.cuv3 <- seewave::cutw(cuvieri, f=44100, from=1.47, to=1.87, output = "Wave")

# Export new ".wav" files containing acoustic units; store on previosly created folder
seewave::writeWave(cut.cuv1, filename=file.path(wav.at, "cut.cuv1.wav"), extensible=FALSE)
seewave::writeWave(cut.cuv2, filename=file.path(wav.at, "cut.cuv2.wav"), extensible=FALSE)
seewave::writeWave(cut.cuv3, filename=file.path(wav.at, "cut.cuv3.wav"), extensible=FALSE)
```

In addition to the calls of `cuvieri`, we also acquire stereotyped units from `centralis` and `kroyeri` samples (*Physalaemus centralis* and *P. kroyeri*, respectively).

<img height="450" width="746" src="figures/Acoustic units - centralis kroyeri.jpg" />

In order to select the acoustic units from `centralis` and `kroyeri`, we adapted the same codes displayed above and stored the new `".wav"` files on the same folder specified by `wav.at`. Codes were omitted for practical reasons.

In the end, our sample data is composed of nine acoustic units, three per species.

**Note:** We recommend at least five acoustic units per species when dealing with real data. In addition, selection should also account for optimal signal to noise ratio, and no overlapping frequencies from background noise. 

### Alignment of units at beggining of sound window

Although our sample of `".wav"` files is now stored on a single folder from which `eigensound` can proceed with semilandmark acquisition, the *eigensound* protocol still require a few actions before proceeding.

First is the definition of a relative value of amplitude (`dBlevel`) to use as background in the 3D spectrogram. This an iterative process that lead to minimum influence from background noise. However, this does not eliminate the variance given by
different placement of sounds within the sound window of a spectrogram - nor changes in the dimensions of the window itself. 

Therefore, sound window dimensions (*i.e.* `tlim` and `flim`) must be defined prior to running `eigensound`, and each call from our sample of `".wav"` files must be set to begin at the beggining of the sound window . This ensures that variation in each semilandmark is due to energy shifts within the call, and not to changes in their position within the sound window - or in the window itself.

Alignment is easily performed with `align.wave` function. It considers the `time.lenght` that encompasses all sounds in the study, and the relative amplitude value (`dBlevel`) as reference for call placement:

```r
# Place sounds at beggining of sound window before analysis
align.wave(wav.at = wav.at, wav.to = "Aligned", time.length = 0.8, dBlevel = 25)
```

In order to verify the alignment, we run `eigensound` with `analysis.type="twoDshape"` and `plot.exp=TRUE`. This will export two-dimensional spectrogram images for each `".wav"` file on the folder indicated by `wav.at` and store on the folder indicated by `store.at`. Recommended as a useful protocol for error verification.

```r
# Verify alignment using analysis.type = "twoDshape"
eigensound(analysis.type = "twoDshape", wav.at = file.path(wav.at, "Aligned"),
           store.at = store.at, flim=c(0, 4), tlim=c(0, 0.7), 
           plot.exp = TRUE, plot.as = "jpeg", dBlevel = 25)
```

<img height="450" src="figures/Acoustic units - centralis kroyeri.jpg" />


 so that `eigensound` can compute spectrogram data and acquire semilandmarks that can be within the sample of species. 
For each `".wav"` file on a given folder, `eigensound` will compute spectrogram data and acquire SM using a three-dimensional representation of sound (`analysis.type = "threeDshape"`), or the cross-correlation between energy quantiles and a curve of relative amplitude (`analysis.type = "twoDshape"`). The results can be simultaneosly assigned to an `R` object, and/or stored as a `".tps"` file to be used by numerous softwares of geometric analysis of shape, such as the TPS series ([Rohlf, 2015](http://www.italian-journal-of-mammalogy.it/The-tps-series-of-software,77186,0,2.html)).

(whose path can be specified by `store.at`)

SM can be acquired using a 3D representation of sound (`analysis.type = "threeDshape"`), or the cross-correlation between energy quantiles and a curve of relative amplitude (`analysis.type = "twoDshape"`), which will be further discussed in Rocha & Romano (*in prep*). Ultimately, one might also export two or three-dimensional plots as `jpeg` (compressed image) or `tiff` (uncompressed image) file formats, which can be edited for publication purposes.

```r


```





## Crossing the bridge between Bioacoustics and Geometric Morphometrics

The three-dimensional SM coordinates can be submitted to Principal Components Analysis, which will calculate new variables (Principal Components – PC) that are independent from each other and represent the axis of greatest
variation in the dataset of sound waves. By doing so, complex waves are now be described by a few PCs that can be used to produce ordination plots encompassing the majority of variation among the calls.

Although MacLeod et al. (2013) clearly stated the methods for SM acquisition, they did not mention the softwares required for the so called *eigensound analysis*. Therefore, `SoundShape` package feature a set of functions that reproduce the methods from the positioning of sounds at beggining of sound window until the PCA plot with convex hulls around each group. 


## References
MacLeod, N., Krieger, J. & Jones, K. E. (2013). Geometric morphometric approaches to acoustic signal analysis in mammalian biology. *Hystrix, the Italian Journal of Mammalogy, 24*(1), 110-125.

Rocha, P. & Romano, P. (*in prep*) The shape of sound: A new `R` package that crosses the bridge between Bioacoustics and Geometric Morphometrics.

Rohlf, F.J. (2015) The tps series of software. *Hystrix 26*, 9-12.
