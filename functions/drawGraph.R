#drawGraph.R

#-------------------------------------drawGraph------------------------------------------------
drawGraph = function( graph, groupResults, SETTINGS ){
    #right colors for graph
    groupColorEng   = SETTINGS$GROUP_COLORS

    V(graph)$membership =  groupResults$groups$membership
    V(graph)$color = groupColorEng[V(graph)$membership]
    
    
    #draw graph
    in.deg = degree(graph,v=V(graph), mode="in")
    plot(graph,  vertex.label=NA, vertex.size=log(in.deg)*2, edge.color = "black", edge.width=E(graph)$weight/2,
         mark.groups = NULL)
    
}

#---------------------------------drawMSD--------------------------------
drawMDS = function(groupResults){
    proximityMatrix = groupResults$proximityMatrix
    #symetrize matrix
    s = 0.5 * (proximityMatrix + t(proximityMatrix))
    colnames(s) = SETTINGS$GROUP_NAMES[1:ncol(s)]
    rownames(s) = SETTINGS$GROUP_NAMES[1:nrow(s)]
    #remove group other
    s = s[,-7]
    s = s[-7,]
    #remove col and rows full NaN
    s = s[rowSums(is.na(s)) != ncol(s), colSums(is.na(s)) != nrow(s)]
    s = -s
    diag(s) = 0
    s = s - 2*min(s)
    
    end = FALSE
    end = tryCatch({
        fit = cmdscale(s, eig = TRUE, k = 2)
        
    }, warning = function(war) {
        return (paste0("Unable to create CMD: ", war))
    }, error = function(err) {
        return (paste0("Unable to create CMD: ", err))
    }, finally = {})
    
    if(is.character(end)) return(end)
    
    
    x = fit$points[, 1]
    y = fit$points[, 2]
    
    plot(x, y, pch = 19)
    names = colnames(s)
    text(x, y, pos = 1, labels = names)
    return("ok")
    
}