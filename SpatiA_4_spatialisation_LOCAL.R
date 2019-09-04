#rm(list=ls())

# appel packages
require(foreign)
require(dplyr)


# PATHS !
#chemin_table_compil = paste("TABLECOMPIL/", sep = "")
#chemin_table_compil = paste("C:/model/INRA/AROPAj/aropaj_runs/simulapismal/test/TABLECOMPIL/", sep = "") #leno
chemin_table_compil = paste("C:/Users/Norville/Documents/AROPAj/2019-04-23/test/TABLECOMPIL/", sep = "") #off

#chemin_GT = paste(get.pc.folder(),"SPATIAL_GT/", sep = "")
#chemin_GT = paste("/home/jayet/miraj/aropaj/V5_2008/probag/probaGT/", sep = "")
#chemin_GT = paste("C:/model/INRA/AROPAj/AROPAJ_code/V5_2008/probaGT/", sep = "") #leno
chemin_GT = paste("C:/Users/Norville/Documents/AROPAj/V5_2008/probaGT/", sep = "") #off


# V5 : chemin vers les shapefiles
#chemin_shp = "/home/jayet/miraj/aropaj/glodata/SHAPEFILES/"
#chemin_shp = "C:/model/INRA/AROPAj/SHAPEFILES/BASE/" #leno
chemin_shp = "C:/Users/Norville/Documents/AROPAj/miraj-aropaj/glodata/SHAPEFILES/" #off

#chemin_arc_simu = paste("CHEMIN", "/arc_simu", sep = "")
chemin_arc_simu = paste(".", "/arc_simu", sep = "")

# lien avec cshell --------------------------------------------------------
# exemple : liste_colonnes_a_garder = c(7:50)
# colonne 7 : margbrut et 175 : consengrais par exemple
liste_colonnes_a_garder = c(32)
# On decale de 6 pour coller avec la liste des variables a traiter
liste_colonnes_a_garder = liste_colonnes_a_garder + 6

#liste_colonnes_a_garder = c(7:50, 100:118, 148:150, 172:175)
# ecriture d'un petit fichier dans arc_simu pour onserver la liste des variables


# FILTRE CHARGEMENT DES GT AVEC (CSHELL : dbfs_info.txt)
regions_cshell = c(100,10,112,113,114,115,116,121,131,132,133,134,135,136,141,151,152,153,162,163,164,182,183,184,192,193,201,203,204,221,222,230,241,242,243,244,250,260,270,281,282,291,292,301,302,303,30,311,312,320,330,341,343,350,360,370,380,411,412,413,421,431,441,450,460,470,480,500,505,50,510,515,520,525,530,535,540,545,550,555,560,565,570,575,60,615,630,640,660,670,680,690,700,70,710,720,730,740,745,755,760,761,762,763,764,765,766,770,775,780,785,790,795,800,80,810,820,831,832,833,834,835,836,840,841,842,843,844,845,846,847,90)

# chargement de tous les fichiers GT pour gagner du temps! ----------------
GT = list()
GT.matrix = list()

# liste des fichiers gtREG.dbf correspondant
liste_fichier_GT = list.files(path = chemin_GT,
                              pattern = paste("Gt", sep = ""))

# ATTENTION : dans liste_fichier_GT : se limiter a ceux du CSHELL
test = sapply(liste_fichier_GT, function(x) strsplit(x, "Gt")[[1]][2])
test = sapply(test, function(x) strsplit(x, "[.]dbf")[[1]][1])
test = as.numeric(test)
indices_a_garder = which(test %in% regions_cshell)
liste_fichier_GT = liste_fichier_GT[indices_a_garder]

# on charge chaque fichier de la liste dans GT
for (nom_gt in liste_fichier_GT){
  
  # chargement
  GT[[nom_gt]] = read.dbf(file = paste(chemin_GT, nom_gt, sep = "/")) #au cas oe plusieurs fichiers...
  
  # consider adding REGION
  # V5 : ajouter la colonne COUNT qui est dans le shapefile
  reg = gsub(".dbf", "", gsub("Gt", "", nom_gt))
  shp = read.dbf(paste0(chemin_shp, reg, "_base.dbf"))
  GT[[nom_gt]] = left_join(shp, GT[[nom_gt]], by = "GRIDCODE")
  
  # on les transforme directement en matrice pour gagner du temps
  # on transforme GT en matrice en ne gardant que l'info sur les probas des GT
  # i.e de (COUNT + 1) ? (NAU - 1)
  #  GT.matrix[[nom_gt]] = as.matrix(GT[[nom_gt]][,(which(names(GT[[nom_gt]]) == "COUNT") + 1):
  #                      (which(names(GT[[nom_gt]]) == "NAU") - 1) ])
  #  class(GT.matrix[[nom_gt]]) = "numeric"
  GT.matrix[[nom_gt]] = as.matrix(GT[[nom_gt]][(which(names(GT[[nom_gt]]) == "COUNT") + 1):ncol(GT[[nom_gt]])]) # Spatialisation V5
  class(GT.matrix[[nom_gt]]) = "numeric"
  
  #on ne garde que GC et COUNT sur la version data frame
  GT[[nom_gt]] = GT[[nom_gt]][c("GRIDCODE","COUNT")]
  
  print(paste("chargement de", nom_gt))
}

