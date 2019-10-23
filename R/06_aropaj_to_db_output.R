#spatialisation only to DB

# working directory
wd <- list()
# commonly used paths in my working directory
wd$data   <- "C:/Users/Jeff Norville/Documents/R/map/data/"
wd$output <- "C:/Users/Jeff Norville/Documents/R/map/output/"

#rm(list=ls())

# appel packages
require(foreign)
require(dplyr)
#motivation over sf and rpostgres etc https://journal.r-project.org/archive/2018/RJ-2018-025/RJ-2018-025.pdf
require(rpostgis)

#nb - rstudio picks up from .renviron file at launch of program - variable cannot be redefined w/o relaunch (or at least reload) of .renviron file
#point of this is to keep passwords, etc, unique to local instance of program (and off of source control evidently)
gethost     <- Sys.getenv("dbhost")
getdbname <- Sys.getenv("dbname")
getusername <- Sys.getenv("user")
getpassword <- Sys.getenv("passwd")

# isPostgresqlIdCurrent(conVega) #boolean, checks if postgres instance is alive
# pgPostGIS(conVega) #check that postgis is installed in db

# database
con  <-  dbConnect("PostgreSQL",
                   dbname = getdbname,
                   host   = gethost,
                   user   = getusername,
                   password = getpassword)
# isPostgresqlIdCurrent(con) #boolean, checks if postgres instance is alive
# pgPostGIS(con) #check that postgis is installed in db

# define queries
select_gtlist <- "SELECT * FROM information_schema.tables WHERE table_schema = 'aropaj' AND table_name like 'gt%'"
tbls_aropaj <- dbGetQuery(con, select_gtlist)
#tbls_aropaj$table_name

# PATHS !
#chemin_table_compil = paste("TABLECOMPIL/", sep = "")
# chemin_table_compil = paste("C:/model/INRA/AROPAj/aropaj_runs/simulapismal/test/TABLECOMPIL/", sep = "") #leno
# chemin_table_compil = paste("C:/model/INRA/AROPAj/aropaj_runs/simulapismal/testafsh/map/", sep = "") #leno
chemin_table_compil = paste("C:/Users/Norville/Documents/AROPAj/VM_test/", sep = "") #VM test run

# chemin_table_compil = paste("C:/Users/Norville/Documents/AROPAj/2019-09-19_testafsh/TABLECOMPIL/map/", sep = "") #office

# chemin_table_compil = paste("/home/jnorville/aropaj_tablecompil/", sep = "") #vega

#chemin_GT = paste("/home/jayet/miraj/aropaj/V5_2008/probag/probaGT/", sep = "")
# chemin_GT = paste("C:/model/INRA/AROPAj/AROPAJ_code/V5_2008/probaGT/", sep = "") #leno
chemin_GT = paste("C:/Users/Norville/Documents/AROPAj/V5_2008/probaGT/", sep = "") #office
# chemin_GT = paste("/home/jnorville/miraj/probaGT/", sep = "") # vega
# chemin_table_compil = paste("C:/Users/Norville/Documents/AROPAj/2019-09-19_testafsh/TABLECOMPIL/map/", sep = "") #office
# chemin_table_compil = paste("/home/jnorville/aropaj_tablecompil/", sep = "") #vega

#chemin_GT = paste("/home/jayet/miraj/aropaj/V5_2008/probag/probaGT/", sep = "")
# chemin_GT = paste("C:/model/INRA/AROPAj/AROPAJ_code/V5_2008/probaGT/", sep = "") #leno
# chemin_GT = paste("C:/Users/Norville/Documents/AROPAj/V5_2008/probaGT/", sep = "") #office
# chemin_GT = paste("/home/jnorville/miraj/probaGT/", sep = "") # vega

# V5 : chemin vers les shapefiles
#chemin_shp = "/home/jayet/miraj/aropaj/glodata/SHAPEFILES/"
# chemin_shp = "C:/model/INRA/AROPAj/SHAPEFILES/BASE/" #leno
chemin_shp = "C:/Users/Norville/Documents/AROPAj/miraj-aropaj/glodata/SHAPEFILES/" #office
# chemin_shp = "/home/jnorville/miraj/SHAPEFILES/"
# chemin_shp = "C:/Users/Norville/Documents/AROPAj/miraj-aropaj/glodata/SHAPEFILES/" #office
# chemin_shp = "/home/jnorville/miraj/SHAPEFILES/"# vega 

