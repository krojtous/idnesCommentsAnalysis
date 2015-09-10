
#main.r
#script loads, select, analyze and analyze data for one dataset (month)


#TODO
# SETTINGS PREDELAT DO JEDNOHO LISTU, DO EXPORTU PRIDAT MOZNOST "NO"


#Code for frequency of tags
#tags = table(articles$tag)
#tags = sort(tags, decreasing = TRUE)
#tags[1:80]


#----------------------------SETTINGS----------------------------------------------------------
SETTINGS = list(
MONTH     = 8,            
THRESHOLD = 50,           
CATEGORY  = "all",
TO_DIVIDE = 1,#transformation of edges weight
TAGS  = "all", #c("Islámský stát", "Příliv uprchlíků do Evropy", "Terorismus", "Terorismus, teroristické útoky", "Islám", "Uprchlíci"),
GROUPS = 2, #How many groups will be indetified in data
EXPORT    = "HTML"
)


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

for(i in c(5:10,15,20,25)){
    SETTINGS$TO_DIVIDE = i
    threshold(SETTINGS)
}

main = function(SETTINGS){
    #----------------------------LOAD DATA---------------------------------------------------------
    relations = read.csv (paste0("./data/relations_2015_", SETTINGS$MONTH,".csv"))
    comments  = read.csv (paste0("./data/comments_2015_", SETTINGS$MONTH,".csv"))
    articles  = read.csv (paste0("./data/articles_2015_", SETTINGS$MONTH,".csv"))
    relationsBackup = relations
    relations = relationsBackup
    #----------------------------SELECT AND TRANSFROM DATA-----------------------------------------
    relations = selectData ( relations, SETTINGS )
    graph     = transformData ( relations, SETTINGS )
    
    #----------------------------ANALYZE DATA------------------------------------------------------
    generalResults = analyzeGeneral( graph, relations, relationsBackup, SETTINGS )
    groupResults   = analyzeGroups ( graph, comments, relations, SETTINGS )
    
    #----------------------------EXPORT DATA-------------------------------------------------------
    exportGeneral( generalResults, SETTINGS )
    exportGroups ( groupResults, SETTINGS )
}

threshold (SETTINGS)
threshold = function(SETTINGS){
    relations = relationsBackup
    #----------------------------SELECT AND TRANSFROM DATA-----------------------------------------
    relations = selectData ( relations, SETTINGS )
    graph     = transformData ( relations, SETTINGS )
    
    #----------------------------ANALYZE DATA------------------------------------------------------
    generalResults = analyzeGeneral( graph, relations, relationsBackup, SETTINGS )
    
    #----------------------------EXPORT DATA-------------------------------------------------------
    cat(SETTINGS$TO_DIVIDE)
    cat("\n")
    cat(generalResults$V)
    cat("\n")
    cat(generalResults$E)
    cat("\n\n")

}
