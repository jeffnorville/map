#from https://stackoverflow.com/questions/11671883/importing-an-array-from-matlab-into-r
# better https://stackoverflow.com/questions/28080579/how-to-load-a-matlab-struct-into-a-r-data-frame

library(R.matlab)
#setwd("C:/Users/Norville/Documents/spatial_data/sadapt")
sars <- readMat('SARs4EA.mat', fixNames = TRUE)
#sars2 <- readMat('SARs4EA.mat')
#all.equal(sars, sars2)

# this pulls data object into dataframe
d <- sars$SARs4EA
df <- as.data.frame(d)
df$`1.1`

#data is far from tidy, transpose?
dft <- t(df)
#wups https://stackoverflow.com/questions/6778908/transpose-a-data-frame

head(dft)

head(df)

df$`1.1`
df$`2.1`

dft$`1.1`

#http://lukaspuettmann.com/2017/03/13/matlab-struct-to-r-dataframe/
#varNames        <- names(sars$SARs4EA[,,1])
varNames        <- names(sars$SARs4EA[,1,]) #like "fieldnames(SARs4EA)" from matlab
datList         <- sars$SARs4EA
datList         <- lapply(datList, unlist, use.names=FALSE) #tried keeping names too
sarsdata        <- as.data.frame(datList) #where wheels come off - datList unlisting doesn't appreciate (what part?) complexity of file "les arguments impliquent des nombres de lignes différents"
names(sarsdata) <- varNames

row.names(df)

#table(unlist(lapply(dta, class)))

## things I need to access...
MyDepartments: df[37,]
mydepts <- df[37,]
MyRegions: df[36,]

# LandUses
# df[22,]
landuses <- df[22,]


# $CODEPRA
# like this: df[4,] (and they are 1.1 through 709.1)
codepra <- df[4,]

# 
# $RemainingCLC2012
# like this: df[15,]
# 
# CLC111 300.6659
# CLC112 14127.81
# CLC121 3167.867
# CLC122 581.435 
# CLC123 143.278 
# CLC124 558.8838
# CLC131 30.27001
# CLC132 0       
# CLC133 0       
# CLC141 912.4413
# CLC142 725.2852
# CLC221 0       
# CLC222 31.27901
# CLC223 0       
# CLC242 454.8634
# CLC243 122.0344
# CLC322 0       
# CLC331 0       
# CLC332 0       
# CLC333 0       
# CLC334 0       
# CLC335 0       
# CLC411 0       
# CLC412 0       
# CLC421 0       
# CLC422 0       
# CLC423 0       
# CLC511 241.7534
# CLC512 96.86403
# CLC521 0       
# CLC522 0       
# CLC523 0 