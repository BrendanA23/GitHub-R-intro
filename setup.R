#####



packageLoad <-function(x) {
  for (i in 1:length(x)) {
    if (!x[i] %in% installed.packages()) {
      install.packages(x[i],  dependencies = TRUE)
    }
    library(x[i], character.only = TRUE)
  }
}

# Awesome string of package names
packages <- c('tidyverse',
              'palmerpenguins',
              'sf',
              'terra',
              'rmarkdown',
              'tigris',
              'elevatr',
              'rgdal',
              'tmap')

packageLoad(packages)
