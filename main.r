
#main.r
#script loads, select, analyze and analyze data for one dataset (month)


#TODO
# SETTINGS PREDELAT DO JEDNOHO LISTU, DO EXPORTU PRIDAT MOZNOST "NO"

#c("Islámský stát", "Příliv uprchlíků do Evropy", "Terorismus", "Terorismus, teroristické útoky", "Islám", "Uprchlíci")
#Code for frequency of tags
tags = table(articles$tag)
tags = sort(tags, decreasing = TRUE)
tags[1:10]
art = articles[substr(articles$tag, 1, 5) == "Krimi",]

length(unique(articles$article_id))
length(unique(art$article_id))

#----------------------------SETTINGS----------------------------------------------------------
SETTINGS = list(
MONTH     = 8,            
THRESHOLD = 0,           
#CATEGORY = "zahranicni",
CATEGORY  = "all",
TO_DIVIDE = 10,#transformation of edges weight
#TAGS = "all", #POZOR TAGY UPRAVENY NA KRIMI
TAGS = c("Islámský stát", "Příli uprchlíků do Evropy", "Terorismus", "Terorismus, teroristické útoky", "Islám", "Uprchlíci"),
#TAGS  = "Miloš Zeman",
#TAGS = "Příliv uprchlíků do Evropy",
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


main = function(SETTINGS){
    #----------------------------LOAD DATA---------------------------------------------------------
    relations = read.csv (paste0("./data/relations_2015_", SETTINGS$MONTH,".csv"))
    comments  = read.csv (paste0("./data/comments_2015_", SETTINGS$MONTH,".csv"))
    articles  = read.csv (paste0("./data/articles_2015_", SETTINGS$MONTH,".csv"))
    relationsBackup = relations
    commentsBackup  = comments
    
    comments = commentsBackup
    relations = relationsBackup
    #----------------------------SELECT AND TRANSFROM DATA-----------------------------------------
    relations = selectRelations ( relations, articles, SETTINGS )
    comments  = selectComments ( comments, articles, SETTINGS )
    graph     = transformData ( relations, SETTINGS )
    
    #----------------------------ANALYZE DATA------------------------------------------------------
    generalResults = analyzeGeneral( graph, relations, relationsBackup, SETTINGS )
    #list of each group description, last item of list is a list of group membership
    groupResults   = analyzeGroups ( graph, comments, relations, SETTINGS )
    
    #----------------------------EXPORT DATA-------------------------------------------------------
    exportGeneral( generalResults, SETTINGS )
    exportGroups ( groupResults, SETTINGS )
    
    png(filename=paste0("./output/graphs/", SETTINGS$MONTH, "group_graph.png"))
        drawGraph( graph, groupResults )
    dev.off()
}





#----------------------------analysis of group with other tags------------------------------
b = articles[(articles$tag %in% SETTINGS$TAGS),6]
b = as.character(b)
b = unique(b)


a = articles[!(articles$article_id %in% b),6]
a = as.character(a)
a = unique(a)

data = relationsBackup[relationsBackup$article_id %in% a,] 
data = data[data$category == "zahranicni",] 


out = list()
for( i in  1:length( groups )){
    out[[i]] = describeGroup( graph, groups, comments, data, i )
}
out[[3]]

articles[articles$article_name == "Zeman se při návštěvě Číny setká s ruským prezidentem Putinem",]