# lien avec cshell --------------------------------------------------------
# exemple : liste_colonnes_a_garder = c(7:50)
# colonne 7 : margbrut et 175 : consengrais par exemple
# On decale de 6 pour coller avec la liste des variables a traiter
liste_colonnes_a_garder = c(32)
liste_colonnes_a_garder = liste_colonnes_a_garder + 6
# liste_colonnes_a_garder = c(32)
# liste_colonnes_a_garder <- 8 #forcing surfbled
# liste_colonnes_a_garder <- 38 #forcing surfperm
# liste_colonnes_a_garder <- 39 # surfaufo
# liste_colonnes_a_garder <- 21 # surfcolz
# liste_colonnes_a_garder <- 13 #surfauce
# liste_colonnes_a_garder <- 201 ## which(names(table_compil)=='surfafsh')
# liste_colonnes_a_garder <- c(8, 13, 21, 38, 39, 201) #surfafsh
# get colnames, a little cleaner  -------------------------------
keepers <- c('margbrut','surfbled','surfblet','surforgh','surforgp',
             'surfavoi','surfauce','surfseig','surfriz','surfmais',
             'surfbett','surftaba','surfcoto','surflinc','surfcolz',
             'surftour','surfsoja','surfprot','surffeve','surflgsv',
             'surffric','surfgelv','surfpdtr','surflegf','surfbtfo',
             'surfmafo','surfluze','surffpro','surfperm','surfaufo',
             'surfxxxx','surfener','surfgl49','surfmisc','surfswit',
             'surfeuca','surfrobi','surfpeup','surfsaul','surfafsh', 'emiss23T', 'popul','sauto')
# which(names(table_compil)=='popul')
# longer list -- ATTN this can change !
# [1] "X"        "X.1"      "X0"       "X0.1"     "c1"       "c2"       "margbrut" "surfbled"
# [9] "surfblet" "surforgh" "surforgp" "surfavoi" "surfauce" "surfseig" "surfriz"  "surfmais"
# [17] "surfbett" "surftaba" "surfcoto" "surflinc" "surfcolz" "surftour" "surfsoja" "surfprot"
# [25] "surffeve" "surflgsv" "surffric" "surfgelv" "gelms2pr" "gelms2np" "foretjac" "surfpdtr"
# [33] "surflegf" "surfbtfo" "surfmafo" "surfluze" "surffpro" "surfperm" "surfaufo" "surfxxxx"
# [41] "surfener" "intrabld" "intrablt" "intraogh" "intraogp" "intraavo" "intraauc" "intrasei"
# [49] "intraxxx" "intramai" "alimache" "alimaghe" "alimacpc" "alimagpc" "alimacvo" "alimagvo"
# [57] "alimactt" "alimagtt" "animvbbt" "animvbbe" "animve2m" "animvmgr" "animvedt" "animvedb"
# [65] "animfnrl" "animfnrv" "animfare" "animveat" "animveab" "animvfal" "animvfav" "animtaie"
# [73] "animtaac" "animm1eb" "animm1ab" "animf1el" "animf1ev" "animf1al" "animf1av" "animbeie"
# [81] "animbeac" "animgnlv" "animgnvv" "animvlai" "animvnou" "animovin" "animcapr" "animporc"
# [89] "animvola" "pbrutani" "effecugb" "depalima" "feogahrs" "depaACHE" "depaACPC" "depaACVL"
# [97] "depaAGHE" "depaAGPC" "depaAGVL" "collbled" "collblet" "collorgh" "collorgp" "collavoi"
# [105] "collauce" "collseig" "collriz"  "collmais" "collcolz" "colltour" "collbetC" "collbett"
# [113] "collpdtr" "collsoja" "collprot" "collfeve" "colllgsv" "colllait" "dualqola" "emiss01C"
# [121] "emiss02C" "emiss03C" "emiss04C" "emiss04S" "emiss05C" "emiss06C" "emiss07C" "emiss07S"
# [129] "emiss07T" "emiss08C" "emiss09C" "emiss10C" "emiss10S" "emiss11C" "emiss12C" "emiss13C"
# [137] "emiss14C" "emiss14T" "emiss15C" "emiss16C" "emiss17C" "emiss17S" "emiss18C" "emiss19C"
# [145] "emiss20C" "emiss21C" "emiss21T" "emissN2O" "emissCH4" "emiss22T" "emissCAR" "emiss23T"
# [153] "dualterr" "varbidon" "bfeoga02" "bfeoga03" "bfeoga04" "bfeoga05" "bfeoga06" "bfeoga07"
# [161] "bfeoga08" "bfeoga09" "bfeoga10" "bfeoga11" "bfeoga12" "bfeoga13" "bfeoga14" "bfeoga15"
# [169] "bfeoga16" "bfeoga17" "bfeoga18" "soldfeog" "surfgl49" "emipoN2O" "emipoNO3" "emipoNH3"
# [177] "consengr" "surfmisc" "surfswit" "surfeuca" "surfrobi" "surfpeup" "surfsaul" "collmisc"
# [185] "collswit" "colleuca" "collrobi" "collpeup" "collsaul" "collluze" "collcobl" "collcobd"
# [193] "collcooh" "collcoav" "collcoca" "collcose" "collcoma" "collcocz" "collcotr" "collcosj"
# [201] "ecaMINCL" "duaMINCL" "ecaMINYC" "duaMINYC" "ecaMAXCN" "duaMAXCN" "ecaMAXQG" "duaMAXQG"
# [209] "X.2"      "X.3"      "Reg"      "n_Reg"    "Pay"      "n_Pay"    "n_UE"     "C2"      
# [217] "C1"       "id_typo"  "pay_aro"  "n_UE.1"   "X.4"      "popul"    "X.5"      "sauto" 


