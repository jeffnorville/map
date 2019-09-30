# working directory
wd <- list()
# commonly used paths in my working directory
wd$data   <- "C:/Users/Jeff Norville/Documents/R/map/data/"
wd$output <- "C:/Users/Jeff Norville/Documents/R/map/output/"

# rm(list=ls())

require(sp)
require(rpostgis)
require(stringr)
require(wkb)


# database
#nb - rstudio picks up from .renviron file at launch of program - variable cannot be redefined w/o relaunch (or at least reload) of .renviron file
#point of this is to keep passwords, etc, unique to local instance of program (and off of source control evidently)
gethost     <- Sys.getenv("dbhost")
getdbname <- Sys.getenv("dbname")
getusername <- Sys.getenv("user")
getpassword <- Sys.getenv("passwd")
con  <-  dbConnect("PostgreSQL",
                   dbname = getdbname,
                   host   = gethost,
                   user   = getusername,
                   password = getpassword)
# isPostgresqlIdCurrent(con) #boolean, checks if postgres instance is alive
# pgPostGIS(con) #check that postgis is installed in db


# sept 2019 cleaning up for final repo
# sourcedata = "C:/opt/donnees_R/RPG/V2/"
sourcedata = "/opt/donnees_R/RPG/V2/"# vega


# scenarios de ref
list_Picardie <- c(2, 60, 80)
list_Bourgogne <- c(21, 58, 71, 89)
list_MidiPyrenees <- c(09, 12, 31, 32, 46, 65, 81, 82)
list_RhoneAlpes <-  c(1, 7, 26, 38, 42, 69, 73, 74)

# restof
list_Alsace <- c(67, 68)
list_Aquitaine <- c(24, 33, 40, 47, 67)
list_Auvergne <- c(3, 15, 43, 63)
list_BasseNormandie <- c(14, 50, 61)
list_Bourgogne <- c(21, 58, 71, 89)
list_Bretagne <- c(22, 29, 35, 56)
list_Centre <- c(18, 28, 36, 37, 41, 45)
list_ChampagneArdenne <- c(8, 10, 51, 52)
list_Corse <- c('2A', '2B')
list_FrancheComte <- c(25, 39, 70, 90)
list_HauteNormandie <- c(27, 76)
list_IleDeFrance <- c(75, 77, 78, 91, 92, 93, 94, 95)
list_LanguedocRoussillon <- c(11, 30, 34, 48, 66)
list_Limousin <- c(19, 23, 87)
list_Lorraine <- c(54, 55, 57, 88)
list_MidiPyrenees <- c(9, 12, 31, 32,46, 65, 81, 82)
list_NordPasDeCalais <-  c(59, 62)
list_PaysDeLaLoire <-  c(44, 49, 53, 72, 85)
list_Picardie <-  c(2, 60, 80)
list_PoitouCharentes <- c(16, 17, 79, 86)
list_ProvenceAlpesCoteDAzur <-  c(4, 5, 6, 13, 83, 84)
list_All <- c(seq(1:95))


##########################################
### autoloads
##########################################
# schema <- "test" # dev, QA
schema <- "load" # was public

for (dept in list_Picardie){
  #GEOMetry first
  # dept <- '02'
  ilots_to_add <- paste0("ilots_2008_", str_pad(dept, 3, side="left", pad = "0"), ".rda", sep="")
  ilot <- load(paste0(sourcedata, ilots_to_add))
  ilot <- get(ilot)
  ilot$ID_ILOT <- as.numeric(ilot$ID_ILOT)      # make keys match better in DB
  ilot <- spTransform(ilot, "+init=epsg:3035")  # reproject
  ilot$sourcefile <- ilots_to_add               # add filename
  ilot$timestamp <- as.POSIXct(Sys.time())      # add timestamp

  # plot(ilot)  
  # summary(ilot)
# lookup pgInsertizeGeom  
  # https://www.rdocumentation.org/packages/rpostgis/versions/1.4.2/topics/pgInsertizeGeom
  # pgilistobj <- pgInsertizeGeom(con,
  #   c(schema, "ilots"),
  #   ilot,
  #   geom = "geom", 
  #   df.mode = FALSE,
  #   partial.match = FALSE, 
  #   overwrite = FALSE, 
  #   new.id = NULL,
  #   row.names = FALSE, 
  #   upsert.using = NULL, 
  #   alter.names = FALSE,
  #   encoding = NULL, 
  #   return.pgi = FALSE, 
  #   df.geom = NULL,
  #   geog = FALSE  
  #   )
  # ... then we'd insert the pgi object?"
  
  retilot <- pgInsert(con,                                 # load to DB
           c(schema,"ilots"), 
           ilot,
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
  
    # culture
  cultures_to_add <- paste("ilotsCult_2008_", str_pad(dept, 3, side="left", pad = "0"), ".rda", sep="")
  culture <- load(paste0(sourcedata, cultures_to_add))
  thiscult <- get(culture)
  thiscult$sourcefile <- cultures_to_add            #add filename
  thiscult$timestamp <- as.POSIXct(Sys.time())      # add timestamp
  
  retcult <-  pgInsert(con, 
           c(schema, "culture"), 
           thiscult,
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

if (retilot && retcult == TRUE){
  print(paste("files loaded: ", paste(ilots_to_add, cultures_to_add)))
}  
else {
  print(paste("file err, something was not loaded: ", paste(ilots_to_add, cultures_to_add)))  
  }
}


