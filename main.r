#main.r
#script loads, select, analyze data for one dataset (month)

#----------------------------REQUIRED PACKAGES-------------------------------------------------
require(igraph)
require(plyr)

#----------------------------LOAD FUNCTIONS----------------------------------------------------
source("/media/matous/A4E0A47DE0A456F8/Dokumenty/R/idnesCommentsAnalysis/selectData.R")
source("/media/matous/A4E0A47DE0A456F8/Dokumenty/R/idnesCommentsAnalysis/transformData.R")
source("/media/matous/A4E0A47DE0A456F8/Dokumenty/R/idnesCommentsAnalysis/analyzeGroups.R")

#----------------------------LOAD DATA---------------------------------------------------------
relations = read.csv("/media/matous/A4E0A47DE0A456F8/Dokumenty/Sociologie/Diplomová práce/Data/Relations/relations_2015_06.csv")
comments  = read.csv("/media/matous/A4E0A47DE0A456F8/Dokumenty/Sociologie/Diplomová práce/Data/Relations/comments_2015_06.csv")
relationsBackup = relations
relations = relationsBackup

#----------------------------SELECT AND TRANSFROM DATA-----------------------------------------
relations = selectData ( relations, 100, "zahranicni" )
graph     = transformData ( relations )

#----------------------------ANALYZE DATA------------------------------------------------------
basicResults = analyzeBasic ( relations, comments )
groupResults = analyzeGroups( graph, comments, relationsBackup )

#----------------------------EXPORT DATA-------------------------------------------------------
#TO DO

