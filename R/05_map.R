# working directory
wd <- list()
# commonly used paths in my working directory
wd$data   <- "C:/Users/Jeff Norville/Documents/R/map/data/"
wd$output <- "C:/Users/Jeff Norville/Documents/R/map/output/"

#rm(list=ls())

# appel packages
require(dplyr)
require(sf)
#motivation over sf and rpostgres etc https://journal.r-project.org/archive/2018/RJ-2018-025/RJ-2018-025.pdf
require(rpostgis)

#nb - rstudio picks up from .renviron file at launch of program - variable cannot be redefined w/o relaunch (or at least reload) of .renviron file
#point of this is to keep passwords, etc, unique to local instance of program (and off of source control evidently)
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


##########################
# get the map
##########################
# query <- paste('SELECT grid.region, grid.codepra, grid.gridcode, grid.geom, ',
               

query <- paste('SELECT grid.geom, ',
'(arop.surfbled + arop.surfblet) AS wheat ',
'FROM public.dsgrid_pra2 grid',
'LEFT JOIN tomap.\"190412130048_APISMALd2190920134434\" arop ON grid.gridcode = arop."GRIDCODE"',
'AND CAST(grid.region AS integer) = arop.region WHERE simul=6')

# st_union make this SLOW - better to join against region geom and AVG(arop.surf*)
query <- paste('SELECT grid.region, ST_Union(grid.geom) as geom, ',
               'AVG(arop.surfbled + arop.surfblet) AS avg_wheat ',
               'FROM public.dsgrid_pra2 grid',
               'LEFT JOIN tomap.\"190412130048_APISMALd2190920134434\" arop ON grid.gridcode = arop."GRIDCODE"',
               'AND CAST(grid.region AS integer) = arop.region WHERE simul=6',
               'GROUP BY grid.region')

#query <- paste('select * from tomap."190412130048_APISMALd2190920134434" limit 100')
wheat_region <- st_read(con, query = query)
plot(wheat_region)

summary(wheat_sim06)
summary(wheatsmaller_sim06)

ne_world
plot(africa_sf)
plot(ne_world$admin)



# require(thinkridentity)
#tutorial from https://www.r-bloggers.com/interact-with-postgis-from-r/
require(rnaturalearth)
require(ggplot2)
require(dplyr)
require(sf)

ne_world <- rnaturalearth::ne_countries(scale = 50, returnclass = "sf")
# Choose one available to you
world_map_crs <- "+init=epsg:4088" #"+proj=eqearth +wktext" #"+init=epsg:4088"
# use some funky custom colors
custom.col <- c("#FFDB6D", "#C4961A", "#F4EDCA", 
                "#D16103", "#C3D7A4", "#52854C", "#4E84C4", "#293352")
ne_world %>% 
        st_transform(world_map_crs) %>% 
        ggplot() +
        geom_sf(fill = custom.col[6],
                color = custom.col[3]) +
        theme(panel.background = element_rect(fill = custom.col))

st_write(ne_world, dsn = con, layer = "ne_world",
         overwrite = FALSE, append = FALSE)

query <- paste(
        'SELECT "name", "name_long", "geometry"',
        'FROM "ne_world"',
        'WHERE ("continent" = \'Africa\');'
)
africa_sf <- st_read(con, query = query)
ne_world
plot(africa_sf)
plot(ne_world$admin)



##########################
# animated map
##########################

library(gapminder)
library(tidyverse)
library(sf)
library(tmap)
library(spData)
europe_area = st_polygon(list(rbind(c(-13, 34), c(-13, 72),
                                    c(43, 72), c(43, 34), c(-13, 34)))) %>% 
        st_sfc(crs = st_crs(world)) 
europe = st_intersection(world, europe_area) 
europe_gdp = europe %>% 
        inner_join(gapminder, by = c("name_long" = "country"))
m1 = tm_shape(europe) + 
        tm_fill("grey") + 
     tm_shape(europe_gdp) + 
        tm_fill("gdpPercap.y", title = "GDP per capita: ") +
        tm_borders() + 
        tm_facets(by = "year", nrow = 1, ncol = 1, drop.units = TRUE) + 
        tm_legend(text.size = 1, title.size = 1.2, 
                  position = c("left", "TOP"), height = 0.3)
animation_tmap(m1, filename = "figs/04_anim.gif", width = 650, height = 600)