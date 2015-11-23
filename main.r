
#main.r
#script loads, select, analyze and analyze data for one dataset (month)

#----------------------------SETTINGS----------------------------------------------------------
SETTINGS = list(
#---SELECT AND TRANSFORMATION DATA SETTINGS
    MONTH     = 10,            
    THRESHOLD = 0,           
    CATEGORY = "zahranicni",
    #CATEGORY  = "all",
    TO_DIVIDE = 7,#transformation of edges weight
    TAGS = "all", #POZOR TAGY UPRAVENY NA KRIMI
    #TAGS = c("Islámský stát", "Příliv uprchlíků do Evropy", "Terorismus", "Terorismus, teroristické útoky",
    #         "Islám", "Uprchlíci", "Útok na francouzský týdeník"),
    #TAGS  = "Miloš Zeman",
    #TAGS = "Příliv uprchlíků do Evropy",

#---CLUSTERING SETTINGS
    SIZE_OF_GROUP = 5, #how big should be the smallest analzyed subgroup
    GROUPS = 3, #How many groups will be indetified in data
    GROUP_ALG = 1, #1 - random walks, 2 - spinglass (exact number of groups)
    GROUP_COLORS = c("red","green","blue", "orange", "grey", "brown", "purple", "black", "white"),

#---EXPORT SETTINGS
    EXPORT    = "HTML"
)



#-----------------------------MAIN FUNCTION--------------------------------------------------------

main = function(SETTINGS){
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
    
    #----------------------------LOAD DATA---------------------------------------------------------
    relations = read.csv (paste0("./data/relations_2015_", SETTINGS$MONTH,".csv"))
    comments  = read.csv (paste0("./data/comments_2015_", SETTINGS$MONTH,".csv"))
    articles  = read.csv (paste0("./data/articles_2015_", SETTINGS$MONTH,".csv"))
    relationsBackup = relations
    commentsBackup  = comments
    articlesBackup = articles
    
    articles = articlesBackup
    comments = commentsBackup
    relations = relationsBackup
    
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
    
    png(width = 800, height = 800, filename=paste0("./output/graphs/", SETTINGS$MONTH, "group_graph.png"))
       drawGraph( graph, groupResults )
    dev.off()
}

for( i in  1:8){
    SETTINGS$MONTH = i
    main(SETTINGS)
}

main(SETTINGS)




