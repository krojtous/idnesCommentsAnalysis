#main.r
#script loads, select, analyze and analyze data for one dataset (month)


#TODO
# SETTINGS PREDELAT DO JEDNOHO LISTU, DO EXPORTU PRIDAT MOZNOST "NO"


#----------------------------SETTINGS----------------------------------------------------------
SETTINGS = list(
MONTH     = 4,            
THRESHOLD = 50,           
CATEGORY  = "zahranicni",    
EXPORT    = "HTML"
)


#----------------------------REQUIRED PACKAGES-------------------------------------------------
require(igraph)
require(plyr)

#----------------------------LOAD FUNCTIONS----------------------------------------------------
source("./functions/selectData.R")
source("./functions/transformData.R")
source("./functions/analyzeGroups.R")
source("./functions/analyzeLeaders.R")
source("./functions/exportGroups.R")


    #----------------------------LOAD DATA---------------------------------------------------------
    relations = read.csv(paste0("./data/relations_2015_",SETTINGS$MONTH,".csv"))
    comments  = read.csv(paste0("./data/comments_2015_",SETTINGS$MONTH,".csv"))
    relationsBackup = relations

    #----------------------------SELECT AND TRANSFROM DATA-----------------------------------------
    relations = selectData ( relations, SETTINGS )
    graph     = transformData ( relations )
    
    #----------------------------ANALYZE DATA------------------------------------------------------
    basicResults = analyzeGeneral ( graph, relations, relationsBackup, SETTINGS )
    groupResults = analyzeGroups( graph, comments, relationsBackup, SETTINGS )
    
    #----------------------------EXPORT DATA-------------------------------------------------------
    exportGroups( groupResults, SETTINGS )

