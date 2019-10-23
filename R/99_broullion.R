wd <- list()
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
gethost     <- Sys.getenv("dbhost")
getdbname   <- Sys.getenv("dbname")
getusername <- Sys.getenv("user")
getpassword <- Sys.getenv("passwd")
con  <-  dbConnect("PostgreSQL",
                   dbname = getdbname,
                   host   = gethost,
                   user   = getusername,
                   password = getpassword)



# rm(reglookup)
# reglookup <- read.table(file = "clipboard", sep = "\t", header = TRUE)
reglookup <- read.table(file = "c:/users/norville/desktop/dept_pra.txt", sep = "\t", header = TRUE)

summary(reglookup)

pgInsert(con, 
         c("public", "reg_dept_pra"), 
         reglookup,
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

