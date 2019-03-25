library(ggplot2)
library("sf")
library(sp)

#Department list, Picardie:
#02
#60
#80

rm(list=ls())

#first load shapefiles for Departments, PRAs
library("sf")
library(dplyr)
deps <- st_read("C:/Users/Norville/Documents/basemap/DepartmentFR.shp") #, package="sf")
pras <- st_read("C:/Users/Norville/Documents/basemap/smallagriculturalareasshapefile/PRA_EPGS3035.shp") #, package="sf")
#assign coord system


st_overlaps()

deps %>% select(11) %>% head(2)



library(cartography)
pra_pencil <- getPencilLayer(pras)
plot(pra_pencil)

# add CODE_GROUPE_CULTURE to spatial dataframe

# counts
length(ilots_2008_002$ID_ILOT)
length(ilotsCult_2008_002$ID_ILOT)
length(ilots_2008_060$ID_ILOT)
length(ilotsCult_2008_060$ID_ILOT)
length(ilots_2008_080$ID_ILOT)
length(ilotsCult_2008_080$ID_ILOT)

min(ilotsCult_2008_002$ID_ILOT)
min(ilots_2008_002$ID_ILOT)

max(ilotsCult_2008_002$ID_ILOT)
max(ilots_2008_002$ID_ILOT)

###dept 02
sf_2008_002 <- st_as_sf(
  ilots_2008_002,
  coord = c('x', 'y'),
  crs = proj4string
)
or
  crs="+init=epsg:32631"

  ###dept 60
  sf_2008_060 <- st_as_sf(
    ilots_2008_060,
    coord = c('x', 'y'),
    crs="+init=epsg:32631"
  )
  
  ###dept 80
  sf_2008_080 <- st_as_sf(
    ilots_2008_080,
    coord = c('x', 'y'),
    crs="+init=epsg:32631"
  )
  
  
plot(sf_2008_002)
plot(sf_2008_060, add=TRUE)
plot(sf_2008_080, add=TRUE)

plot(pras, add=TRUE)



#matching polygon to cult, from
#https://stackoverflow.com/questions/3650636/how-to-attach-a-simple-data-frame-to-a-spatialpolygondataframe-in-r
sf_2008_002@data = data.frame(sf_2008_002@data, ilotsCult_2008_002[match(sf_2008_002@data[,ID_ILOT], ilotsCult_2008_002[,ID_ILOT]),])


add_2008_002 <- (ilotsCult_2008_002$ID_ILOT, ilotsCult_2008_002$CODE_GROUPE_CULTURE)

m_cult_ilots_2008_002 <- merge(ilotsCult_2008_002, ilots_2008_002, by="ID_ILOT")

class(m_cult_ilots_2008_002)
plot(m_cult_ilots_2008_002)

summary(m_cult_ilots_2008_002)


ggplot() +
  geom_sf(mapping = aes(colour = CODE_GROUPE_CULTURE), data = m_cult_ilots_2008_002) 

+
  coord_sf()


head(ilots_2008_002)
head(ilotsCults_2008_002)
summary(ilots_2008_002)

ggplot(ilots_2008_002)

library(sp)
library(rgdal)
#SCR EPSG:2154 - RGF93 / Lambert-93 - Projeté
#proj4string(deps) <- CRS("+init=epsg:2154") 
#st_crs(deps)%>%2154
#st_crs(deps, 2154) # proj4text = "2154", valid = TRUE)
# <- st_crs("+init=epsg:2154")$epsg
st_crs(deps) = 2154




st_crs(deps) = 2154

#converting btw coordinate systems
library(dplyr)
x = deps %>% st_set_crs(2154) %>% st_transform(3857)
x


st_crs("+init=epsg:3857 +units=km")$b     # numeric
st_crs("+init=epsg:3857 +units=km")$units # character


#SCR EPSG:3035 - ETRS89 / LAEA Europe - Projeté
proj4string(pras)

st_crs(pras) = 3035

list <- deps$NOM_DEPT


#deptPic <- deps %>% filter(NOM_DEPT=='PICARDIE')
#plot(deptPic)

regPic <- deps %>% filter(NOM_REGION=='PICARDIE')
plot(regPic)

regMid <- deps %>% filter(NOM_REGION=='MIDI-PYRENEES')
plot(regMid)

regBourg <- deps %>% filter(NOM_REGION=='BOURGOGNE')
plot(regBourg)

regRhone <- deps %>% filter(NOM_REGION=='RHONE-ALPES')
plot(regRhone)



plot(deps)
(pras[CODEPRA])

deptJura <- deps %>% filter(NOM_DEPT=='JURA')
plot(deptJura)

require(RPG)
load(system.file("extdata", "C:/opt/donnees_R/RPG/V2/ilots_2008_003.rda",package="RPG"))
load("C:/opt/donnees_R/RPG/V2/ilots_2008_003.rda",package="RPG")

load("C:/opt/donnees_R/RPG/V2/ilotsCult_2008_002.rda")
load("C:/opt/donnees_R/RPG/V2/ilots_2008_002.rda")

load("C:/opt/donnees_R/RPG/V2/ilotsCult_2008_060.rda")
load("C:/opt/donnees_R/RPG/V2/ilotsCult_2008_080.rda")
load("C:/opt/donnees_R/RPG/V2/ilots_2008_060.rda")
load("C:/opt/donnees_R/RPG/V2/ilots_2008_080.rda")


# join non-spatial attributes
cult_2008_002 <- data.frame(
  ID_ILOT = ilotsCult_2008_002$ID_ILOT,
  mydata <- runif(nrow(ilotsCult_2008_002))
)

cult_2008_002 <- data.frame(
  ID_ILOT = ilotsCult_2008_002$ID_ILOT,
  cultures <- ilotsCult_2008_002$CODE_GROUPE_CULTURE)
)


summary(cult_2008_002)

library(dplyr)
left_join(ilots_2008_002, cult_2008_002, by='ID_ILOT')

cult_2008_002 <- st_sfc(cult_2008_002)
st_join(ilots_2008_002, cult_2008_002, by='ID_ILOT')


additional_data <- data.frame(
  CNTY_ID = nc$CNTY_ID,
  my_data <- runif(nrow(nc))
)

left_join(nc, additional_data, by = 'CNTY_ID')


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
ggplot(ilots_2008_060)
ggplot(ilots_2008_080)

ds <- na.omit(ilots_2008_002)
ggplot(ds)
summary(ds)

class(ilotsCult_2008_002$coordsAsString)

head(ilots_2008_002)
head(ilotsCult_2008_002)

plot(ilots_2008_002)
plot(ilots_2008_060)
plot(ilots_2008_080)

