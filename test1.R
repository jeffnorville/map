#from https://stackoverflow.com/questions/11671883/importing-an-array-from-matlab-into-r
# better https://stackoverflow.com/questions/28080579/how-to-load-a-matlab-struct-into-a-r-data-frame

library(R.matlab)
#setwd("C:/Users/Norville/Documents/spatial_data/sadapt")
sars <- readMat('SARs4EA.mat', fixNames = TRUE)
#sars2 <- readMat('SARs4EA.mat')
#all.equal(sars, sars2)

d <- sars$SARs4EA
df <- as.data.frame(d)
df$`1.1`

dft <- t(df)
#wups https://stackoverflow.com/questions/6778908/transpose-a-data-frame

head(dft)
head(df)

dft$`1.1`


#http://lukaspuettmann.com/2017/03/13/matlab-struct-to-r-dataframe/
varNames        <- names(sars$SARs4EA[,,1])
datList         <- sars$SARs4EA
datList         <- lapply(datList, unlist, use.names=FALSE) 
sarsdata        <- as.data.frame(datList) #where wheels come off - datList unlisting doesn't appreciate (what part?) complexity of file
names(sarsdata) <- varNames


#table(unlist(lapply(dta, class)))
