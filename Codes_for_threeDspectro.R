# devtools and seewave - In case you don't have it
install.packages("devtools")
install.packages("seewave")

# SoundShape - Install the development version from GitHub
devtools::install_github("p-rocha/SoundShape")

# Sample data from SoundShape
data(cuvieri)

# Select stereotyped acoustic unit from sample
cuvieri.cut <- seewave::cutw(cuvieri, f=44100, from = 0.05, to=0.45, output="Wave")

# a) Oscillogram
seewave::oscillo(cuvieri.cut)

# b) 2D spectrogram
seewave::spectro(cuvieri.cut, flim=c(0, 2.5), grid=FALSE, scale=FALSE)

# c) 3D spectrogram
threeDspectro(cuvieri.cut, flim=c(0, 2.5))

# d) 3D spectrogram - sampled surface
threeDspectro(cuvieri.cut, flim=c(0, 2.5), samp.grid=TRUE, x.length=70, y.length=50)

# e) 3D spectrogram - semilandmarks from sampled surface
threeDspectro(cuvieri.cut, flim=c(0, 2.5), samp.grid=TRUE, x.length=70, y.length=50, plot.type="points")
