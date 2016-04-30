#---------------------basicStats---------------------------
analyzeGeneral = function( graph, 
                           relations, 
                           comments, 
                           articles, 
                           commentsBackup, 
                           relationsBackup, 
                           articlesBackup, 
                           SETTINGS ){
    #----Zobrazi zakladni statistiky (počet komentářů, užeivatelů a vztahů) 
    #----a hsitogram počtu vztahů (log10)
    relations = relations[!is.na(relations$commenting_person_id),]  #Remove rows with NA
    
    #stats before selecting data
    beforeSelect = statsBeforeSelect(articlesBackup, commentsBackup, relationsBackup)
    
    #stats after selecting data
    afterSelect = statsAfterSelect(graph, comments, articles, relations, SETTINGS)
    
    #draw grpahs
    drawBasicGraphs(graph, relationsBackup, relations, SETTINGS)
    
    return = list(
        afterSelect = afterSelect,
        beforeSelect = beforeSelect
    )
}


#-----------------------statsBeforeSelect-----------------------------
statsBeforeSelect = function(articlesBackup, commentsBackup, relationsBackup){
    
    
    return = list(
    commentsN   = nrow(commentsBackup),
    relationsN  = nrow(relationsBackup),
    articlesN   = length( unique(articlesBackup[,6]) ),
    usersN      = length( unique(c(commentsBackup[,2], relationsBackup[,8])) )
    )
    
}


#---------------------statsAfterSelect----------------------------------
statsAfterSelect = function(graph, comments, articles, relations, SETTINGS){
  #invesrse wights of graph because of betweeness
  graphInv = graph
  E(graphInv)$weight = 1/E(graph)$weight
  
    return = list(
        usersN      = length(V(graph)),
        E           = length(E(graph)),
        sumWeightEdges = sum(E(graph)$weight),
        density     = graph.density(graph),
        commentsN   = nrow(comments),
        relationsN  = nrow(relations),
        relationsNPos = nrow(relations[which(relations$positive_reaction == 1),]),
        articlesN   = length ( unique(as.character(comments[,'article_id'])) ),
        centrality_deg = centralization.degree(graph, mode = "all")$centralization, #normalized
        centrality_clo = centralization.closeness(graphInv, mode = "all")$centralization,
        centrality_betw = centralization.betweenness(graphInv)$centralization,
        avg_centrality_deg = mean(centralization.degree(graph, mode = "all")$res),
        avg_centrality_betw = mean(centralization.betweenness(graphInv)$res),
        avg_centrality_clo = mean(centralization.closeness(graphInv, mode = "all")$res)
        
    )
}


#-------------------drawBasicGraphs-------------------------------------
drawBasicGraphs = function(graph, relationsBackup, relations, SETTINGS){
    #graphs - MOVE IN SEPERATE FUNCTION
    png(filename=paste0(SETTINGS$OUTPUT_PATH,"/graphs/", SETTINGS$MONTH, "general_graph1.png"))
    plot(degree.distribution(graph), xlab="node degree", main="After transfromation")
    lines(degree.distribution(graph))
    dev.off()
    
    tableActions = table(c(relationsBackup$reacting_person_id, relationsBackup$commenting_person_id))    
    png(filename=paste0(SETTINGS$OUTPUT_PATH,"/graphs/", SETTINGS$MONTH,"general_graph2.png"))
    hist(log10(tableActions),
         breaks = 30,
         main = paste("Raw data"),
         xlab = "node degree")
    dev.off()
    
    tableActions = table(c(relations$reacting_person_id, relations$commenting_person_id))
    png(filename=paste0(SETTINGS$OUTPUT_PATH,"/graphs/", SETTINGS$MONTH,"general_graph3.png"))
    hist(log10(tableActions),
         breaks = 30,
         main = paste("Selected data data"),
         xlab = "node degree")
    dev.off()
}