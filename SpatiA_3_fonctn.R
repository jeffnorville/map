FromGTtoCellsV1<-function(region,emissionAROPAj,numColPrefix,nomexport=NULL,exportfichier=F)
{
#
#source("ScriptTravail/fonction_emission_v1.txt")
#

#  I M P O R T
# 
# avec le package "foreign" pour les fonctions write.dbf et read.dbf
#

# emissionAROPAj<-read.table("travail/donnees/emissions.txt",header=T)
# 


colDimEmis<- dim(emissionAROPAj)[2]
numCol<- colDimEmis - 3 + 1 
emissionAROPAjReg <-emissionAROPAj[emissionAROPAj[,"Reg"]==region,3:colDimEmis]
nomtoto<-dimnames(emissionAROPAjReg)
emissionAROPAjReg<-matrix(as.numeric(unlist(emissionAROPAjReg)),ncol=numCol)
dimnames(emissionAROPAjReg)<-nomtoto

FirstGtColumn<-numColPrefix + 1 
ProbaGtRegAll<-get(paste("GtEurope",region,sep=""))
ProbaGtReg<-ProbaGtRegAll[ ,FirstGtColumn:(dim(ProbaGtRegAll)[2])]

nomtoto<-dimnames(ProbaGtReg)
if (is.null(dim(ProbaGtReg)))
{
ProbaGtReg<-matrix(as.numeric(unlist(ProbaGtReg)),ncol=1)
} else {
ProbaGtReg<-matrix(as.numeric(unlist(ProbaGtReg)),ncol=dim(ProbaGtReg)[2])
}
dimnames(ProbaGtReg)<-nomtoto
rm(nomtoto)


#  T R A I T E M EN T 

emissionCellules<-(ProbaGtReg%*%emissionAROPAjReg) 

emissionCellules<-cbind(ProbaGtRegAll[,1:numColPrefix ],emissionCellules)

nomfichier<-paste("emissionCellules",region,sep="")
assign(value=emissionCellules,x=nomfichier,pos=1)


#  E X P O R T 

if (exportfichier)
{
	if (is.null(nomexport) )
	{
	nomexport<-paste("GIS_V5_2008/ExportEmissionCellulesArc/Region",region,".dbf",sep="")
	}
#		cat(nomexport)
	write.dbf(dataframe=emissionCellules,file=nomexport)
	
 }

 
}
