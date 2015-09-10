

#---------------------basicStats---------------------------
analyzeGeneral = function( graph, relations, relationsBackup, SETTINGS ){
    #----Zobrazi zakladni statistiky (počet komentářů, užeivatelů a vztahů) 
    #----a hsitogram počtu vztahů (log10)
    relations = relations[!is.na(relations$commenting_person_id),]  #Remove rows with NA
    #Basic statistics
    V  = length(V(graph))
    E  = length(E(graph))
    density = graph.density(graph)
    
    png(filename=paste0("./output/graphs/", SETTINGS$MONTH, "general_graph1.png"))
    plot(degree.distribution(graph), xlab="node degree", main="After transfromation")
    lines(degree.distribution(graph))
    dev.off()
    
    tableActions = table(c(relationsBackup$reacting_person_id, relationsBackup$commenting_person_id))    
    png(filename=paste0("./output/graphs/", SETTINGS$MONTH, "general_graph2.png"))
    hist(log10(tableActions),
         breaks = 30,
         main = paste("Raw data"),
         xlab = "node degree")
    dev.off()
    
    tableActions = table(c(relations$reacting_person_id, relations$commenting_person_id))
    png(filename=paste0("./output/graphs/", SETTINGS$MONTH, "general_graph3.png"))
    hist(log10(tableActions),
         breaks = 30,
         main = paste("Selected data data"),
         xlab = "node degree")
    dev.off()
    
    return = list(
        V  = V,
        E  = E,
        density     = density
    )
}