# on met des names de GT correspondant au fichier lu
names(GT) = as.vector(sapply(names(GT), function(x) strsplit(strsplit(x, "Gt")[[1]][2], "[.]dbf")[[1]][[1]]))
names(GT.matrix) = names(GT)


# lister les fichiers Ã  traiter -------------------------------------------

# chargement packages
# require(foreign) #in header

# on se place dans le dossier contenant les fichiers ? traiter
#setwd(chemin_table_compil)

# on liste les fichiers table compil de type txt
fichiers = list.files(path = chemin_table_compil,
                      pattern = "table.compil")
fichiers = fichiers[which(grepl(".txt", fichiers))]

# on prend pas norvege suede etc - suupri / inutile
#test = sapply(fichiers, function (x) strsplit(x, "[.]txt")[[1]][1])
#test = as.numeric(sapply(test,  function (x) strsplit(x, "[.]1[.]")[[1]][2]))
#fichiers = fichiers[which(test < 93)]


# creation d'une fonction de spatialisation -------------------------------
# chargee de faire le gros du boulot : un produit matriciel
# elle sera appelee dans la boucle situee plus bas dans le code

spatialisation = function(table_compil_reg_en_cours, GT, GT.matrix){
  
  # on initialise l'arc_simu avec GT et COUNT
  arc_simu = cbind(GT$GRIDCODE, GT$COUNT)
  
  #on enleve l'info Reg e table_compil_reg_en_cours
  table_compil_reg_en_cours$Reg = NULL
  
  # on cree une matrice numerique e partir de table_compil_en_cours
  table_compil_reg_en_cours = as.matrix(table_compil_reg_en_cours)
  class(table_compil_reg_en_cours) = "numeric"
  
  # on colle e notre base arc_simu le produit matriciel !!!
  arc_simu = cbind(arc_simu, as.data.frame(GT.matrix %*% table_compil_reg_en_cours))
  
  #on remet le bon nom des colonnes 1 et 2 qui se perd lors du bind
  names(arc_simu)[1:2] = c("GRIDCODE", "COUNT")
  
  # on renvoie le arc_simu cree
  return(arc_simu)
  
} # fin fonction de spatialisation


# spatialisation fichier par fichier ---------------------------------------

# on test si "fichiers" n'est pas de longueur nulle
if (length(fichiers) != 0){
  
  fichier = fichiers[1]
  # dans ce cas on commence une boucle sur chaque fichier
  for(fichier in fichiers){
    
    print(paste("traitement de", fichier))
    
    # on charge le fichier, cad le table compil e spatialiser
    table_compil = read.table(file = paste(chemin_table_compil, fichier, sep = ""), 
                              sep = ":",
                              strip.white = TRUE,
                              header = TRUE,
                              fill = TRUE)
    # si on en est au premier table compil
    # ecrire la liste des variables en .txt
    # if (fichier == fichiers[1]){
    # var = names(table_compil)[liste_colonnes_a_garder]
    # for (i in 1:length(var)){
    # var[i] = paste(i, "=", var[i], sep = "")
    # }
    # 
    # write.table(var, file = "arc_simu/liste_variables.txt", sep = ":")
    # }
    
    # on met tout en par hectare en divisant par surf_tot !!!
    table_compil[,liste_colonnes_a_garder] =  table_compil[,liste_colonnes_a_garder]/table_compil$surf_tot
    
    # on en extrait la sous-partie que l'utilisateur nous a demande de garder
    # ainsi que reg dont on aura besoin
    table_compil = table_compil[,c(liste_colonnes_a_garder, 
                                   which(names(table_compil) == "Reg"))]
    
    # on repere les differentes regions e traiter           
    regions_table_compil = unique(table_compil$Reg)
    
    # On intersecte la liste des regions table_compil et du dbfinfo (issu du CSHELL)
    regions = intersect(regions_table_compil, regions_cshell)
    
    # boucle sur chaque region pour creer le arc_simu -------------------------
    for (region in regions){
      
      print(paste("region en cours :", region))
      
      # on teste si on a bien un fichier GT.dbf (pb region 100...) eee obsolete avec dbfs_info eee (PA)
      if (  region < 1000
      ){
        
        # on extrait la partie de table compil qui nous interesse
        table_compil_reg_en_cours = table_compil[which(table_compil$Reg == region),]
        
        # spatialisation et creation du arc_simu!!! e partir de GT et de table compil
        arc_simu = spatialisation(table_compil_reg_en_cours, 
                                  GT[[which(names(GT) == region)]],
                                  GT.matrix[[which(names(GT.matrix) == region)]])
        
        # on ecrit l'arc_simu
        nom_arc_simu = strsplit(fichier, split = "compil")[[1]][2]
        nom_arc_simu = strsplit(nom_arc_simu, split = "[.]txt")[[1]][1]
        nom_arc_simu = paste("Arc", nom_arc_simu, ".region", region, ".csv", sep = "")
        
        write.table(arc_simu,
                    file = paste(chemin_arc_simu, nom_arc_simu, sep = "/"),
                    quote = FALSE,
                    sep = ":",
                    row.names = FALSE)
        
        print(paste(nom_arc_simu, "cree"))
        
      } # fin teste si GT present
    } #fin boucle sur les regions
    
  } # fin boucle sur les fichiers
  
  # fin du if testant la presence des fichiers
  # si on ne trouve pas de fichiers on l'affiche e l'ecran
}else {print("Pas de table compil trouve! verifiez la presence des fichiers")}


### END
