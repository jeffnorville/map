
library(rgdal)
library(ggmap)
library(ggplot2)
library(maps)
library(mapdata)
library(broom)

libs <- c("rgdal", "maptools", "gridExtra")
lapply(libs, require, character.only = TRUE)
geomdata <- readOGR(dsn = "./smallagriculturalareasshapefile", "PRA_EPGS3035")


france <- map_data("france")

ggplot() + geom_polygon(data = france, aes(x=long, y = lat, group = group)) + 
  coord_fixed(1.2)

ggplot() + geom_polygon(data = geomdata, aes(x=long, y = lat, group = group)) + 
  coord_fixed(.8)



head(geomdata)
class("france")
class(x = "geomdata")
extent(geomdata)
crs("geomdata")


# ex1 <- unlist(sars, use.names = TRUE)
# head(ex1)
# ex1[1]
# class(ex1)
# tiday()

head(tidy(df))

head(structure(df)[1])
dput(df)

geometrystuff <= structure(sars)[1]

# joining polygon data: https://gis.stackexchange.com/questions/63577/joining-polygons-in-r
#geomdata <- df$`1.1`$Geometry
#class(geomdata)
# each polygon thru df$`709.1`$Geometry
#thisworld <= ggplot(data = geomdata)
