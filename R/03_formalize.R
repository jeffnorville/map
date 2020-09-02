#spatialisation only to DB
# format of form commun

# working directory
wd <- list()
# commonly used paths in my working directory
wd$data   <- "C:/Users/Jeff Norville/Documents/R/map/data/"
wd$output <- "C:/Users/Jeff Norville/Documents/R/map/output/"

#rm(list=ls())

# appel packages
require(foreign)
require(dplyr)
require(sf)
require(rpostgis)
library(dplyr)
library(tidyr)

#ini files
gethost     <- Sys.getenv("dbhost")
getdbname <- Sys.getenv("dbname")
getusername <- Sys.getenv("user")
getpassword <- Sys.getenv("passwd")

# database
con  <-  dbConnect("PostgreSQL",
                   dbname = getdbname,
                   host   = gethost,
                   user   = getusername,
                   password = getpassword)
# isPostgresqlIdCurrent(con) #boolean, checks if postgres instance is alive
# pgPostGIS(con) #check that postgis is installed in db

# define queries


# select_gtlist <- "SELECT * FROM information_schema.tables WHERE table_schema = 'aropaj' AND table_name like 'gt%'"
# tbls_aropaj <- dbGetQuery(con, select_gtlist)
# liste_db_GT <- tbls_aropaj$table_name

# for each region
# sel_area_clc <- "select * from clc_mask_pra02336"
# sel_area_rpg <- "select * from rpg_mask_pra02336"
# tbls_rpgpra02336 <- dbGetQuery(con, sel_area_rpg)
# tbls_clcpra02336 <- dbGetQuery(con, sel_area_clc)
# tbls_rpgpra02336 <- st_read(con, sel_area_rpg)
# tbls_clcpra02336 <- st_read(con, sel_area_clc)
# ^^^^^^^^^^^^^^^^^^^all broken

# class(tbls_clcpra02336)
tbls_clcpra02336 <- st_read(con, layer = "clc_mask_pra02336")
tbls_rpgpra02336 <- st_read(con, layer = "rpg_mask_pra02336")

class(tbls_rpgpra02336)
plot(tbls_rpgpra02336$geom)
plot(tbls_clcpra02336$geom)

head(tbls_rpgpra02336)
summary(tbls_rpgpra02336)

# this takes some time !!!!
# tbl_form1fromR <- st_union(tbls_clcpra02336, tbls_rpgpra02336, )
# plot(tbls_clcpra02336)

head(tbls_clcpra02336)
summary(tbls_clcpra02336)
plot(tbls_clcpra02336$geom)




query <- paste(
  'SELECT "name", "name_long", "geometry"',
  'FROM "ne_world"',
  'WHERE ("continent" = \'Africa\');'
)

class(tbls_clcpra02336)
plot(tbls_clcpra02336$geom)
summary(tbls_rpgpra02336)

#assign landuse values
# library(dplyr)
# library(tidyr)
table %>%
  gather(key = "pet") %>%
  left_join(lookup, by = "pet") %>%
  spread(key = pet, value = class)

# https://stackoverflow.com/questions/35636315/replace-values-in-a-dataframe-based-on-lookup-table

