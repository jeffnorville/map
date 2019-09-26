# run exploratory PCA on C:\Users\Norville\Documents\spatial_data\sadapt\Optimized_PRA_percentage.xlsx
#pg = permanent grassland
#npg = non-perm grassland


rm(list=objects())
library(FactoMineR)

#PRAs over 200k ha
tfbp <- file.path("C:/Users/Norville/Documents/spatial_data/map/sadapt/optBigPRAs.txt")
#all PRAs
tf <- file.path("C:/Users/Norville/Documents/spatial_data/map/sadapt/optAllPRAs.txt")

#rm(dsad)

#Pour charger un jeu de données (par exemple fichier de notes)
ds <- read.table(tf, header=TRUE, dec=',')
#dsad <- read.csv2(tf, header=TRUE, sep=";")

class(ds)
head(ds)

summary(ds)
str(ds)

pairs(ds)
ds$CODEPRA <- as.factor(ds$CODEPRA)

#Pour effectuer une analyse en composantes principales sur données
# centrées réduites:

ds.pca <- PCA(ds[2:6])

# Sur données non centrées-réduites:
#ds.pca <-PCA(ds[2:6],scale.unit=FALSE)

#Pour voir les résultats relatifs aux valeurs propres:
ds.pca$eig

#Pour les résultats relatifs aux variables:
ds.pca$var

#Les résultats relatifs aux individus:
ds.pca$ind

#Les valeurs propres et vecteurs propres:
ds.pca$svd

# Coef de corrélation entre chacune des variables et les deux
# premières composantes principales:
#round(ds.pca$var$coord[,1:6],2)

round(ds.pca$var$coord[,1:5],2)

# Décomposition de la variabilité par axes:
round(ds.pca$eig,2)

# Distance des individus au centre du nuage: (pour détecter des
# individus remarquables)
round(ds.pca$ind$dist,2)

# Contribution des individus à la construction des axes
round(ds.pca$ind$contrib[,1:2],2)

# Contribution des variables à la construction des axes
round(ds.pca$var$contrib[,1:2],2)

# Pour avoir le cercle des corrélations sur axe 2 et 3
x11()
#dplot(D6.acp, choix='ind', axes=c(2,5))
plot(ds.pca, choix='ind', axes=c(2,5))
x11()
plot(ds.pca, choix='var', axes=c(1:3))

# Pour obtenir un dendrogramme
d6.clust <- hclust(dist(d6))
plot(d6.clust)

# strip 
head(dsad)

dsad.clust <- hclust(dist(dsad))
plot(dsad.clust)

