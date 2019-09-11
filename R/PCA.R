# PCA analysis of "qryTmpPCAbyPRA" in Access DB D1.1v1.accdb
rm(list=objects())
library(FactoMineR)

tf <- file.path("C:/Users/Norville/Documents/spatial_data/APIDB/qryTmpPCAbyPRA.txt")

tf <- file.path("C:/Users/Norville/Documents/spatial_data/APIDB/qryTmpPCAbyPRA2.csv")

rm(dsad)

#Pour charger un jeu de données (par exemple fichier de notes)
#dsad <- read.table(tf, header=TRUE, dec=',')
dsad <- read.csv2(tf, header=TRUE, sep=";")

class(dsad)
head(dsad)

summary(dsad)

pairs(dsad)

#Pour effectuer une analyse en composantes principales sur données
# centrées réduites:

dsad.pca <- PCA(dsad)

# Sur données non centrées-réduites:
dsad.pca <-PCA(dsad,scale.unit=FALSE)

#Pour voir les résultats relatifs aux valeurs propres:

dsad.pca$eig

#Pour les résultats relatifs aux variables:

dsad.pca$var

#Les résultats relatifs aux individus:

dsad.pca$ind

#Les valeurs propres et vecteurs propres:

dsad.pca$svd

# Coef de corrélation entre chacune des variables et les deux
# premières composantes principales:
#round(dsad.pca$var$coord[,1:6],2)

round(dsad.pca$var$coord[,1:5],2)

# Décomposition de la variabilité par axes:

round(dsad.pca$eig,2)

# Distance des individus au centre du nuage: (pour détecter des
# individus remarquables)

round(dsad.pca$ind$dist,2)

# Contribution des individus à la construction des axes

round(dsad.pca$ind$contrib[,1:2],2)

# Contribution des variables à la construction des axes
round(dsad.pca$var$contrib[,1:2],2)

# Pour avoir le cercle des corrélations sur axe 2 et 3
x11()
#dplot(D6.acp, choix='ind', axes=c(2,5))
plot(dsad.pca, choix='ind', axes=c(2,5))
x11()
plot(dsad.pca, choix='var', axes=c(1:3))

# Pour obtenir un dendrogramme
d6.clust <- hclust(dist(d6))
plot(d6.clust)

# strip 
head(dsad)

dsad.clust <- hclust(dist(dsad))
plot(dsad.clust)

