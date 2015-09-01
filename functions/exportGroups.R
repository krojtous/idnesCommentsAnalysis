#-------------------------------------selectTypicalcomments------------------------------------
selectTypicalCommentsB = function(relationsOrig, wc, comments){
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

exportGroups = function( groupResults, EXPORT, MONTH, THRESHOLD, CATEGORY ){
    switch( EXPORT,
            HTML = exportGroupsHTML( groupResults, MONTH, THRESHOLD, CATEGORY ))
}
    

exportGroupsHTML = function( groupResults, MONTH, THRESHOLD, CATEGORY ){
    
    sink(paste0("./output/", MONTH,"_groups.html"))  
    cat("
      <!doctype html>\n
      <HTML>\n
        <HEAD>
          <title>Results of group analysis</title>
          <meta http-equiv=\"content-type\" content=\"text/html;charset=UTF-8\">\n
        </HEAD>\n
      <BODY>\n")
      cat(paste0("<img src=\"graphs/",MONTH,"group_graph.png\">"))
    

    cat("
        </BODY>\n
      </HTML>")
    sink()
}
