
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

tiday()
head(tidy(df))

head(structure(df)[1])
dput(df)

geometrystuff <= structure(sars)[1]


