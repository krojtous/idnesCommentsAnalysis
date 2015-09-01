#analyzeGroups.R

#-------------------------------------analyzeGroups-------------------------------------
analyzeGroups = function( graph, comments, relationsOrig, MONTH ){
    
    #----main function for analyzing groups
    
    groups = findGroups( graph )
    out = list()
    for( i in  1:length(groups )){
        out[[i]] = describeGroup( graph, groups, comments, relationsOrig, i )
        
    }
    
    png(filename=paste0("./output/graphs/", MONTH, "group_graph.png"))
        drawGraph( graph, groups )
    dev.off()
    return = out
  
}

#-------------------------------------findGroups-----------------------------------------
findGroups = function ( graph ){
    #----finds communities in graph (various options of methods)
    #groups  = walktrap.community( graph )
    groups  = cluster_spinglass( graph, spins = 3 ) #spins means how many groups we are looking for
    
    return = groups
}

#-------------------------------------drawGraph------------------------------------------------
drawGraph = function( graph, groups ){
    #right colors for graph
    groupColorEng   = c("red","green","blue", "orange", "grey", "brown", "purple", "black", "white")
    V(graph)$membership =  groups$membership
    V(graph)$color = groupColorEng[V(graph)$membership]
    
    #vykresleni grafu
    #png(filename="/media/matous/A4E0A47DE0A456F8/Dokumenty/Sociologie/Diplomová práce/group_graph.png")
    in.deg = degree(graph,v=V(graph), mode="in")
    plot(graph,  vertex.label=NA, vertex.size=log(in.deg)*2, edge.color = "black", edge.width=E(graph)$weight/2,
         main = "Graph of relations in duscussion with groups", mark.groups = NULL)
    #dev.off()
}

#-------------------------------------describeGroup-------------------------------------------
describeGroup = function( graph, groups, comments, relationsOrig, i ){
    
    #----function which describe one group in basic stats (in degree, out degree, typical commnets, number of vertices...)
    groupColorEng   = c("red","green","blue", "orange", "grey", "brown", "purple", "black", "white")
    out = list(
        color    = groupColorEng[i],
        size     = sizes(groups)[ i ],
        groupSig = communitySignificanceTest( graph, groups, i ),
        comments = list()
    )
    
    new_id = 1
    for(comment_id in selectTypicalComments(groups, relationsOrig, i, 3)){
        out$comments[[new_id]] = list()
        out$comments[[new_id]]$text = paste(comments[which(comments$comment_id == comment_id),1]) #paste is here to conversion from factor to text
        out$comments[[new_id]]$article = paste(comments[which(comments$comment_id == comment_id),5])
        out$comments[[new_id]]$date = paste(comments[which(comments$comment_id == comment_id),8])
        new_id = new_id + 1
    }
    
    out = formatData( out ) #add attribute names etc.
    return = out
}
#-------------------------------------formatData-------------------------------------------
formatData = function( out ){
    #----format list of data to better dormat (add names to attributes)
    names( out$size )    = "Number of vertices"
    names( out$groupSig) = "Wilcox significance test"
    return = out
}


#-------------------------selectTypicalComments---------------------------------
selectTypicalComments = function(wc, relations, group, number = 3){ #Puvodne se zde pracuje s originalnimi daty !!!!
    #----makes vector of IDs of typical commnets
    
    # Výběr jen těch ID, které patří do dané skupiny
    membership = as.matrix(membership(wc))
    membership = membership[which(membership[,1] == group),] 
    relationsMember = relations[which(relations$reacting_person_id %in% row.names(as.matrix(membership))),]
    relationsMember = relationsMember[which(relations$positive_reaction == 1),] 
    
    #Získání ID komenářů s nejvíce lajky
    commentTable = data.frame(table(relationsMember$comment_id))
    colnames(commentTable) = c("ID","Fre")
    commentTable = commentTable[order(-commentTable$Fre),]
    return = commentTable[1:number ,1]
    
}

#-----------------------communitySignificanceTest---------------------------------------
communitySignificanceTest = function(graph, groups, i) {
    
    vs = V(graph)[which(membership(groups) == i)]
    subgraph     = induced.subgraph( graph, vs )
    in.degrees   = degree(subgraph)
    out.degrees  = degree(graph, vs) - in.degrees
    a = wilcox.test(in.degrees, out.degrees)
    return = a$statistic
}

