###load_postgis

## NB passwords in plaintext on git are a liability (even if DBs are local)

rm(list=ls())

library(rpostgis)

# con  <-  dbConnect("PostgreSQL",
#                    dbname = 'api2',
#                    host   = 'localhost',
#                    user   = 'pgisuser',
#                    password = 'apismal2019')

con  <-  dbConnect("PostgreSQL",
                   dbname = 'apismal',
                   host   = 'localhost',
                   user   = 'pgisuser',
                   password = 'apismal2019')

con  <-  dbConnect("PostgreSQL",
                   dbname = 'apismal',
                   host   = 'localhost',
                   user   = 'postgres',
                   password = 'postgres')


con  <-  dbConnect("PostgreSQL",
                   dbname = 'postgres',
                   host   = 'localhost',
                   user   = 'postgres',
                   password = 'postgres')



pgPostGIS(con)
#PostGIS extension version 2.5.1 installed.
#[1] TRUE

###load by department

rdaCultFiles <- list.files(path = "C:/opt/donnees_R/RPG/V2", pattern = "ilotsCult*")
rdaIlotFiles <- list.files(path = "C:/opt/donnees_R/RPG/V2", pattern = "ilots_20*")
rm(rdaIlotFiles)

rdaCultFiles <- list.files(path = "C:/opt/donnees_R/RPG/V2", pattern = "ilotsCult*")
rdaIlotFiles <- list.files(path = "C:/opt/donnees_R/RPG/V2", pattern = "ilots_20*")

#load Picardie (002, 060, 080)
load("C:/opt/donnees_R/RPG/V2/ilotsCult_2008_002.rda")
load("C:/opt/donnees_R/RPG/V2/ilotsCult_2008_060.rda")
load("C:/opt/donnees_R/RPG/V2/ilotsCult_2008_080.rda")
load("C:/opt/donnees_R/RPG/V2/ilots_2008_002.rda")
load("C:/opt/donnees_R/RPG/V2/ilots_2008_060.rda")
load("C:/opt/donnees_R/RPG/V2/ilots_2008_080.rda")

#load Bourgogne (reg 26) (Departments 21 58 71 89)
load("C:/opt/donnees_R/RPG/V2/ilotsCult_2008_021.rda")
load("C:/opt/donnees_R/RPG/V2/ilotsCult_2008_058.rda")
load("C:/opt/donnees_R/RPG/V2/ilotsCult_2008_071.rda")
load("C:/opt/donnees_R/RPG/V2/ilotsCult_2008_089.rda")
load("C:/opt/donnees_R/RPG/V2/ilots_2008_021.rda")
load("C:/opt/donnees_R/RPG/V2/ilots_2008_058.rda")
load("C:/opt/donnees_R/RPG/V2/ilots_2008_071.rda")
load("C:/opt/donnees_R/RPG/V2/ilots_2008_089.rda")

#load Midi-Pyrenees (reg 73) (Department 09, 12, 31, 32, 46, 65, 81, 82)
load("C:/opt/donnees_R/RPG/V2/ilotsCult_2008_009.rda")
load("C:/opt/donnees_R/RPG/V2/ilotsCult_2008_012.rda")
load("C:/opt/donnees_R/RPG/V2/ilotsCult_2008_031.rda")
load("C:/opt/donnees_R/RPG/V2/ilotsCult_2008_046.rda")
load("C:/opt/donnees_R/RPG/V2/ilotsCult_2008_065.rda")
load("C:/opt/donnees_R/RPG/V2/ilotsCult_2008_081.rda")
load("C:/opt/donnees_R/RPG/V2/ilotsCult_2008_082.rda")
load("C:/opt/donnees_R/RPG/V2/ilots_2008_009.rda")
load("C:/opt/donnees_R/RPG/V2/ilots_2008_012.rda")
load("C:/opt/donnees_R/RPG/V2/ilots_2008_031.rda")
load("C:/opt/donnees_R/RPG/V2/ilots_2008_046.rda")
load("C:/opt/donnees_R/RPG/V2/ilots_2008_065.rda")
load("C:/opt/donnees_R/RPG/V2/ilots_2008_081.rda")
load("C:/opt/donnees_R/RPG/V2/ilots_2008_082.rda")


