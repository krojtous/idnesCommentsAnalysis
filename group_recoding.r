
#########################################
#                                       #
#     MANUAL RECODE OF GROUPS NUMBER    #
#                                       #
#########################################

source("./functions/analyzeGroups.R")
source("./functions/exportGroups.R")
source("./functions/cacheData.R")


#RENAME GROUPS MANUALY
#Vector to rename (groups 1:10 rename to VECTOR)
# 1 - protiislámská - hnědá
# 2 - prozápadní - modrá
# 3 - proruská - červená
# 4 - proislámská - zelená
# 5 - prohomosexuální - růžová
# 6 - Barnevernet - fialová
# 7 - jiná - šedá
GROUP_VECTOR = c(1,6,2,3,7,3,7,2,5,7)

recodeAndCacheGroups( groupResults, SETTINGS, GROUP_VECTOR) #<- Do after manual set of GROUP_VECTOR
groupResults   = analyzeGroups ( graph, comments, relations, SETTINGS )
exportGroups ( groupResults, SETTINGS )

png(width = 800, height = 800, filename=paste0("./output/", SETTINGS$YEAR, "/graphs/", SETTINGS$MONTH, "group_graph.png"))
    drawGraph( graph, groupResults, SETTINGS )
dev.off()