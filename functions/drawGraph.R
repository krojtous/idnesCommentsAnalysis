#drawGraph.R

#-------------------------------------drawGraph------------------------------------------------
drawGraph = function( graph, groupResults, SETTINGS ){
    #right colors for graph
    groupColorEng   = SETTINGS$GROUP_COLORS
    #groupColorEng   = c("blue","limegreen","chocolate4", "red2", "white", "white", "white", "maroon1", "white")
    #groupColorEng   = c("lightslateblue","lightgreen","lightgoldenrod3", "tomato", "white", "white", "white", "orchid1", "white")
    #groupColorEng   = c(rgb(1, 0.709, 0.423),rgb(0.6, 0.831, 0.180),rgb(0.733, 0.886, 0.447), rgb(1, 1, 0.501), "white", "white", "white", rgb(1, 0.502, 0.255), "white")
    
    V(graph)$membership =  groupResults[[length(groupResults)]]$membership
    V(graph)$color = groupColorEng[V(graph)$membership]
    
    
    #draw graph
    in.deg = degree(graph,v=V(graph), mode="in")
    plot(graph,  vertex.label=NA, vertex.size=log(in.deg)*2, edge.color = "black", edge.width=E(graph)$weight/2,
         mark.groups = NULL)
    
}