#load Rhone-Alpes (reg 82) (Department, 01, 07, 26, 38, 42, 69, 73, 74)
load("C:/opt/donnees_R/RPG/V2/ilotsCult_2008_001.rda")
load("C:/opt/donnees_R/RPG/V2/ilotsCult_2008_007.rda")
load("C:/opt/donnees_R/RPG/V2/ilotsCult_2008_026.rda")
load("C:/opt/donnees_R/RPG/V2/ilotsCult_2008_038.rda")
load("C:/opt/donnees_R/RPG/V2/ilotsCult_2008_042.rda")
load("C:/opt/donnees_R/RPG/V2/ilotsCult_2008_069.rda")
load("C:/opt/donnees_R/RPG/V2/ilotsCult_2008_073.rda")
load("C:/opt/donnees_R/RPG/V2/ilotsCult_2008_074.rda")
load("C:/opt/donnees_R/RPG/V2/ilots_2008_001.rda")
load("C:/opt/donnees_R/RPG/V2/ilots_2008_007.rda")
load("C:/opt/donnees_R/RPG/V2/ilots_2008_026.rda")
load("C:/opt/donnees_R/RPG/V2/ilots_2008_038.rda")
load("C:/opt/donnees_R/RPG/V2/ilots_2008_042.rda")
load("C:/opt/donnees_R/RPG/V2/ilots_2008_069.rda")
load("C:/opt/donnees_R/RPG/V2/ilots_2008_073.rda")
load("C:/opt/donnees_R/RPG/V2/ilots_2008_074.rda")


1. convert PRA file to EPSG=32631 (EPSG:32631 - WGS 84 / UTM zone 31N - Projeté)
1. BETTER, convert all incoming to 3035

# CONVERSION COORDS
ilots3035_2008_002 <- spTransform(ilots_2008_002, "+init=epsg:3035")
plot(ilots3035_2008_002)

class(pras)
sf_pras <- st_as_sf(
  pras,
  coord = c('x', 'y'),
  crs="+init=epsg:3035"
)

class(ilots_2008_002)
str(ilots_2008_002@proj4string)


sf_2008_008 <- st_as_sf(
  ilots_2008_021,
  coord = c('x', 'y'),
  crs="+init=epsg:32631"
)
class(ilots_2008_021)
class(sf_2008_021)
plot(sf_2008_021)
sf_2008_021_3035 <-  st_transform(sf_2008_021, 3035)  
plot(sf_2008_021_3035)
class(sf_2008_021_3035)


class(ilots_2008_002)

library(rpostgis)
pgInsert(con, 
         c("public","ilots"), 
         ilots_2008_002, 
         geom = "geom", 
         df.mode = FALSE,
         partial.match = FALSE, 
         overwrite = FALSE, 
         new.id = NULL,
         row.names = FALSE, 
         upsert.using = NULL, 
         alter.names = FALSE,
         encoding = NULL, 
         return.pgi = FALSE, 
         df.geom = NULL,
         geog = FALSE)

#  RS-DBI driver: (could not Retrieve the result : ERREUR:  Geometry SRID (3035) does not match column SRID (32631)
pgInsert(con, 
         c("public","ilots"), 
         ilots3035_2008_002, 
         geom = "geom", 
         df.mode = FALSE,
         partial.match = FALSE, 
         overwrite = FALSE, 
         new.id = NULL,
         row.names = FALSE, 
         upsert.using = NULL, 
         alter.names = FALSE,
         encoding = NULL, 
         return.pgi = FALSE, 
         df.geom = NULL,
         geog = FALSE)



pgInsert(con, 
         c("basemap","pra"), 
         sf_pras, 
         geom = "geom", 
         df.mode = FALSE,
         partial.match = FALSE, 
         overwrite = FALSE, 
         new.id = NULL,
         row.names = FALSE, 
         upsert.using = NULL, 
         alter.names = FALSE,
         encoding = NULL, 
         return.pgi = FALSE, 
         df.geom = NULL,
         geog = FALSE)


