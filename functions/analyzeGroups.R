#analyzeGroups.R

#-------------------------------------analyzeGroups-------------------------------------
analyzeGroups = function( graph, comments, relations, relationsBackup, commentsBackup, SETTINGS ){
    #----main function for analyzing groups
    
    groups = findGroups( graph, SETTINGS )
      
    groups = mergingSmallGroups( groups, SETTINGS )
    
    out = list()
    #use of cahed group memebrship from previous recoding
    if( file.exists(SETTINGS$MEMBERSHIP_PATH)){
        load(file = SETTINGS$MEMBERSHIP_PATH) #load vector "newMembership" from text file
        groups$membership = as_membership(newMembership)
    }
    out$groups = groups
    
    #description of each group

    for( i in  1:length(groups) ){
        out$groupsDesc[[i]] = describeGroup( graph, groups, comments, relations, i, SETTINGS )
    }
    
    #Group proximity and transition (is executed only for recoded groups)
    if(file.exists(SETTINGS$MEMBERSHIP_PATH)){
        out$proximityMatrix = groupsOpinionProximity(graph, comments, groups, relationsBackup, commentsBackup)
       
        source("./functions/groupTransition.R")
        out$transitionMatrix = groupTransition( groups, SETTINGS )
        
    }
    return = out
  
}

#-------------------------------------findGroups-----------------------------------------
findGroups = function ( graph, SETTINGS ){
    #----finds communities in graph (various options of methods)
    
    #groups = cluster_optimal( graph ) <--- DO NOT USE, NEEDS TOO MUCH MEMORY!!!
    #groups = cluster_fast_greedy(graph) # <--- NEEDS GRAPH WITHOUT MULTIPLPE EDGES 
    #groups = cluster_edge_betweenness(graph)
     #spins means how many groups we are looking for
    if( SETTINGS$GROUP_ALG == 1) groups  = walktrap.community( graph )
    if( SETTINGS$GROUP_ALG == 2) groups  = cluster_spinglass( graph, spins = SETTINGS$GROUPS )

    return = groups
}

#-------------------------------------describeGroup-------------------------------------------
describeGroup = function( graph, groups, comments, relationsOrig, i, SETTINGS ){
    
    #----function which describe one group in basic stats (in degree, out degree, typical commnets, number of vertices...)
    groupColorEng   = SETTINGS$GROUP_COLORS

    
    #make a subgraph from group
    subg = induced.subgraph(graph, which(membership(groups) == i))
    #invesrse weights of graph because of betweeness
    subgInv = subg
    E(subgInv)$weight = 1/E(subg)$weight
   
    
    out = list(
        color    = groupColorEng[i],
        size     = length(which(groups$membership == i)),
        density  = graph.density(subg, loops=FALSE),
        centrality_deg = centralization.degree(subg, mode = "all")$centralization, #normalized
        centrality_clo = centralization.closeness(subgInv, mode = "all")$centralization,
        centrality_betw = centralization.betweenness(subgInv)$centralization,
        avg_centrality_deg = mean(centralization.degree(subg, mode = "all")$res),
        avg_centrality_betw = mean(centralization.betweenness(subgInv)$res),
        avg_centrality_clo = mean(centralization.closeness(subgInv, mode = "all")$res),
        commentsDesc = commentsDesc(graph, comments, groups, i),
        comments = list()
    )
    
    new_id = 1
    for(comment_id in selectTypicalComments(groups, relationsOrig, i, 5)){
        out$comments[[new_id]] = list()
        out$comments[[new_id]]$text = paste(comments[which(comments$comment_id == comment_id),1]) #paste is here due to conversion from factor to text
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
    return = out
}

#-------------------------selectTypicalComments---------------------------------
selectTypicalComments = function(wc, relations, group, number = 3){ #Puvodne se zde pracuje s originalnimi daty !!!!
    #----makes vector of IDs of typical commnets
    
    # Výběr jen těch ID, které patří do dané skupiny
    membership = as.matrix(membership(wc))
    membership = membership[which(membership[,1] == group),] 
    relationsMember = relations[which(relations$reacting_person_id %in% row.names(as.matrix(membership))),]
    relationsMember = relationsMember[which(relationsMember$positive_reaction == 1),] 
    #relationsMember = relationsMember[which(relations$positive_reaction == 1),] 
    
    #Získání ID komenářů s nejvíce lajky
    commentTable = data.frame(table(relationsMember$comment_id))
    pom = nrow(commentTable)
    if(nrow(commentTable) == 0) return = numeric() #group didnt comment anything - just gives and gets likes
    else{
        colnames(commentTable) = c("ID","Fre")
        commentTable = commentTable[order(-commentTable$Fre),]
        return = commentTable[1:number ,1]
    }
    
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

#---------------------commentsDesc-------------------------------------------------------
commentsDesc = function(graph, comments, groups, i){
    #----count comments of one group, all likes and dislikes which gets this group
    vs = V(graph)[which(membership(groups) == i)]
    com = comments[comments$commenting_person_id %in% names(vs),]
    
    #transfrom dislikes to integers
    com$negative_score = gsub("−", "", com$negative_score)
    com$negative_score = strtoi(com$negative_score)
    
    return = list(
             numberComm = nrow(com),
             numberLikes = sum(com$positive_score),
             numberDislikes = sum(com$negative_score)
             
    )
    
}

#------------------------------groupsOpinionProximity---------------------------------
groupsOpinionProximity = function(graph, comments, groups, relationsBackup, commentsBackup){
    groupsCount = length(groups)
    C = matrix( 
        c(rep(0, groupsCount*groupsCount )), 
        nrow=groupsCount, 
        ncol=groupsCount) 
    
    for(i in c(1:groupsCount)){
           
        for(j in c(1:groupsCount)){
        vs1 = names(which(membership(groups) == i ))
        vs2 = names(which(membership(groups) == j ))
        
        rel = relationsBackup[relationsBackup$positive_reaction == 1,]
        rel = rel[rel$commenting_person_id %in% vs2, ]
        rel = rel[rel$reacting_person_id %in% vs1, ]
        pos1 = nrow(rel)
        
        rel = relationsBackup[relationsBackup$positive_reaction == 0,]
        rel = rel[rel$commenting_person_id %in% vs2, ]
        rel = rel[rel$reacting_person_id %in% vs1, ]
        neg1 = nrow(rel)
        
        
        nComm = nrow(commentsBackup[commentsBackup$commenting_person_id %in% vs2,])
        proximity =  (pos1 - neg1) / ( length(vs1) * nComm ) * 1000
        #cat(paste(i," -> ", j, ": ", round(proximity, digits = 2),"\n"))
        C[i, j] = round(proximity, digits = 2)
        }
    }
    out = C
}

#------------------------------mergingSmallGroups---------------------------------
mergingSmallGroups = function( groups, SETTINGS){
    len = length(groups)
    groupsTmp = groups$membership
    for( i in  1:len ){
        if ( length(groupsTmp[ groupsTmp == i ]) < SETTINGS$SIZE_OF_GROUP){
            groupsTmp[ groupsTmp == i ] = 999
        }
    }
    
    #rename groups to make sequence of numbers
    n = 1
    for( i in sort.int(c(unique(groupsTmp))) ){
            groupsTmp[ groupsTmp == i] = n 
            n = n + 1
    }
    table(groupsTmp)
    groups$membership = groupsTmp
    return = groups
}


