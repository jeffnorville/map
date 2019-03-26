#import .rda file, export .shp file

writeOGR(ilots_2008_002, dsn = "ilots_2008_002.shp", driver="ESRI Shapefile", verbose = TRUE)
#FAILS writeOGR(ilots_2008_002, "ilots_2008_002", layer = "data", driver="PostgreSQL", verbose = TRUE)
#WORKS, doesn't contain much:
writeOGR(ilots_2008_002, "ilots_2008_002", layer = "data", driver="SQLite", verbose = TRUE)

#Works, looked the same during processing, has all polygons
writeOGR(ilots_2008_002, dsn="ilots_2008_002", layer="ilots_2008_002", driver="ESRI Shapefile", verbose = TRUE)


head(ilots_2008_002)


try(writeOGR(cities, td, "cities", driver="ESRI Shapefile"))
writeOGR(cities, td, "cities", driver="ESRI Shapefile", overwrite_layer=TRUE)


