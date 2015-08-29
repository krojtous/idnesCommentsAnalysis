#analyzeGroups.R

#-------------------------------------analyzeGroups-------------------------------------
analyzeGroups = function( graph, comments, relationsOrig ){
    
    #----main function for analyzing groups
    
    groups = findGroups( graph )
    out = list()
    for( i in  1:length(groups )){
        out[[i]] = describeGroup( graph, groups, i )
    }
    drawGraph( graph, groups )
    selectTypicalComments( relationsOrig, groups, comments )
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
    groupColorEng   = c("red","green","blue", "orange", "grey")
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
describeGroup = function( graph, groups, i ){
    
    #----function which describe one group in basic stats (in degree, out degree, typical commnets, number of vertices...)
    groupColorEng   = c("red","green","blue", "orange", "grey")
    out = list(
        number   = i,
        color    = groupColorEng[i],
        size     = sizes(groups)[ i ],
        groupSig = communitySignificanceTest( graph, groups, i )
    )
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
#-------------------------------------selectTypicalcomments------------------------------------
selectTypicalComments = function(relationsOrig, wc, comments){
    groupColorEng   = c("red","green","blue", "orange", "grey")
    for( group in 1:length(unique(membership(wc)))){ # cyklus pro všechny skupiny v grafu          
        cat(paste0("Group ", groupColorEng[group],":\n"))  
        
        cat("Comments that group members rated most positive:\n")  
        for(comment_id in chooseTypicalCommentsOfOneGroup(wc, relationsOrig, group, 3)){
            cat(paste0(
                comments[which(comments$comment_id == comment_id),1],
                "(Article: ", comments[which(comments$comment_id == comment_id),5], ")\n\n"))
            
        }
        
    }
}

#-------------------------chooseTypicalCommentsOfOneGroup---------------------------------
chooseTypicalCommentsOfOneGroup = function(wc, relations, group, number = 3){ #Puvodne se zde pracuje s originalnimi daty !!!!
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

