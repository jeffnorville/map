# working directory
wd <- list()
# commonly used paths in my working directory
wd$data   <- "C:/Users/Jeff Norville/Documents/R/map/data/"
wd$output <- "C:/Users/Jeff Norville/Documents/R/map/output/"

rm(list=ls())

require(sp)
require(rpostgis)
require(stringr)


# sept 2019 cleaning up for final repo
sourcedata = "C:/opt/donnees_R/RPG/V2/"

# load("C:/opt/donnees_R/RPG/V2/ilots_2008_002.rda")
# load("C:/opt/donnees_R/RPG/V2/ilotsCult_2008_002.rda")

#load Picardie (002, 060, 080)
list_Picardie <- c(2, 60, 80)
#load Bourgogne (reg 26) (Departments 21 58 71 89)
list_Bourgogne <- c(21, 58, 71, 89)
#load Midi-Pyrenees (reg 73) (Department 09, 12, 31, 32, 46, 65, 81, 82)
list_MidiPyrenees <- c(09, 12, 31, 32, 46, 65, 81, 82)
#load Rhone-Alpes (reg 82) (Department, 01, 07, 26, 38, 42, 69, 73, 74)
list_RhoneAlpes <- c(01, 07, 26, 38, 42, 69, 73, 74)
list_Bourgogne
list_MidiPyrenees
list_RhoneAlpes

for (dept in list_Picardie){
  ilots_to_add    <- paste("ilots_2008_", str_pad(dept, 3, side="left", pad = "0"), ".rda", sep="")
  cultures_to_add <- paste("ilotsCult_2008_", str_pad(dept, 3, side="left", pad = "0"), ".rda", sep="")
  load(paste0(sourcedata, ilots_to_add))
  load(paste0(sourcedata, cultures_to_add))
  print(paste("files loaded: ", paste(ilots_to_add, cultures_to_add)))
}

# paste text to speed reprojection
for (dept in list_Picardie){
  ilots_to_add    <- paste("ilots_2008_", str_pad(dept, 3, side="left", pad = "0"), sep="")
  print(paste(ilots_to_add, "<- spTransform(", ilots_to_add, ", \"+init=epsg:3035\")"))
}

summary(ilots_2008_080)
ilots_2008_002 <- spTransform(ilots_2008_002, "+init=epsg:3035")

ilots_2008_002 <- spTransform( ilots_2008_002, "+init=epsg:3035")
ilots_2008_060 <- spTransform( ilots_2008_060, "+init=epsg:3035")
ilots_2008_080 <- spTransform( ilots_2008_080, "+init=epsg:3035")
summary(ilots_2008_002)
summary(ilots_2008_060)
summary(ilots_2008_080)


# paste text to speed as.numeric
for (dept in list_Picardie){
  ilots_to_add <- paste0("ilots_2008_", str_pad(dept, 3, side="left", pad = "0"), sep="")
  print(paste0(ilots_to_add, "$ID_ILOT <- as.numeric(", ilots_to_add, "$ID_ILOT)", sep=""))
}

### done


##  1. CORRECT PROJECTION
ilots3035_2008_002 <- spTransform(ilots_2008_002, "+init=epsg:3035")
class(ilots_2008_002)
ilots3035_2008_002 <- st_transform(ilots_2008_002, "+init=epsg:3035")
plot(ilots3035_2008_002)

##  2. BEFORE LOADING to DB - convert ID_ILOT to num from str
ilots_2008_002$ID_ILOT <- as.numeric(ilots_2008_002$ID_ILOT)

## 3. LOAD both GEOM and CULTURE files


require(rpostgis)
require(stringr)

#load Midi-Pyrenees (reg 73) (Department 09, 12, 31, 32, 46, 65, 81, 82)
list_reg73 <- c(9, 12, 31, 32, 46, 65, 81, 82)
for (dept in list_reg73){
  print(paste("file:", "ilots_2008_", str_pad(dept, 3, side="left", pad = "0"), sep=""))
}

