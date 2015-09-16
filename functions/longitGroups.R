#longitGroups.R

groupResults1 = getGroupResults(SETTINGS)
SETTINGS$MONTH = SETTINGS$MONTH + 1
groupResults2 = getGroupResults(SETTINGS)
CompareTwoGroupsAnalysis( groupResults1, groupResults2 )


getGroupResults = function(SETTINGS){
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
    #list of each group description, last item of list is a list of group membership
    groupResults   = analyzeGroups ( graph, comments, relations, SETTINGS )
    return = groupResults
}

#----------------------------CompareTwoGroupsAnalysis------------------------
CompareTwoGroupsAnalysis = function( groupResults1, groupResults2 ){
    g1 = membership(groupResults1[[length(groupResults1)]])   
    g1 = t(rbind(names(g1),g1))
    g1 = data.frame(g1)
    names(g1) = c("id", "group1")
    
    g2 = membership(groupResults2[[length(groupResults2)]])
    g2 = t(rbind(names(g2),g2))
    g2 = data.frame(g2)
    names(g2) = c("id", "group2")
    
    merged = merge(x = g1, y = g2, by = "id", all = TRUE)
    
    merged[, 1] = as.integer(merged[, 1])
    
    
    merged[is.na(merged)] = 0
    table(merged$group1, merged$group2)
}