#liste_colonnes_a_garder = c(7:50, 100:118, 148:150, 172:175)
# ecriture d'un petit fichier dans arc_simu pour onserver la liste des variables


# FILTRE CHARGEMENT DES GT AVEC (CSHELL : dbfs_info.txt)
regions_cshell = c(100,10,112,113,114,115,116,121,131,132,133,134,135,136,141,151,152,153,162,163,164,182,183,184,192,193,201,203,204,221,222,230,241,242,243,244,250,260,270,281,282,291,292,301,302,303,30,311,312,320,330,341,343,350,360,370,380,411,412,413,421,431,441,450,460,470,480,500,505,50,510,515,520,525,530,535,540,545,550,555,560,565,570,575,60,615,630,640,660,670,680,690,700,70,710,720,730,740,745,755,760,761,762,763,764,765,766,770,775,780,785,790,795,800,80,810,820,831,832,833,834,835,836,840,841,842,843,844,845,846,847,90)

# chargement de tous les fichiers GT pour gagner du temps! ----------------
GT = list()
GT.matrix = list()

# TODO cleanup, should get this list from DB too
# liste des fichiers gtREG.dbf correspondant
liste_fichier_GT = list.files(path = chemin_GT,
                              pattern = paste("Gt", sep = ""))

liste_db_GT <- tbls_aropaj$table_name

# ATTENTION : dans liste_fichier_GT : se limiter a ceux du CSHELL
test = sapply(liste_fichier_GT, function(x) strsplit(x, "Gt")[[1]][2])
test = sapply(test, function(x) strsplit(x, "[.]dbf")[[1]][1])
test = as.numeric(test)
indices_a_garder = which(test %in% regions_cshell)
liste_fichier_GT = liste_fichier_GT[indices_a_garder]

#let's load this from same postgresql con instead of filesystem !
# define queries
# select_gtlist <- "SELECT * FROM information_schema.tables WHERE table_schema = 'aropaj' AND table_name like 'gt%'"
# tbls_aropaj <- dbGetQuery(con, select_gtlist)
# get reg and shp here
for (gtid in liste_db_GT){
  qry_build_gt_matrix <- paste0("SELECT * FROM aropaj.", gtid, "; ")
  tmp <- dbGetQuery(con, qry_build_gt_matrix)
  tmp$gid <- NULL
  GT[[gtid]] <- tmp
  reg <- gsub("gt", "", gtid)
  # faster to read in one table I suspect -- TODO write one big union
  shp <- dbReadDataFrame(con, c("aropaj", paste0(reg, "_base")))
  shp$geom <- NULL #RS-DBI driver warning: (unrecognized PostgreSQL field type geometry (id:27286) in column 3)
  GT[[gtid]] <- left_join(shp, GT[[gtid]], by = "gridcode")    
  # brings in extra field, gid.y from db; strip ?
  GT.matrix[[gtid]] <- as.matrix(GT[[gtid]][(which(names(GT[[gtid]]) == "count") + 1):ncol(GT[[gtid]])]) # Spatialisation V5
  
  GT[[gtid]] <- GT[[gtid]][c("gridcode","count")] #re-attach for indexing
  print(paste("loaded db ", gtid))
}

# GT.matrix is big
print("before names(GT)")

# on met des names de GT correspondant au fichier lu

# TODO verify matrix sim
# names(GT) <- as.vector(sapply(names(GT), function(x) strsplit(strsplit(x, "Gt")[[1]][2], "[.]dbf")[[1]][[1]]))
# names(GT.matrix) <- names(GT)
names(GT) <- as.vector(sapply(names(GT), function(x) strsplit(x, "gt")[[1]][2]))
names(GT.matrix) <- names(GT)

