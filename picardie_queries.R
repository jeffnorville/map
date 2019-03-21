library(ggplot2)
library("sf")
library(sp)


#Department list:
#02
#60
#80

rm(list=ls())

#first load shapefiles for Departments, PRAs
deps <- st_read("C:/Users/Norville/Documents/basemap/DepartmentFR.shp") #, package="sf")
pras <- st_read("C:/Users/Norville/Documents/basemap/smallagriculturalareasshapefile/PRA_EPGS3035.shp") #, package="sf")

library(sp)
library(rgdal)
#SCR EPSG:2154 - RGF93 / Lambert-93 - Projeté
proj4string(deps) <- CRS("+init=epsg:2154") 
st_crs(deps)%>%2154
#st_crs(deps, 2154) # proj4text = "2154", valid = TRUE)
# <- st_crs("+init=epsg:2154")$epsg
st_crs(deps) = 2154





library(dplyr)
x = sfc %>% st_set_crs(2154) %>% st_transform(3857)
x


st_crs("+init=epsg:3857 +units=km")$b     # numeric
st_crs("+init=epsg:3857 +units=km")$units # character


#SCR EPSG:3035 - ETRS89 / LAEA Europe - Projeté
proj4string(pras)
st_crs(pras) = 3035



load("C:/opt/donnees_R/RPG/V2/ilotsCult_2008_002.rda")
load("C:/opt/donnees_R/RPG/V2/ilots_2008_002.rda")

load("C:/opt/donnees_R/RPG/V2/ilotsCult_2008_060.rda")
load("C:/opt/donnees_R/RPG/V2/ilotsCult_2008_080.rda")
load("C:/opt/donnees_R/RPG/V2/ilots_2008_060.rda")
load("C:/opt/donnees_R/RPG/V2/ilots_2008_080.rda")

summary(ilots_2008_002)

ilots_2008_002@proj4string


ilots_2008_002$ID_ILOT

setwd(dir = 'C:/opt/out_rpgs')
library(rgdal)
ogrDrivers()

writeOGR(ilots_2008_002, dsn = "ilots_2008_002.shp", driver="ESRI Shapefile", verbose = TRUE)
#FAILS writeOGR(ilots_2008_002, "ilots_2008_002", layer = "data", driver="PostgreSQL", verbose = TRUE)
#WORKS, doesn't contain much:
writeOGR(ilots_2008_002, "ilots_2008_002", layer = "data", driver="SQLite", verbose = TRUE)

#Works, looked the same during processing, has all polygons
writeOGR(ilots_2008_002, dsn="ilots_2008_002", layer="ilots_2008_002", driver="ESRI Shapefile", verbose = TRUE)


head(ilots_2008_002)


try(writeOGR(cities, td, "cities", driver="ESRI Shapefile"))
writeOGR(cities, td, "cities", driver="ESRI Shapefile", overwrite_layer=TRUE)




ggplot(ilots_2008_002)
ds <- na.omit(ilots_2008_002)
ggplot(ds)
summary(ds)

class(ilotsCult_2008_002$coordsAsString)

head(ilots_2008_002)
head(ilotsCult_2008_002)

plot(ilots_2008_002)
plot(ilots_2008_060)
plot(ilots_2008_080)

