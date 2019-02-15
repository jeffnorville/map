
library(raster)

str_name<-'C:/Users/Norville/Documents/spatial_data/CLC_2012_100/clc2018_clc2018_v2018_20b2_raster100m/CLC2018_CLC2018_V2018_20b2.tif'
imported_raster=raster(str_name)

head(imported_raster)