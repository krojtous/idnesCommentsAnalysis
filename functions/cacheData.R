#cacheData.R

#----------------Save graph to external text file-------------------------
cacheGraph = function( graph, SETTINGS ){
    if( ! file.exists(SETTINGS$GRAPH_PATH) && SETTINGS$CACHE_DATA == 1 ){
        write.graph(graph, SETTINGS$GRAPH_PATH, "ncol")
    }
}

#----------------Save membership of groups to text file-------------------------
recodeAndCacheGroups = function( groupResults, SETTINGS, GROUP_VECTOR ){
    

            require("tcltk")
            button = tkmessageBox(message = "Chces ulozit clenstvi ve skupinach? (Melo by byt spravne rekodovane...)",
                                  icon = "question", type = "yesno", default = "yes")
            button = tclvalue(button)
            if(button == 'yes'){
                library(plyr)
                newMembership = groupResults$groups$membership
                newMembership = mapvalues(newMembership, from = c(1:length(unique(newMembership))), to = GROUP_VECTOR)
               
                save(newMembership, file = SETTINGS$MEMBERSHIP_PATH)
            }
          
    
}

#-----------------------------------renameGroups----------------------------
renameGroups = function( groupResults, GROUP_VECTOR ){

}


