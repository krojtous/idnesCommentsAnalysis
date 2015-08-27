#analyzeGroups.R

#---------------------------------------analyzeGroups-------------------------------------
analyzeGroups = function( relations, comments ){
    
    #----main function for analyzing groups
    require(igraph)
    findGroups( relations )
  
}
#--------------------------------------findGroups-----------------------------------------
findGroups = function ( relations ){
    
    relationsW = as.matrix(relations)
    network    = graph.data.frame(relations, directed=F)
    
    #select only biggest oherent component in the graph
    component = components(network)
    network = induced.subgraph(network, V(network)[which(component$membership == which.max(component$csize))])
    #wc         = walktrap.community( network )
    wc         = cluster_spinglass( network, spins = 3 )
    
    in.deg = degree(network,v=V(network), mode="in")
    
    #vykresleni grafu
    #png(filename="/media/matous/A4E0A47DE0A456F8/Dokumenty/Sociologie/Diplomová práce/group_graph.png")
    plot(wc,network,  vertex.label=NA, vertex.size=log(in.deg)*2, edge.color = "black", edge.width=E(network)$weight/2,
        main = "Graph of relations in duscussion with groups", mark.groups = NULL)
    #dev.off()
}
