#main.r
#script loads, select, analyze and analyze data for one dataset (month)


#TODO
# SETTINGS PREDELAT DO JEDNOHO LISTU, DO EXPORTU PRIDAT MOZNOST "NO"

#----------------------------SETTINGS----------------------------------------------------------
MONTH     = "07"            #<--- Which month in the year 2015 will be analyzed (in format MM, fo example 03)
THRESHOLD = 100             #<---
CATEGORY  = "zahranicni"    #<---
EXPORT    = "HTML"


#----------------------------REQUIRED PACKAGES-------------------------------------------------
require(igraph)
require(plyr)

#----------------------------LOAD FUNCTIONS----------------------------------------------------
source("./functions/selectData.R")
source("./functions/transformData.R")
source("./functions/analyzeGroups.R")
source("./functions/exportGroups.R")

#----------------------------LOAD DATA---------------------------------------------------------
relations = read.csv(paste0("./data/relations_2015_",MONTH,".csv"))
comments  = read.csv(paste0("./data/comments_2015_",MONTH,".csv"))
relationsBackup = relations
relations = relationsBackup

#----------------------------SELECT AND TRANSFROM DATA-----------------------------------------
relations = selectData ( relations, THRESHOLD, CATEGORY )
graph     = transformData ( relations )

#----------------------------ANALYZE DATA------------------------------------------------------
basicResults = analyzeBasic ( relations, comments )
groupResults = analyzeGroups( graph, comments, relationsBackup, MONTH )

#----------------------------EXPORT DATA-------------------------------------------------------
exportGroups( groupResults, EXPORT, MONTH, THRESHOLD, CATEGORY )