# picking up aropaj outfiles for DB
fichiers = list.files(path = chemin_table_compil,
                      pattern = "table.compil")
fichiers = fichiers[which(grepl(".txt", fichiers))]

# this is a bit ugly - depends on filenames coming in, call it Hack v0.1?
# get the unique name of this aropaj run from filename
# aropajsimname <- fichiers[1] #from first file
# aropajsimname <- substr(aropajsimname, 14, nchar(aropajsimname)-8) 
# #filename too long for postgresql, strip the first 28 bytes:
# aropajsimname <- gsub("aropascen_V5_2008_jnorville_", "", aropajsimname)
# aropajsimname <- gsub("aropascen_V5_2008_jayet_", "", aropajsimname)
# aropajsimname <- gsub("\\.", "", aropajsimname) #strip points
# aropajsimname <- tolower(aropajsimname) # has to be lowercase to be passed as varname :table later

print(paste("drop existing table aropajoutput"))
# check if table exists, overwrite if so
dbDrop(con,
       name = c("tomap", "aropajoutput"),
       type = "table",
       ifexists = TRUE, #Do not throw an error if the object does not exist. A notice is issued in this case
       exec = TRUE)

# creation d'une fonction de spatialisation -------------------------------
# chargee de faire le gros du boulot : un produit matriciel
# elle sera appelee dans la boucle situee plus bas dans le code

spatialisation = function(table_compil_reg_en_cours, GT, GT.matrix){
  # on initialise l'arc_simu avec GT et COUNT
  # arc_simu = cbind(GT$GRIDCODE, GT$COUNT)
  arc_simu <- cbind(GT$gridcode, GT$count)
  #on enleve l'info Reg e table_compil_reg_en_cours
  table_compil_reg_en_cours$Reg = NULL
  # on cree une matrice numerique e partir de table_compil_en_cours
  table_compil_reg_en_cours <- as.matrix(table_compil_reg_en_cours)
  numtbl_compil_reg_en_cours <- as.numeric(table_compil_reg_en_cours)
  numtbl_compil_reg_en_cours <- as.matrix(table_compil_reg_en_cours)
  
  # on colle e notre base arc_simu le produit matriciel !!!
  arc_simu = cbind(arc_simu, as.data.frame(GT.matrix %*% numtbl_compil_reg_en_cours))
  #on remet le bon nom des colonnes 1 et 2 qui se perd lors du bind
  names(arc_simu)[1:2] = c("GRIDCODE", "COUNT")
  # on renvoie le arc_simu cree
  return(arc_simu)
} # fin fonction de spatialisation

