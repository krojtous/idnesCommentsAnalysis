
#main.r
#script loads, select, analyze and analyze data for one dataset (month)
#-----------------------------MAIN FUNCTION--------------------------------------------------------


main = function(SETTINGS){
    source("./settings.r")
    #----------------------------REQUIRED PACKAGES-------------------------------------------------
    require(igraph)
    require(plyr)
    
    #----------------------------LOAD FUNCTIONS----------------------------------------------------
    source("./functions/selectData.R")
    source("./functions/transformData.R")
    source("./functions/analyzeGeneral.R")
    source("./functions/analyzeGroups.R")
    #source("./functions/analyzeLeaders.R")
    source("./functions/exportGroups.R")
    source("./functions/exportGeneral.R")
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
    comments  = selectComments ( comments, articles, SETTINGS )
    graph     = transformData ( relations, SETTINGS )
    
    #----------------------------ANALYZE DATA------------------------------------------------------
    generalResults = analyzeGeneral( graph, relations, comments, articles, commentsBackup, relationsBackup, articlesBackup, SETTINGS )
    #list of each group description, last item of list is a list of group membership
    groupResults   = analyzeGroups ( graph, comments, relations, SETTINGS )
    
    #----------------------------EXPORT DATA-------------------------------------------------------
    exportGeneral( generalResults, SETTINGS )
    exportGroups ( groupResults, SETTINGS )
    cacheGraph( graph, SETTINGS )
    
    #########################################
    #                                       #
    #     MANUAL RECODE OF GROUPS NUMBER    #
    #                                       #
    #########################################
    
    cacheGroups( groupResults, SETTINGS ) #<- Do after manual recode of groups number
    
    png(width = 800, height = 800, filename=paste0("./output/", SETTINGS$YEAR, "/graphs/", SETTINGS$MONTH, "group_graph.png"))
       drawGraph( graph, groupResults, SETTINGS )
    dev.off()
}

for( i in  1:8){
    SETTINGS$MONTH = i
    main(SETTINGS)
}

main(SETTINGS)




