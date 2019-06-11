# Welcome to *SoundShape* <img src="man/figures/SoundShape logo.png" align="right" height = 210/>

Here you will find informations on how to decompose sound waves onto Principal Components, which include tools extracted from Bioacoustics (*i.e.* `tuneR` and `seewave` packages) and from Geometric Morphometrics (*i.e.* `geomorph` package). 

## Getting started

Be aware that this is still an early version of `SoundShape`. Therefore, some errors are still likely to appear in a near future. Feel free to provide feedback or report any [issues here](https://github.com/p-rocha/SoundShape/issues).

### Instalation
```r
# Development version from GitHub:

# install.packages("devtools")
devtools::install_github("p-rocha/SoundShape")
```

## Crossing the bridge between Bioacoustics and Geometric Morphometrics

Geometric Morphometrics (GM) applied to bioacoustical analysis is a new approach aimed for the direct comparison between calls of different species. The method described by MacLeod et al. (2013) considers the graphical representation of sound (*i.e.* a spectrogram) as complex three-dimensional surfaces from which topologically homologous semilandmarks (SM) are acquired. The three-dimensional SM coordinates can be submitted to Principal Components Analysis, which will calculate new variables (Principal Components – PC) that are independent from each other and represent the axis of greatest
variation in the dataset of sound waves. By doing so, complex waves are now be described by a few PCs that can be used to produce ordination plots encompassing the majority of variation among the calls.

Although MacLeod et al. (2013) clearly stated the methods for SM acquisition, they did not mention the softwares required for the so called *eigensound analysis*. Therefore, `SoundShape` package feature a set of functions that reproduce the methods from the positioning of sounds at beggining of sound window until the PCA plot with convex hulls around each group. 


## References
MacLeod, N., Krieger, J. & Jones, K. E. (2013). Geometric morphometric approaches to acoustic signal analysis in mammalian biology. *Hystrix, the Italian Journal of Mammalogy, 24*(1), 110-125.

Rocha, P. & Romano, P. (*in prep*) The shape of sound: A new `R` package that crosses the bridge between Bioacoustics and Geometric Morphometrics.

