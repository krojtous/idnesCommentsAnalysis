#exportGroups.R


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
        <link rel=\"stylesheet\" type=\"text/css\" href=\"styles/groups.css\">
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
    
    cat(paste0("<img src=\"graphs/",MONTH,"group_graph.png\" class=\"main_image\">"))
    cat(paste0("
<div id=\"navigation\">
<a href=\"",MONTH,"_general.html\">General</a> |
<a href=\"",MONTH,"_groups.html\">Groups</a> |
<a href=\"",MONTH,"_leaders.html\">Leaders</a> |
<a href=\"",MONTH,"_ties.html\">Ties</a> <br/>
<a href=\"",MONTH - 1,"_groups.html\"><< Previous month</a> |   
<a href=\"",MONTH + 1,"_groups.html\">Next month >></a>
</div>
"))
    
    
    #description of each group
    cat("<div id=\"group_desc\">")
    for(i in 1:length(groupResults)){
      exportGroupDescHTML(groupResults, i)
      
    }
    cat("</div>")
    cat("
    </BODY>
</HTML>")
    sink()
}

#------------------------------------exportGroupDescHTML----------------------------------
exportGroupDescHTML = function( groupResults, group ){
        groupColorEng   = c("red","green","blue", "orange", "grey", "brown", "purple", "black", "white")
        cat(paste0("<h2>", groupColorEng[group]," group</h2>\n"))  
        
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
                    <li class=\"article\">Article: ", comments[[i]]$article, " (", comments[[i]]$date,")</li>
                </ul>\n\n"))
            
        }
        cat("</ul>\n</ul>\n")
}
