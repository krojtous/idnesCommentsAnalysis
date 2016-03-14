#cacheData.R

#----------------Save graph to external text file-------------------------
cacheGraph = function( graph, SETTINGS ){
    if( ! file.exists(SETTINGS$GRAPH_PATH) && SETTINGS$CACHE_DATA == 1 ){
        write.graph(graph, SETTINGS$GRAPH_PATH, "ncol")
    }
}

#----------------Save membership of groups to text file-------------------------
cacheGroups = function( groupResults, SETTINGS ){
    
        if( ! file.exists(SETTINGS$MEMBERSHIP_PATH) && SETTINGS$CACHE_DATA == 1 ){
            require("tcltk")
            button = tkmessageBox(message = "Chces ulozit clenstvi ve skupinach? (Melo by byt spravne rekodovane...)",
                                  icon = "question", type = "yesno", default = "yes")
            button = tclvalue(button)
            if(button == 'yes'){
                g1 = membership(groupResults[[length(groupResults)]])
                g1 = t(rbind(names(g1),g1))
                g1 = data.frame(g1)
                names(g1) = c("id", "group1")
                g1[, 2] = as.integer(g1[, 2])
            }
          }
    
}