# R -> PostGIS
## NOPESAUCE
#defaults: pgPostGIS(con, topology = FALSE, tiger = FALSE, sfcgal = FALSE,display = TRUE, exec = TRUE)
pgPostGIS(con, topology = TRUE, tiger = TRUE, sfcgal = TRUE,display = TRUE, exec = TRUE)
#dbWriteDataFrame(conn, name, df, overwrite = FALSE, only.defs = FALSE)
dbWriteDataFrame(con, "ilots", ilots_2008_060, overwrite = FALSE, only.defs = FALSE)
#wups - RTFM: All Spatial*DataFrames must be written with pgInsert. For more flexible writing of data.frames to the database (including all writing into existing database tables), use pgInsert with df.mode = FALSE.
# pgInsert(conn, name, data.obj, geom = "geom", df.mode = FALSE,
#   partial.match = FALSE, overwrite = FALSE, new.id = NULL,
#   row.names = FALSE, upsert.using = NULL, alter.names = FALSE,
#   encoding = NULL, return.pgi = FALSE, df.geom = NULL,
#   geog = FALSE)
pgPostGIS(con)

#loading depts 60 and 80
length(ilots_2008_060$ID_ILOT) + length(ilots_2008_080$ID_ILOT) # 147100

summary(ilots_2008_002)
str(ilots_2008_002)

class(ilotsCult_2008_021$ID_ILOT) #no problem
class(ilots_2008_021$ID_ILOT) #problem

#### important step !!! ####

# 3. BEFORE LOAD - convert ID_ILOT to num from str
ilots_2008_002$ID_ILOT <- as.numeric(ilots_2008_002$ID_ILOT)
ilots_2008_060$ID_ILOT <- as.numeric(ilots_2008_060$ID_ILOT)
ilots_2008_080$ID_ILOT <- as.numeric(ilots_2008_080$ID_ILOT)

ilots_2008_001$ID_ILOT <- as.numeric(ilots_2008_001$ID_ILOT)
ilots_2008_007$ID_ILOT <- as.numeric(ilots_2008_007$ID_ILOT)
ilots_2008_021$ID_ILOT <- as.numeric(ilots_2008_021$ID_ILOT)
ilots_2008_026$ID_ILOT <- as.numeric(ilots_2008_026$ID_ILOT)
ilots_2008_038$ID_ILOT <- as.numeric(ilots_2008_038$ID_ILOT)
ilots_2008_042$ID_ILOT <- as.numeric(ilots_2008_042$ID_ILOT)
ilots_2008_058$ID_ILOT <- as.numeric(ilots_2008_058$ID_ILOT)
ilots_2008_069$ID_ILOT <- as.numeric(ilots_2008_069$ID_ILOT)
ilots_2008_071$ID_ILOT <- as.numeric(ilots_2008_071$ID_ILOT)
ilots_2008_073$ID_ILOT <- as.numeric(ilots_2008_073$ID_ILOT)
ilots_2008_074$ID_ILOT <- as.numeric(ilots_2008_074$ID_ILOT)
ilots_2008_089$ID_ILOT <- as.numeric(ilots_2008_089$ID_ILOT)


class(ilots_2008_089$ID_ILOT) #no more problem!!

## 4. CONVERT COORDINATES
# can do this later within postgis (and faster)

library(rpostgis)
pgInsert(con, 
         c("public","ilots"), 
         ilots_2008_071, 
         geom = "geom", 
         df.mode = FALSE,
         partial.match = FALSE, 
         overwrite = FALSE, 
         new.id = NULL,
         row.names = FALSE, 
         upsert.using = NULL, 
         alter.names = FALSE,
         encoding = NULL, 
         return.pgi = FALSE, 
         df.geom = NULL,
         geog = FALSE)

# SELECT count('ID_ILOT') FROM public.ilots2 = "147100" wohoo

all three forming Picardie: "207628"
length(ilots_2008_060$ID_ILOT) + length(ilots_2008_080$ID_ILOT) + length(ilots_2008_002$ID_ILOT)

ilotsCult_2008_002, ilotsCult_2008_060, ilotsCult_2008_080
summary(ilotsCult_2008_002)
head(ilotsCult_2008_002)

summary(ilotsCult_2008_002)


pgInsert(con, 
         c("public","culture"), 
         ilotsCult_2008_080, 
         geom = FALSE, 
         df.mode = FALSE,
         partial.match = FALSE, 
         overwrite = FALSE, 
         new.id = NULL,
         row.names = FALSE, 
         upsert.using = NULL, 
         alter.names = FALSE,
         encoding = NULL, 
         return.pgi = FALSE, 
         df.geom = NULL,
         geog = FALSE)


# PostGIS -> R