ilot_to_add <- paste("ilots_2008_", str_pad(dept, 3, side="left", pad = "0"), sep="")
print(paste("inserting "), ilot_to_add)
pgInsert(con, 
         c("public","ilots"), 
         ilot_to_add,
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











## sept updates - below can be ignored, keeping for reference during handoff

# mostly this is dumb (better to loop thru all files)
# like this: https://gis.stackexchange.com/questions/231601/looping-over-several-input-files-in-r
# but for the moment I need to only load dept by dept for  local machine
# should automate for remote db load


#Load library
library(raster)
#Load shapefile
shp <- shapefile("C:/opt/donnees_R/RPG/V2/ilots_2008_002.rda")


library(sf)
CRS <- "+init=epsg:3035"
load("C:/opt/donnees_R/RPG/V2/ilots_2008_002.rda")
class(ilots_2008_002)
sf_ilots_2008_002 <- st_as_sf(ilots_2008_002)
class(sf_ilots_2008_002)

sf_ilots_2008_002 <- st_transform(sf_ilots_2008_002, CRS)
summary(sf_ilots_2008_002)
class(sf_ilots_2008_002$ID_ILOT)
sf_ilots_2008_002$ID_ILOT <- as.numeric(sf_ilots_2008_002$ID_ILOT)
class(sf_ilots_2008_002$ID_ILOT) # that works okay





s <- read_sf("C:/opt/donnees_R/RPG/V2/ilots_2008_002.rda")
s <- attach("C:/opt/donnees_R/RPG/V2/ilots_2008_002.rda")
t <- as.data.frame(ilots_2008_002)
class(s)


#load Picardie (002, 060, 080) (done)
load("C:/opt/donnees_R/RPG/V2/ilotsCult_2008_002.rda")
load("C:/opt/donnees_R/RPG/V2/ilotsCult_2008_060.rda")
load("C:/opt/donnees_R/RPG/V2/ilotsCult_2008_080.rda")
load("C:/opt/donnees_R/RPG/V2/ilots_2008_002.rda")
load("C:/opt/donnees_R/RPG/V2/ilots_2008_060.rda")
load("C:/opt/donnees_R/RPG/V2/ilots_2008_080.rda")

library(rpostgis)
 con  <-  dbConnect("PostgreSQL",
                    dbname = 'api2', #'apismal',
                    host   = 'localhost',
                    user   = 'pgisuser', #'postgres',
                    password = 'apismal2019') #'postgres'

con  <-  dbConnect("PostgreSQL",
                   dbname = 'apismal',
                   host   = 'localhost',
                   user   = 'postgres',
                   password = 'postgres')



#here begins file parsing play
ilots <- "ilots_"
ilotscult <- "ilotsCult_"
rdadir <- "C:/opt/donnees_R/RPG/V2/HAUTE-NORMANDIE"
allfiles <- list.files(path=rdadir, full.names = TRUE)
allfiles <- list.files(path=rdadir, full.names = FALSE)

files <- list.files(path=rdadir, pattern='ilots', full.names = TRUE)
files_ilots <- list.files(path=rdadir, pattern=ilots, full.names = TRUE)
files_ilotscult <- list.files(path=rdadir, pattern=ilotscult, full.names = FALSE)

##############################
require(sp)
require(sf)
require(rgdal)
require(rpostgis)

con  <-  dbConnect("PostgreSQL",
                   dbname = 'api2', #'apismal',
                   host   = 'localhost',
                   user   = 'pgisuser', #'postgres',
                   password = 'apismal2019') #'postgres'

rm(list=ls())
require(sf)
rdadir <- "C:/opt/donnees_R/RPG/V2/HAUTE-NORMANDIE"
ilots <- "ilots_"
# files_ilots <- list.files(path=rdadir, pattern=ilots, full.names = TRUE)
#files_ilots <- list.files(path=rdadir, pattern=ilots, full.names = FALSE)
CRS <- "+init=epsg:3035"

filelist <- list.files(path=rdadir, pattern=ilots, full.names = TRUE)
class(filelist)
file <- filelist[1]
class(file)
afile <- attach(file)


filehand <- load(file)
class(filehand)
f1 <- load(file)
class(f1)
f2 <- st_transform(f1, CRS) # sf version
f2 <- spTransform(f1, CRS) #sp version
spTransform(file, CRS)

library(sf)

# from Barry on SO:
# getRDA = function(f){e = new.env();load(f, env=e); return(e[[names(e)]])}
require(sf)
rdadir <- "C:/opt/donnees_R/RPG/V2/HAUTE-NORMANDIE"
ilots <- "ilots_"
CRS <- "+init=epsg:3035"
filelist <- list.files(path=rdadir, pattern=c(ilots , "2008") , full.names = TRUE)
# sf_ilots_2008_002 <- st_as_sf(ilots_2008_002)

getRDA = function(f){e = new.env();
  load(f, env=e); 
  return(st_transform(basename(e), CRS))}
  #st_transform(load(file, env=e), CRS); 
  #return(e[[names(e)]])}
basename(file)
for (file in filelist){
  # getRDA = function(f){e = new.env();load(file, env=e); return(e)}
  f <- getRDA(file)
#  print(paste("getRDA "), f)
}

f$
f[1]
filelist[3]

rm(getRDA)
getRDA = function(f){e = new.env();load(file, env=e); return(e[[names(e)]])}
e = getRDA(file)
e$ID_ILOT

count(e$ID_ILOT)
load(file)

getRDA = function(f){e = new.env();load(file, env=e); return(e[[names(e)]])}
getRDA = function(f){e = new.env();load(file, env=e); return(e)}

getRDA("x.rda")

filelist <- list.files(path=rdadir, pattern=ilots, full.names = TRUE)
for (file in filelist){
  
  afile <- attach(file)
  print(paste("after attach "))
  # 1. coordinates11
#  afile <- spTransform(afile, CRS)
  # 2. convert ID_ILOT to num from str
  print(paste("ID_ILOT "), afile$file$ID_ILOT)
  afile$ID_ILOT <- as.numeric(afile$ID_ILOT)
  detach(afile)  
}

filelist <- list.files(path=rdadir, pattern=ilots, full.names = TRUE)
for (file in filelist){
  
  afile <- readRDS(file) # nope, unknown file format
  print(paste("after attach "))
  # 1. coordinates11
  #  afile <- spTransform(afile, CRS)
  # 2. convert ID_ILOT to num from str
  print(paste("ID_ILOT "), afile$file$ID_ILOT)
  afile$ID_ILOT <- as.numeric(afile$ID_ILOT)
  detach(afile)  
}




rm(afile)
afile$ilots_2008_027$ID_ILOT

e <- getRDA(file)
e$ilots_2008_027

files_ilots <- list.files(rdadir)
for (file in files_ilots){
  print(paste("before load, class ", class(file)))
  load(file)
  ## remember to rm(file) at end of looping func
  
  # 1. coordinates11
#  filehand <- spTransform(filehand, "+init=epsg:3035")
  # 2. convert ID_ILOT to num from str
  print(summary("filehand"))
  file$ID_ILOT <- as.numeric(filehand$ID_ILOT)
}

summary(file)

# summary(ilots_2008_027)
# class(ilots_2008_027$ID_ILOT)
# ilots_2008_027$ID_ILOT <- as.numeric(ilots_2008_027$ID_ILOT)
# class(ilots_2008_027$ID_ILOT)
# 
# typeof(ilots_2008_076$ID_ILOT)

for (file in files_ilots){
  # file <- tools::file_path_sans_ext(file) #get object, not filepath which is a char
  file <- load(file)
  ## remember to rm(file) at end of looping func
  
  # 1. coordinates11
  file <- spTransform(file, CRS)
  # 2. convert ID_ILOT to num from str
  file$ID_ILOT <- as.numeric(file$ID_ILOT)
  
  rm(file)
  rm(fileobj)
}  
  #spTransform fails sept 5
  
  # 3. load by pgInsert
  pgInsert(con, 
           c("test","ilots"), #public -- FOR TESTing
           file, #ex ilots_2008_082
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
  
  rm(file)
  fprint(subname)
  
}

##############################



# need to seperate ilot from ilotcult files after loading, here are things to try
# easier to seperate them during load I think
 file <- files[3]
 list <- strsplit(file, "/")
 # rm(list)
 filename <- list[[1]][7]
 
 
 
 txt <- c("arm","foot","lefroo", "bafoobar")
 if(length(i <- grep("foo", txt)))
   cat("'foo' appears at least once in\n\t", txt, "\n")
 i # 2 and 4
 txt[i]

# find files by keyword 2010 in list of ilots_files: 
y2010_fi <- grep("2010", files_ilots)
# here they are
files_ilots[y2010_fi] 
 
# which()
 TRUE %in% (list.files() == 'nameoffile.csv') 

name <- files[2]
# subname <- sub(ilots, ilotscult, file)

# https://stackoverflow.com/questions/20144890/sorting-files-into-folders-by-file-name-in-r

for (file in files){
  name <- file
  subname <- sub(ilots, ilotscult, file)
  
  load(file) # put in memory
  ## Remember to rm(file) at end of func
  if subname == ilots
    # 1. coordinates
    file <- spTransform(file, "+init=epsg:3035")
    # 2. convert ID_ILOT to num from str
    file$ID_ILOT <- as.numeric(file$ID_ILOT)
    # 3. load by pgInsert
    pgInsert(con, 
             c("test","ilots"), #public
             file, #ex ilots_2008_082
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
#    rm(file)
    elsif subname == ilotscult
      fprint(subname)
    
    end if
  
  
  )
}


# 23 HAUTE-NORMANDIE (27, 76)
load("C:/opt/donnees_R/RPG/V2/ilots_2008_027.rda")
load("C:/opt/donnees_R/RPG/V2/ilots_2008_076.rda")
load("C:/opt/donnees_R/RPG/V2/ilotsCult_2008_027.rda")
load("C:/opt/donnees_R/RPG/V2/ilotsCult_2008_076.rda")



#ILE-DE-FRANCE (91, 92, 75, 77, 93, 95, 94, 78)

load("C:/opt/donnees_R/RPG/V2/ilots_2008_091.rda")
load("C:/opt/donnees_R/RPG/V2/ilots_2008_092.rda")
load("C:/opt/donnees_R/RPG/V2/ilots_2008_075.rda")
load("C:/opt/donnees_R/RPG/V2/ilots_2008_077.rda")
load("C:/opt/donnees_R/RPG/V2/ilots_2008_093.rda")
load("C:/opt/donnees_R/RPG/V2/ilots_2008_095.rda")
load("C:/opt/donnees_R/RPG/V2/ilots_2008_094.rda")
load("C:/opt/donnees_R/RPG/V2/ilots_2008_078.rda")
load("C:/opt/donnees_R/RPG/V2/ilotsCult_2008_002.rda")
load("C:/opt/donnees_R/RPG/V2/ilotsCult_2008_060.rda")
load("C:/opt/donnees_R/RPG/V2/ilotsCult_2008_080.rda")
load("C:/opt/donnees_R/RPG/V2/ilotsCult_2008_002.rda")
load("C:/opt/donnees_R/RPG/V2/ilotsCult_2008_060.rda")
load("C:/opt/donnees_R/RPG/V2/ilotsCult_2008_080.rda")
load("C:/opt/donnees_R/RPG/V2/ilotsCult_2008_002.rda")
load("C:/opt/donnees_R/RPG/V2/ilotsCult_2008_060.rda")

# 21 CHAMPAGNE-ARDENNE (8, 10, 52, 51)
load("C:/opt/donnees_R/RPG/V2/ilots_2008_008.rda")
load("C:/opt/donnees_R/RPG/V2/ilots_2008_010.rda")
load("C:/opt/donnees_R/RPG/V2/ilots_2008_052.rda")
load("C:/opt/donnees_R/RPG/V2/ilots_2008_051.rda")
load("C:/opt/donnees_R/RPG/V2/ilotsCult_2008_008.rda")
load("C:/opt/donnees_R/RPG/V2/ilotsCult_2008_010.rda")
load("C:/opt/donnees_R/RPG/V2/ilotsCult_2008_052.rda")
load("C:/opt/donnees_R/RPG/V2/ilotsCult_2008_051.rda")


# 24 CENTRE (18, 28, 36, 37, 41, 45)
load("C:/opt/donnees_R/RPG/V2/ilots_2008_018.rda")
load("C:/opt/donnees_R/RPG/V2/ilots_2008_028.rda")
load("C:/opt/donnees_R/RPG/V2/ilots_2008_036.rda")
load("C:/opt/donnees_R/RPG/V2/ilots_2008_037.rda")
load("C:/opt/donnees_R/RPG/V2/ilots_2008_041.rda")
load("C:/opt/donnees_R/RPG/V2/ilots_2008_045.rda")
load("C:/opt/donnees_R/RPG/V2/ilotsCult_2008_018.rda")
load("C:/opt/donnees_R/RPG/V2/ilotsCult_2008_028.rda")
load("C:/opt/donnees_R/RPG/V2/ilotsCult_2008_036.rda")
load("C:/opt/donnees_R/RPG/V2/ilotsCult_2008_037.rda")
load("C:/opt/donnees_R/RPG/V2/ilotsCult_2008_041.rda")
load("C:/opt/donnees_R/RPG/V2/ilotsCult_2008_045.rda")

# 25 BASSE-NORMANDIE (14, 50, 61)
load("C:/opt/donnees_R/RPG/V2/ilots_2008_014.rda")
load("C:/opt/donnees_R/RPG/V2/ilots_2008_050.rda")
load("C:/opt/donnees_R/RPG/V2/ilots_2008_061.rda")
load("C:/opt/donnees_R/RPG/V2/ilotsCult_2008_014.rda")
load("C:/opt/donnees_R/RPG/V2/ilotsCult_2008_050.rda")
load("C:/opt/donnees_R/RPG/V2/ilotsCult_2008_061.rda")

# 31 NORD-PAS-DE-CALAIS (59, 62)
load("C:/opt/donnees_R/RPG/V2/ilots_2008_059.rda")
load("C:/opt/donnees_R/RPG/V2/ilots_2008_062.rda")
load("C:/opt/donnees_R/RPG/V2/ilotsCult_2008_059.rda")
load("C:/opt/donnees_R/RPG/V2/ilotsCult_2008_062.rda")

# 41 LORRAINE (54, 55, 57, 88)
load("C:/opt/donnees_R/RPG/V2/ilots_2008_054.rda")
load("C:/opt/donnees_R/RPG/V2/ilots_2008_055.rda")
load("C:/opt/donnees_R/RPG/V2/ilots_2008_057.rda")
load("C:/opt/donnees_R/RPG/V2/ilots_2008_088.rda")
load("C:/opt/donnees_R/RPG/V2/ilotsCult_2008_054.rda")
load("C:/opt/donnees_R/RPG/V2/ilotsCult_2008_055.rda")
load("C:/opt/donnees_R/RPG/V2/ilotsCult_2008_057.rda")
load("C:/opt/donnees_R/RPG/V2/ilotsCult_2008_088.rda")

# 42 ALSACE (67, 68)
load("C:/opt/donnees_R/RPG/V2/ilots_2008_067.rda")
load("C:/opt/donnees_R/RPG/V2/ilots_2008_068.rda")
load("C:/opt/donnees_R/RPG/V2/ilotsCult_2008_067.rda")
load("C:/opt/donnees_R/RPG/V2/ilotsCult_2008_068.rda")

# 43 FRANCHE-COMTE (25, 70, 39, 90)
load("C:/opt/donnees_R/RPG/V2/ilots_2008_025.rda")
load("C:/opt/donnees_R/RPG/V2/ilots_2008_070.rda")
load("C:/opt/donnees_R/RPG/V2/ilots_2008_039.rda")
load("C:/opt/donnees_R/RPG/V2/ilots_2008_090.rda")
load("C:/opt/donnees_R/RPG/V2/ilotsCult_2008_025.rda")
load("C:/opt/donnees_R/RPG/V2/ilotsCult_2008_070.rda")
load("C:/opt/donnees_R/RPG/V2/ilotsCult_2008_039.rda")
load("C:/opt/donnees_R/RPG/V2/ilotsCult_2008_090.rda")

# 52 PAYS-DE-LA-LOIRE (44, 49, 53, 72, 85)
load("C:/opt/donnees_R/RPG/V2/ilots_2008_044.rda")
load("C:/opt/donnees_R/RPG/V2/ilots_2008_049.rda")
load("C:/opt/donnees_R/RPG/V2/ilots_2008_053.rda")
load("C:/opt/donnees_R/RPG/V2/ilots_2008_072.rda")
load("C:/opt/donnees_R/RPG/V2/ilots_2008_085.rda")
load("C:/opt/donnees_R/RPG/V2/ilotsCult_2008_044.rda")
load("C:/opt/donnees_R/RPG/V2/ilotsCult_2008_049.rda")
load("C:/opt/donnees_R/RPG/V2/ilotsCult_2008_053.rda")
load("C:/opt/donnees_R/RPG/V2/ilotsCult_2008_072.rda")
load("C:/opt/donnees_R/RPG/V2/ilotsCult_2008_085.rda")

# 53 BRETAGNE (22, 29, 35, 56)
load("C:/opt/donnees_R/RPG/V2/ilots_2008_022.rda")
load("C:/opt/donnees_R/RPG/V2/ilots_2008_029.rda")
load("C:/opt/donnees_R/RPG/V2/ilots_2008_035.rda")
load("C:/opt/donnees_R/RPG/V2/ilots_2008_056.rda")
load("C:/opt/donnees_R/RPG/V2/ilotsCult_2008_022.rda")
load("C:/opt/donnees_R/RPG/V2/ilotsCult_2008_029.rda")
load("C:/opt/donnees_R/RPG/V2/ilotsCult_2008_035.rda")
load("C:/opt/donnees_R/RPG/V2/ilotsCult_2008_056.rda")

# 54 POITOU-CHARENTES (16, 17, 79, 86)
load("C:/opt/donnees_R/RPG/V2/ilots_2008_016.rda")
load("C:/opt/donnees_R/RPG/V2/ilots_2008_017.rda")
load("C:/opt/donnees_R/RPG/V2/ilots_2008_079.rda")
load("C:/opt/donnees_R/RPG/V2/ilots_2008_086.rda")
load("C:/opt/donnees_R/RPG/V2/ilotsCult_2008_016.rda")
load("C:/opt/donnees_R/RPG/V2/ilotsCult_2008_017.rda")
load("C:/opt/donnees_R/RPG/V2/ilotsCult_2008_079.rda")
load("C:/opt/donnees_R/RPG/V2/ilotsCult_2008_086.rda")

# 72 AQUITAINE (24, 33, 40, 47, 64)
load("C:/opt/donnees_R/RPG/V2/ilots_2008_024.rda")
load("C:/opt/donnees_R/RPG/V2/ilots_2008_033.rda")
load("C:/opt/donnees_R/RPG/V2/ilots_2008_040.rda")
load("C:/opt/donnees_R/RPG/V2/ilots_2008_047.rda")
load("C:/opt/donnees_R/RPG/V2/ilots_2008_064.rda")
load("C:/opt/donnees_R/RPG/V2/ilotsCult_2008_024.rda")
load("C:/opt/donnees_R/RPG/V2/ilotsCult_2008_033.rda")
load("C:/opt/donnees_R/RPG/V2/ilotsCult_2008_040.rda")
load("C:/opt/donnees_R/RPG/V2/ilotsCult_2008_047.rda")
load("C:/opt/donnees_R/RPG/V2/ilotsCult_2008_064.rda")

# 74 LIMOUSIN (19, 23, 87)
load("C:/opt/donnees_R/RPG/V2/ilots_2008_019.rda")
load("C:/opt/donnees_R/RPG/V2/ilots_2008_023.rda")
load("C:/opt/donnees_R/RPG/V2/ilots_2008_087.rda")
load("C:/opt/donnees_R/RPG/V2/ilotsCult_2008_019.rda")
load("C:/opt/donnees_R/RPG/V2/ilotsCult_2008_023.rda")
load("C:/opt/donnees_R/RPG/V2/ilotsCult_2008_087.rda")

# 83 AUVERGNE (3, 15, 43, 63)
load("C:/opt/donnees_R/RPG/V2/ilots_2008_003.rda")
load("C:/opt/donnees_R/RPG/V2/ilots_2008_015.rda")
load("C:/opt/donnees_R/RPG/V2/ilots_2008_043.rda")
load("C:/opt/donnees_R/RPG/V2/ilots_2008_063.rda")
load("C:/opt/donnees_R/RPG/V2/ilotsCult_2008_003.rda")
load("C:/opt/donnees_R/RPG/V2/ilotsCult_2008_015.rda")
load("C:/opt/donnees_R/RPG/V2/ilotsCult_2008_043.rda")
load("C:/opt/donnees_R/RPG/V2/ilotsCult_2008_063.rda")

# 91 LANGUEDOC-ROUSSILLON (11, 30, 34, 48, 66)
load("C:/opt/donnees_R/RPG/V2/ilots_2008_011.rda")
load("C:/opt/donnees_R/RPG/V2/ilots_2008_030.rda")
load("C:/opt/donnees_R/RPG/V2/ilots_2008_034.rda")
load("C:/opt/donnees_R/RPG/V2/ilots_2008_048.rda")
load("C:/opt/donnees_R/RPG/V2/ilots_2008_066.rda")
load("C:/opt/donnees_R/RPG/V2/ilotsCult_2008_011.rda")
load("C:/opt/donnees_R/RPG/V2/ilotsCult_2008_030.rda")
load("C:/opt/donnees_R/RPG/V2/ilotsCult_2008_034.rda")
load("C:/opt/donnees_R/RPG/V2/ilotsCult_2008_048.rda")
load("C:/opt/donnees_R/RPG/V2/ilotsCult_2008_066.rda")

# 93 PROVENCE-ALPES-COTE-D\'AZUR (4, 6, 13, 5, 83, 84)
load("C:/opt/donnees_R/RPG/V2/ilots_2008_004.rda")
load("C:/opt/donnees_R/RPG/V2/ilots_2008_006.rda")
load("C:/opt/donnees_R/RPG/V2/ilots_2008_013.rda")
load("C:/opt/donnees_R/RPG/V2/ilots_2008_005.rda")
load("C:/opt/donnees_R/RPG/V2/ilots_2008_083.rda")
load("C:/opt/donnees_R/RPG/V2/ilots_2008_084.rda")
load("C:/opt/donnees_R/RPG/V2/ilotsCult_2008_004.rda")
load("C:/opt/donnees_R/RPG/V2/ilotsCult_2008_006.# rda")
load("C:/opt/donnees_R/RPG/V2/ilotsCult_2008_013.# rda")
load("C:/opt/donnees_R/RPG/V2/ilotsCult_2008_005.# rda")
load("C:/opt/donnees_R/RPG/V2/ilotsCult_2008_083.# rda")
load("C:/opt/donnees_R/RPG/V2/ilotsCult_2008_084.# rda")

# 94 CORSE (2A, 2B)
load("C:/opt/donnees_R/RPG/V2/ilots_2008_02A.rda")
load("C:/opt/donnees_R/RPG/V2/ilots_2008_02B.rda")
load("C:/opt/donnees_R/RPG/V2/ilotsCult_2008_02A.rda")
load("C:/opt/donnees_R/RPG/V2/ilotsCult_2008_02B.rda")

library(rpostgis)

# load ilots
# 1. coordinates
ilots3035_2008_002 <- spTransform(ilots_2008_002, "+init=epsg:3035")

# 2. convert ID_ILOT to num from str
ilots_2008_009$ID_ILOT <- as.numeric(ilots_2008_009$ID_ILOT)

# 3. load by pgInsert
pgInsert(con, 
         c("public","ilots"), 
         ilots_2008_082,
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



# load cult files
pgInsert(con, 
         c("public","culture"), 
         ilotsCult_2008_021,
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

