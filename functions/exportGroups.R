#exportGroups.R

#-------------------------------------selectTypicalcomments------------------------------------
selectTypicalCommentsB = function(relationsOrig, wc, comments){

}


#-----------------------------------exportGroups------------------------------------------------
exportGroups = function( groupResults, EXPORT, MONTH, THRESHOLD, CATEGORY ){
    switch( EXPORT,
            HTML = exportGroupsHTML( groupResults, MONTH, THRESHOLD, CATEGORY ))
}
    
#-----------------------------------exportGroupsHTML--------------------------------------------
exportGroupsHTML = function( groupResults, MONTH, THRESHOLD, CATEGORY ){
    months = c(
        "January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December" 
    )
    sink(paste0("./output/", MONTH,"_groups.html"))  
    cat("<!doctype html>
<HTML>
    <HEAD>
        <title>Results of group analysis</title>
        <meta http-equiv=\"content-type\" content=\"text/html;charset=UTF-8\">
        <link rel=\"stylesheet\" type=\"text/css\" href=\"groups.css\">
        </HEAD>
      <BODY>")
    cat(paste0("
            <h1>Group results: ", months[MONTH],"</h1>
               "))
    
    cat(paste0("
            <ul>
                <li>Category: ", CATEGORY,"</li>
                <li>Threshold: ", THRESHOLD,"</li>",
               "</ul>"))
    
    cat(paste0("
             <img src=\"graphs/",MONTH,"group_graph.png\" class=\"main_image\">"))
    
    #description of each group
    for(i in 1:length(groupResults)){
      exportGroupDescHTML(groupResults, i)
    }

    cat("
    </BODY>
</HTML>")
    sink()
}

#------------------------------------exportGroupDescHTML----------------------------------
exportGroupDescHTML = function( groupResults, group ){
        groupColorEng   = c("red","green","blue", "orange", "grey")    
        cat(paste0("<h2>Group ", groupColorEng[group],"</h2>\n"))  
        
        cat(paste0("<ul>
                        <li>Size: ", groupResults[[group]]$size, "</li>\n",
                       "<li>Wilcox test: ", groupResults[[group]]$groupSig, "</li>\n"
                   )
            )
        
        cat("<li>Typical comments</li>
            <ul>\n")
        comments = groupResults[[group]]$comments
        for( i in 1:length(comments) ){
            cat(paste0(
                "<li>",comments[[i]]$text, "</li>",
                "<ul>
                    <li>Article: ", comments[[i]]$article, "</li>
                </ul>\n\n"))
            
        }
        cat("</ul>\n</ul>\n")
}
