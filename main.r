
#main.r
#script loads, select, analyze and analyze data for one dataset (month)


#TODO
# DO EXPORTU PRIDAT MOZNOST "NO"

#c("Islámský stát", "Příliv uprchlíků do Evropy", "Terorismus", "Terorismus, teroristické útoky", "Islám", "Uprchlíci")
#Code for frequency of tags
articles  = read.csv (paste0("./data/articles_2015_6.csv"))
tags = table(articles$tag)
tags = sort(tags, decreasing = TRUE)
tags[1:30]
art = articles[substr(articles$tag, 1, 5) == "Krimi",]

#Boris Němcov, Interfax, Krize na Ukrajině, Krym, NATO, Vladimir Putin

length(unique(articles$article_id))
length(unique(art$article_id))

#----------------------------SETTINGS----------------------------------------------------------
SETTINGS = list(
MONTH     = 3,            
THRESHOLD = 0,           
CATEGORY = "zahranicni",
#CATEGORY  = "all",
TO_DIVIDE = 7,#transformation of edges weight
TAGS = "all", #POZOR TAGY UPRAVENY NA KRIMI
#TAGS = c("Islámský stát", "Příliv uprchlíků do Evropy", "Terorismus", "Terorismus, teroristické útoky",
#         "Islám", "Uprchlíci", "Útok na francouzský týdeník"),
#TAGS  = "Miloš Zeman",
#TAGS = "Příliv uprchlíků do Evropy",
GROUPS = 3, #How many groups will be indetified in data
GROUP_ALG = 1, #1 - random walks, 2 - spinglass (exact number of groups)
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

for( i in  1:8){
    SETTINGS$MONTH = i
    main(SETTINGS)
}
main(SETTINGS)
main = function(SETTINGS){
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
    #png(width = 2000, height = 2000, filename="graf-june-better_resolution.png")
    #   drawGraph( graph, groupResults )
    #dev.off()
    #setEPS()
    #postscript("graf-june2.eps",width=10,height=10)
    #    drawGraph( graph, groupResults )
    #dev.off()
    #svg("graf-june2.svg",width=10,height=10)
     #   drawGraph( graph, groupResults )
    #dev.off()
}



V(subg)
groupResults[[2]]
#--------inverze vah pro výpočet--------------------------
E(graph)$weight = backup
E(graph)$weight = mean(E(graph)$weight)/E(graph)$weight

#--------počítání dalších charakteristik------------------
members = groupResults[[length(groupResults)]]
subg = induced.subgraph(graph, which(membership(members) == 1))
graph.density(subg, loops=FALSE)
centr_degree(subg)$centralization
centr_clo(subg, mode="all")$centralization
centr_eigen(subg, directed=FALSE)$centralization



#---------------------analýza diskurzu---------------------------------

for( i in  1:8){
    SETTINGS$MONTH = i
    discourseAnalyze(SETTINGS)
}

discourseAnalyze = function( SETTINGS ){
    comments  = read.csv (paste0("./data/comments_2015_", SETTINGS$MONTH,".csv"))
    cat(SETTINGS$MONTH)
    cat("\n")
    cat(length( grep("uprchlí", comments[,1])))
    cat("\n")
    cat(length(grep("migrant", comments[,1])))
    cat("\n\n")
}
