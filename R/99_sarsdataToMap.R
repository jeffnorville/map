# sf map from SARs4EA.mat
# http://pierreroudier.github.io/teaching/20171014-DSM-Masterclass-Hamilton/spatial-data-in-R.html

library(sp)
library(R.matlab)
#setwd("C:/Users/Norville/Documents/spatial_data/sadapt")
sars <- readMat('SARs4EA.mat', fixNames = TRUE)

# this pulls data object into dataframe
d <- sars$SARs4EA
df <- as.data.frame(d)
# df$`1.1`

mdf <- st_as_sf(
  df, 
  coords()
)

