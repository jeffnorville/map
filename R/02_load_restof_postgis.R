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
require(rgeos)
require(rgdal)

# database
#nb - rstudio picks up from .renviron file at launch of program - variable cannot be redefined w/o relaunch (or at least reload) of .renviron file
#point of this is to keep passwords, etc, unique to local instance of program (and off of source control evidently)
gethost     <- Sys.getenv("dbhost")
getdbname   <- Sys.getenv("dbname")
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
sourcedata = "C:/opt/donnees_R/RPG/V2/"
# sourcedata = "/opt/donnees_R/RPG/V2/"# vega


# scenarios de ref
# list_Picardie <- c(2, 60, 80)
# list_Bourgogne <- c(21, 58, 71, 89)
# list_MidiPyrenees <- c(09, 12, 31, 32, 46, 65, 81, 82)
# list_RhoneAlpes <-  c(1, 7, 26, 38, 42, 69, 73, 74)

# restof
# list_Alsace <- c(67, 68)
# list_Aquitaine <- c(24, 33, 40, 47, 67)
# list_Auvergne <- c(3, 15, 43, 63)
# list_BasseNormandie <- c(14, 50, 61)
# list_Bourgogne <- c(21, 58, 71, 89)
# list_Bretagne <- c(22, 29, 35, 56)
# list_Centre <- c(18, 28, 36, 37, 41, 45)
# list_ChampagneArdenne <- c(8, 10, 51, 52)
# list_Corse <- c('2A', '2B')
# list_FrancheComte <- c(25, 39, 70, 90)
# list_HauteNormandie <- c(27, 76)
# list_IleDeFrance <- c(75, 77, 78, 91, 92, 93, 94, 95)
# list_LanguedocRoussillon <- c(11, 30, 34, 48, 66)
# list_Limousin <- c(19, 23, 87)
# list_Lorraine <- c(54, 55, 57, 88)
# list_MidiPyrenees <- c(9, 12, 31, 32,46, 65, 81, 82)
# list_NordPasDeCalais <-  c(59, 62)
# list_PaysDeLaLoire <-  c(44, 49, 53, 72, 85)
# list_Picardie <-  c(2, 60, 80)
# list_PoitouCharentes <- c(16, 17, 79, 86)
# list_ProvenceAlpesCoteDAzur <-  c(4, 5, 6, 13, 83, 84)
# list_All <- c(seq(28,95)) #got to 20 and broke , then broke on 27 (test, tes2??)
list_All <- c(seq(78,95)) #at 3:24 in the morning stopped at 59...
# [1] "files loaded:  ilots_2008_074.rda ilotsCult_2008_074.rda"
# Error in x@polygons[[1]] : subscript out of bounds
# ... because ilots_2008_075.rda has zero records
# ilots_2008_076.rda 2 column(s) in data frame are missing in database table (Centre_X, Centre_Y). Rename data frame columns 
# or set partial.match = TRUE to only insert to matching colunns.
# 77 said   2 column(s) in data frame are missing in database table (Centre_X, Centre_Y)

# TODO 



##########################################
### autoloads
##########################################
# schema <- "test" # dev, QA
schema <- "load" # was public

for (dept in list_All){
  #GEOMetry first
  
  ilots_to_add <- paste0("ilots_2008_", str_pad(dept, 3, side="left", pad = "0"), ".rda", sep="")
  print(paste("to load: ", ilots_to_add))
  df <- file.info(paste0(sourcedata, ilots_to_add))
  size <- df$size # PI,  file.info("ilots_2008_075.rda") said size=403
  
    if (file.exists(paste0(sourcedata, ilots_to_add)) && size > 1000){
    
      ilot <- load(paste0(sourcedata, ilots_to_add))
      ilot <- get(ilot)
      ilot$ID_ILOT <- as.numeric(ilot$ID_ILOT)      # make keys match better in DB
      ilot <- spTransform(ilot, "+init=epsg:3035")  # reproject
      ilot$sourcefile <- ilots_to_add               # add filename
      ilot$timestamp <- as.POSIXct(Sys.time())      # add timestamp
      # retilot <- FALSE
      retilot <- pgInsert(con,                                 # load to DB
               c(schema,"ilots"), 
               ilot,
               geom = "geom", 
               df.mode = FALSE,
               partial.match = FALSE, # pessimist for now
               overwrite = FALSE, 
               new.id = NULL,
               row.names = FALSE, 
               upsert.using = NULL, 
               alter.names = FALSE,
               encoding = NULL, 
               return.pgi = FALSE, 
               df.geom = NULL,
               geog = FALSE)
      
      # culture file must exist too
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
    
    } # end if file.exists 
  
  
if (retilot && retcult == TRUE){
  print(paste("files loaded: ", paste(ilots_to_add, cultures_to_add)))
}  
else {
  print(paste("file err, something was not loaded: ", paste(ilots_to_add, cultures_to_add)))  
  }
}


