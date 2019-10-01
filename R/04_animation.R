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