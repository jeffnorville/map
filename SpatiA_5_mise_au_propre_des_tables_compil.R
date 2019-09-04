
###########################################################################
# Ce script met au propres les sorties aropaj de type table compil ########
###########################################################################



# PATHS !
#chemin_table_compil = paste(get.pc.folder(),"TABLECOMPIL/", sep = "")
chemin_table_compil = paste("TABLECOMPIL/", sep = "")




# lister les fichiers a traiter -------------------------------------------


# chargement packages
library(foreign)

# on se place dans le dossier contenant les fichiers a traiter
setwd(chemin_table_compil)

# on liste les fichiers table compil de type .txt
fichiers = list.files(pattern = "table.compil")
fichiers = fichiers[grepl(".txt", fichiers)]



# traitement fichier par fichier ------------------------------------------


# on test si fichier n'est pas de longueur nulle
if (length(fichiers) != 0){
  
  # dans ce cas on commence une boucle sur chaque fichier
  fichier = fichiers[1]
  for (fichier in fichiers){
    
    print(paste("traitement de", fichier))
          
          # on copie le fichier a traiter par precaution ... inutile car copie dans TABLECOMPIL
#          dir.create("table_compil_brut")
#          file.copy(from = fichier, to = paste(chemin_table_compil,"/table_compil_brut/",fichier, sep = ""))
          
#          print(paste("sauvegarde faite au nom : ", paste("/table_compil_brut/",fichier, sep = "")))
                
                # chargement du table.compil en cours
                table_compil = read.table(file = fichier, 
                                          skip = 1,
                                          sep = ":",
                                          strip.white = TRUE,
                                          header = TRUE,
                                          fill = TRUE)
                
                # mise au propre !
                
                # on met les bon noms des premieres colonnes
                names(table_compil)[1:4] = c("pays", "gt", "param1", "param2")
                
                # on repere les colonnes avec un nom "nul" (de type "X.") et on les supprime
                colonnes_a_supprimer = which(grepl("X[.]", names(table_compil)))
                table_compil = table_compil[,-colonnes_a_supprimer]
                
                # on va jusqu'a reg  et on prend aussi  sauto + popul + idtypo
                table_compil = table_compil[,c(1:which(names(table_compil) == "Reg"),
                                               which(names(table_compil) == "popul"),
                                               which(names(table_compil) == "sauto"),
                                               which(names(table_compil) == "id_typo"))]
                
                # on rajoute surf_tot
                table_compil$surf_tot = as.numeric(as.vector(table_compil$popul))*as.numeric(as.vector(table_compil$sauto))
                
                
                # on sauvegarde le fichier au meme nom, i.e. on le remplace 
                # (au cas ou une sauvegarde est faite avec le suffixe ".old")
                write.table(table_compil,
                            file = fichier, 
                            quote = FALSE,
                            sep = ":",
                            row.names = FALSE)
                
                print(paste(fichier, "mis au propre"))
                      
                      
  } # fin boucle sur les fichiers
  
# fin du if testant la presence des fichiers
}else {print("Pas de table compil trouve! verifiez la presence des fichiers")}
# si on ne trouve pas de fichiers on l'affiche a l'ecran





