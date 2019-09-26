#spatialisation only to DB

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
#motivation over sf and rpostgres etc https://journal.r-project.org/archive/2018/RJ-2018-025/RJ-2018-025.pdf
require(rpostgis)
library(dplyr)
library(tidyr)


# database
con  <-  dbConnect("PostgreSQL",
                   dbname = getdbname,
                   host   = gethost,
                   user   = getusername,
                   password = getpassword)
# isPostgresqlIdCurrent(con) #boolean, checks if postgres instance is alive
# pgPostGIS(con) #check that postgis is installed in db

# define queries


select_gtlist <- "SELECT * FROM information_schema.tables WHERE table_schema = 'aropaj' AND table_name like 'gt%'"
tbls_aropaj <- dbGetQuery(con, select_gtlist)
liste_db_GT <- tbls_aropaj$table_name

# for each region


#assign landuse values
# library(dplyr)
# library(tidyr)
table %>%
  gather(key = "pet") %>%
  left_join(lookup, by = "pet") %>%
  spread(key = pet, value = class)
