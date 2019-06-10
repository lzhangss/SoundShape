# *Welcome to \code{SoundShape}*!


SoundShape (development version)

## Crossing the bridge between Bioacoustics and Geometric Morphometrics

Geometric Morphometrics (GM) applied to bioacoustical analysis is a new approach aimed for the direct comparison between calls of different species. The method described by MacLeod et al. (2013) considers the graphical representation of sound (*i.e.* a spectrogram) as complex three-dimensional surfaces from which topologically homologous semilandmarks (SM) are acquired. The three-dimensional SM coordinates can be submitted to Principal Components Analysis, which will calculate new variables (Principal Components – PC) that are independent from each other and represent the axis of greatest
variation in the dataset of sound waves. By doing so, complex waves are now be described by a few PCs that can be used to produce ordination plots encompassing the majority of variation among the calls.

Although MacLeod et al. (2013) clearly stated the methods for SM acquisition, they did not mention the softwares required for the so called *eigensound analysis*. Therefore, `SoundShape` package feature a set of functions that reproduce the methods from the positioning of sounds at beggining of sound window until the PCA plot with convex hulls around each group. 



## Installation
```{r installation}
# Development version from GitHub:

# install.packages("devtools")
devtools::install_github("p-rocha/SoundShape")
```



## References
McLister, J. D., Stevens, E. D., & Bogart, J. P. (1995). Comparative contractile dynamics of calling and locomotor muscles in three hylid frogs. *The Journal of Experimental Biology, 198*, 1527-1538.
