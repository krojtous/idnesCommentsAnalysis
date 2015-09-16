#exportGroups.R


#-----------------------------------exportGroups------------------------------------------------
exportGroups = function( groupResults, SETTINGS ){
    switch( SETTINGS$EXPORT,
            HTML = exportGroupsHTML( groupResults, SETTINGS ))
}
    
#-----------------------------------exportGroupsHTML--------------------------------------------
exportGroupsHTML = function( groupResults, SETTINGS ){

    MONTH = SETTINGS$MONTH #for reasons of clarity of code
    sink(paste0("./output/", MONTH,"_groups.html"))  
    HTMLheader( "groups" , SETTINGS )
    
    #----------------------------------DATA--------------------------------
    cat("<div id=\"left_column\">")
    cat(paste0("<img src=\"graphs/",MONTH,"group_graph.png\" class=\"main_image\">"))
    cat("</div>")
    
    #description of each group
    cat("<div id=\"right_column\">")
    for(i in  1:(length(groupResults) - 1) ){
        exportGroupDescHTML(groupResults, i)
    }
    cat("</div>")
    
    #------------------------------FOOTER------------------------------------------------
    HTMLfooter( "groups" , SETTINGS )
    sink()
}

#------------------------------------exportGroupDescHTML----------------------------------
exportGroupDescHTML = function( groupResults, group ){
        groupColorEng   = c("red","green","blue", "orange", "grey", "brown", "purple", "black", "white")
        cat(paste0("<h2>", groupColorEng[group]," group</h2>\n"))  
        
        cat(paste0("<ul>
                        <li>Size: ", groupResults[[group]]$size, "</li>\n
                        <li>Number of comments: ", groupResults[[group]]$commentsDesc$numberComm , "</li>\n
                        <li>Number of likes: ", groupResults[[group]]$commentsDesc$numberLikes , "</li>\n
                        <li>Number of dislikes: ", groupResults[[group]]$commentsDesc$numberDislikes , "</li>\n
                        <li>Wilcox test: ", groupResults[[group]]$groupSig, "</li>\n"
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