# spatialisation fichier par fichier ---------------------------------------
print("before parsing textfiles")
# on test si "fichiers" n'est pas de longueur nulle
if (length(fichiers) != 0){
  
  fichier = fichiers[1]
  # dans ce cas on commence une boucle sur chaque fichier
  for(fichier in fichiers){
    
    print(paste("traitement de ", fichier))
    print(paste("liste_colonnes_a_garder ", liste_colonnes_a_garder))
    print(paste("keepers ", keepers))
    
    #check to see if file went through "mis a propre" script or not:
    filename <- paste(chemin_table_compil, fichier, sep = "")
    firstline <- readLines(filename, 1L)
    
    if (identical(substr(firstline, 1, 11),"Compilation")) {
      print(paste("un-cleaned ", filename, ", reading from 2nd line"))
      # on charge le fichier, cad le table compil e spatialiser
      table_compil = read.table(filename, 
                                sep = ":",
                                skip = 1, #new JN, solves 'more columnes than columnames' err
                                strip.white = TRUE,
                                header = TRUE,
                                fill = TRUE)
      # on met les bon noms des premieres colonnes
      names(table_compil)[1:4] <- c("pays", "gt", "param1", "param2")
      # on repere les colonnes avec un nom "nul" (de type "X.") et on les supprime
      colonnes_a_supprimer <- which(grepl("X[.]", names(table_compil)))
      table_compil <- table_compil[,-colonnes_a_supprimer]
      # on va jusqu'a reg  et on prend aussi  sauto + popul + idtypo
      table_compil <- table_compil[,c(1:which(names(table_compil) == "Reg"),
                                      which(names(table_compil) == "popul"),
                                      which(names(table_compil) == "sauto"),
                                      which(names(table_compil) == "id_typo"))]
      # on rajoute surf_tot
      table_compil$surf_tot <- as.numeric(as.vector(table_compil$popul))*as.numeric(as.vector(table_compil$sauto))
      
    }
    else if (identical(substr(firstline, 1, 4), "pays")){
      print(paste("file ", filename, " already cleaned, reading from 1ere line"))
      table_compil = read.table(filename, 
                                sep = ":",
                                strip.white = TRUE,
                                header = TRUE,
                                fill = TRUE)
    }
    else {
      print(paste("unexpected file format in ", filename))
    }
    
    #NB unit change here
    # if you see  Error: $ operator is invalid for atomic vectors
    # ... this error comes when df doesn't have names(table_compile) - depending on aropaj run there could be two file formats, clean or uncleaned
    # on met tout en par hectare en divisant par surf_tot !!!
    # table_compil[,liste_colonnes_a_garder] =  table_compil[,liste_colonnes_a_garder]/(table_compil$sauto*table_compil$popul)
    table_compil[,keepers] <- table_compil[,keepers]/(table_compil$sauto*table_compil$popul)
    
    # on en extrait la sous-partie que l'utilisateur nous a demande de garder
    # ainsi que reg dont on aura besoin
    table_compil <- table_compil[,c(keepers, "Reg")]
    # table_compil = table_compil[,c(keepers, 
    #                                which(names(table_compil) == "Reg"))]
    
    # on repere les differentes regions e traiter           
    regions_table_compil = unique(table_compil$Reg) #dplyr intersect does unique() in the next step anyway?
    
    # On intersecte la liste des regions table_compil et du dbfinfo (issu du CSHELL)
    regions <- intersect(regions_table_compil, regions_cshell)
    
    # boucle sur chaque region pour creer le arc_simu (and write to tomap schema) -------------------------
    for (region in regions){
      
      print(paste("region en cours :", region))
      
      # on teste si on a bien un fichier GT.dbf (pb region 100...) eee obsolete avec dbfs_info eee (PA)
      if (region < 1000){
        # on extrait la partie de table compil qui nous interesse
        table_compil_reg_en_cours = table_compil[which(table_compil$Reg == region),]
        
        # spatialisation et creation du arc_simu!!! e partir de GT et de table compil
        arc_simu = spatialisation(table_compil_reg_en_cours, 
                                  GT[[which(names(GT) == region)]],
                                  GT.matrix[[which(names(GT.matrix) == region)]])
        
        # on ecrit le fichier arc_simu
        # nom_arc_simu = strsplit(fichier, split = "compil")[[1]][2]
        # nom_arc_simu = strsplit(nom_arc_simu, split = "[.]txt")[[1]][1]
        # nom_arc_simu = paste("Arc", nom_arc_simu, ".region", region, ".csv", sep = "")
        
        #substr just simulation series out
        simulation_seq <- substr(fichier, nchar(fichier)-7, nchar(fichier)-6)
        simulation_seq <- as.numeric(gsub("\\.", "", simulation_seq))
        print(paste("debug: file ", fichier, ", seq ", simulation_seq))
        # print(paste("debug:  seq as.numeric ", simulation_seq))
        
        #cut out to focus on db
        # write.table(arc_simu,
        #             file = paste(chemin_arc_simu, nom_arc_simu, sep = "/"),
        #             quote = FALSE,
        #             sep = ":",
        #             row.names = FALSE)
        # print(paste(nom_arc_simu, " cree"))
        
        # if db then
        # need gridcode AND region AND simulsequence for db
        arc_simu$region <- region
        # add column w realisation sequence
        arc_simu$simul <- simulation_seq
        # add data/time etc here
        arc_simu$timestamp <- as.POSIXct(Sys.time())
        
        pgInsert(con, 
                 c("tomap", "aropajoutput"), 
                 arc_simu, 
                 geom = FALSE, 
                 df.mode = FALSE, #was FALSE
                 partial.match = FALSE, 
                 overwrite = FALSE, 
                 new.id = NULL,
                 row.names = FALSE, 
                 upsert.using = NULL, 
                 alter.names = FALSE,
                 encoding = NULL, 
                 return.pgi = FALSE, 
                 df.geom = NULL,
                 geog = FALSE)        
        
        print(paste("reg ", region, ", seq ", simulation_seq, " added to db"))
        
      } # fin teste si GT present
    } #fin boucle sur les regions
    
  } # fin boucle sur les fichiers
  
  # fin du if testant la presence des fichiers
  # si on ne trouve pas de fichiers on l'affiche e l'ecran
}else {print("Pas de table compil trouve! verifiez la presence des fichiers")}


### END
