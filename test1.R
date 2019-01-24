#from https://stackoverflow.com/questions/11671883/importing-an-array-from-matlab-into-r
library(R.matlab)
setwd("C:/Users/Norville/Documents/spatial_data/sadapt")
sars <- readMat('SARs4EA.mat')

d <- sars$SARs4EA
dgeometry <- d[[1]]
dx        <- d[[2]]
dy        <- d[[3]]
dcodepra  <- d[[4]]



class(sars) #it's a list
head(sars)
attr(sars, "Geometry")
attr(sars, "X")
attr(sars, "Q")


#table(unlist(lapply(dta, class)))

library(rgdal)
library(ggmap)
library(ggplot2)
library(maps)
library(mapdata)
library(broom)

france <- map_data("france")
ggplot() + geom_polygon(data = france, aes(x=long, y = lat, group = group)) + 
  coord_fixed(1.2)

ex1 <- unlist(sars, use.names = TRUE)

head(ex1)


ex1[1]
class(ex1)

head(tidy(sars))
head(structure(sars)[1])
dput(sars)

geometrystuff <= structure(sars)[1]


