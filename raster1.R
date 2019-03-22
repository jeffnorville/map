library(sf)
library(tidyverse)
library(raster)

str_name<-'C:/Users/Norville/Documents/GIS DataBase/corine/2018/CLC2018_CLC2018_V2018_20b2.tif'
CLC2018 <- raster(str_name)

head(CLC2018)
class(CLC2018)



library(rpostgis)
con  <-  dbConnect("PostgreSQL",
                   dbname = 'api2',
                   host   = 'localhost',
                   user   = 'pgisuser',
                   password = 'apismal2019')
(crs <- CRS("+proj=longlat"))

# from https://rdrr.io/cran/rpostgis/man/pgWriteRast.html
# basic test
r <- raster::raster(nrows=180, ncols=360, xmn=-180, xmx=180,
                    ymn=-90, ymx=90, vals=1)
pgWriteRast(con, c("public", "test"), raster = r,
            bit.depth = "2BUI", overwrite = TRUE)


pgWriteRast(con, 
            name=c("CLC","raster2"),
            raster = r, 
            bit.depth = NULL, 
            overwrite = FALSE)

