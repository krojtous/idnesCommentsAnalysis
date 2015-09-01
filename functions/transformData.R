#transformData.R


#------------------------transfromData----------------------------------------------
transformData = function ( relations ){
    relations = weightPositiveRelations( relations )
    relations = transfromWeights       ( relations )
    graph     = transformToGraph       ( relations )
    return    = graph
}


#-------------------------weightedPositiveRelations---------------------------------
weightPositiveRelations = function(relations){
    #-----Sloučí opakované vztahy do jednoho a přidělí jim váhu podle opakování
    relations = relations[which(relations$positive_reaction == 1),]     #Select positive rows
    
    require(plyr)
    relationsWeighted = ddply(relations, .(relations$commenting_person_id, relations$reacting_person_id), nrow)
    names(relationsWeighted) = c("target", "source", "weight")
    return = relationsWeighted
}

#-------------------------transformWeights---------------------------------
transfromWeights = function(relationsW){
    #-----Upraví vztahy (divede by 10 and floor)
    relationsW[,3] = floor((relationsW[,3]/10))
    return = relationsW[which(relationsW[,3] > 0),]
}

#------------------------transformToGraph---------------------------------
transformToGraph = function(relations){
    require(igraph)
    relationsW = as.matrix(relations)
    graph      = graph.data.frame(relationsW, directed=F)
    
    #select only biggest coherent component in the graph
    component = components( graph )
    graph     = induced.subgraph( graph, V(graph)[which(component$membership == which.max(component$csize))])
    return    = graph
}