
#main.r
#script loads, select, analyze and analyze data for one dataset (month)
#-----------------------------MAIN SCRIPT--------------------------------------------------------

source("./settings.r")
main = function(SETTINGS){
    #----------------------------REQUIRED PACKAGES-------------------------------------------------
    require(igraph)
    require(plyr)
    
    #----------------------------LOAD FUNCTIONS----------------------------------------------------
    source("./functions/selectData.R")
    source("./functions/transformData.R")
    source("./functions/analyzeGeneral.R")
    source("./functions/analyzeGroups.R")
    source("./functions/analyzeIndividuals.R")
    source("./functions/exportGroups.R")
    source("./functions/exportGeneral.R")
    source("./functions/exportIndividuals.R")
    source("./functions/exportHTML.R")
    source("./functions/drawGraph.R")
    source("./functions/cacheData.R")
    
    #----------------------------LOAD DATA---------------------------------------------------------

    relations = read.csv (paste0("./data/",SETTINGS$YEAR,"/relations_",SETTINGS$YEAR,"_", SETTINGS$MONTH,".csv"))
    comments  = read.csv (paste0("./data/",SETTINGS$YEAR,"/comments_",SETTINGS$YEAR,"_", SETTINGS$MONTH,".csv"))
    articles  = read.csv (paste0("./data/",SETTINGS$YEAR,"/articles_",SETTINGS$YEAR,"_", SETTINGS$MONTH,".csv"))
    relationsBackup = relations
    commentsBackup  = comments
    articlesBackup = articles
    
    #----------------------------SELECT AND TRANSFROM DATA-----------------------------------------
    relations = selectRelations ( relations, articles, SETTINGS )
    comments  = selectComments ( comments, articles, relations, SETTINGS )
    graph     = transformData ( relations, SETTINGS )
    
    #----------------------------ANALYZE DATA------------------------------------------------------
    generalResults = analyzeGeneral( graph, relations, comments, articles, commentsBackup, relationsBackup, articlesBackup, SETTINGS )
    #list of each groups, group description, proximityMatrix, transitionMatrix etc...
     groupResults   = analyzeGroups ( graph, comments, relations, relationsBackup, commentsBackup, SETTINGS )
     individualsReuslts = analyzeIndividuals(graph, comments, relations, SETTINGS)
     
    #----------------------------EXPORT DATA-------------------------------------------------------
    exportGeneral( generalResults, SETTINGS )
     exportGroups ( graph, groupResults, SETTINGS ) #making graphs and exporting to chosen format (HTML)
     exportIndividuals( individualsReuslts, SETTINGS )
     cacheGraph( graph, SETTINGS )
    
}

#analyze more months together
source("./settings.r")
for( i in  5:12){
    SETTINGS$MONTH = i
    SETTINGS = refreshPath(SETTINGS)
    main(SETTINGS)
}
require("tcltk")
button = tkmessageBox(message = "Hotovo!",
                      icon = "question", type = "ok")




