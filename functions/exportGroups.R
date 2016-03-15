#exportGroups.R


#-----------------------------------exportGroups------------------------------------------------
exportGroups = function( groupResults, SETTINGS ){
    switch( SETTINGS$EXPORT,
            HTML = exportGroupsHTML( groupResults, SETTINGS ))
}
    
#-----------------------------------exportGroupsHTML--------------------------------------------
exportGroupsHTML = function( groupResults, SETTINGS ){

    MONTH = SETTINGS$MONTH #for reasons of clarity of code
    sink(paste0("./output/", SETTINGS$YEAR,"/", MONTH,"_groups.html"))  
    HTMLheader( "groups" , SETTINGS )
    
    #----------------------------------DATA--------------------------------
    cat("<div id=\"left_column\">")
    cat(paste0("<img src=\"graphs/",MONTH,"group_graph.png\" class=\"main_image\">"))
    cat("</div>")
    
    #description of each group
    cat("<div id=\"right_column\">")
    for(i in  1:(length(groupResults) - 2) ){
        exportGroupDescHTML(groupResults, i, SETTINGS)
    }
    #Description of merged too small groups 
    exportSmallGroupDescHTML(groupResults, length(groupResults) - 1, SETTINGS)
    cat("</div>")
    
    #------------------------------FOOTER------------------------------------------------
    HTMLfooter( "groups" , SETTINGS )
    sink()
}

#------------------------------------exportGroupDescHTML----------------------------------
exportGroupDescHTML = function( groupResults, group, SETTINGS ){
        groupColorEng   = SETTINGS$GROUP_COLORS
        groupName   = SETTINGS$GROUP_NAMES
        cat(paste0("<h2>", groupName[group]," group (",groupColorEng[group],")</h2>\n"))  
        
        cat(paste0("<ul>
                        <li>Size: ", groupResults[[group]]$size, "</li>\n
                        <li>Number of comments: ", groupResults[[group]]$commentsDesc$numberComm , "</li>\n
                        <li>Number of likes: ", groupResults[[group]]$commentsDesc$numberLikes , "</li>\n
                        <li>Number of dislikes: ", groupResults[[group]]$commentsDesc$numberDislikes , "</li>\n
                        <li>Density: ", round(groupResults[[group]]$density, digits = 2), "</li>\n
                        <li>Centrality: ", round(groupResults[[group]]$centrality, digits = 2), " (degree)</li>\n"
                   )
            )
        
        #Typical comments export
        comments = groupResults[[group]]$comments
        
        if( length( comments ) > 0 ){
            cat("<li>Typical comments</li>
                <ul>\n")
            
            for( i in 1:length(comments) ){
                cat(paste0(
                    "<li>",comments[[i]]$text, "</li>",
                    "<ul>
                        <li class=\"article\">Article: ", comments[[i]]$article, " (", comments[[i]]$date,")</li>
                    </ul>\n\n"))
                
            }
            cat("</ul>\n")
        }
        cat("</ul>\n") 
}

#------------------------------------exportSmallGroupDescHTML----------------------------------
exportSmallGroupDescHTML = function( groupResults, group, SETTINGS ){
    groupColorEng   = SETTINGS$GROUP_COLORS
    cat(paste0("<h2>", SETTINGS$GROUP_NAMES[group]," groups (",groupColorEng[group],", smaller than " , SETTINGS$SIZE_OF_GROUP, " and unclassifiable)</h2>\n"))  
    
    cat(paste0("<ul>
               <li>Size: ", groupResults[[group]]$size, "</li>\n
               <li>Number of comments: ", groupResults[[group]]$commentsDesc$numberComm , "</li>\n
               <li>Number of likes: ", groupResults[[group]]$commentsDesc$numberLikes , "</li>\n
               <li>Number of dislikes: ", groupResults[[group]]$commentsDesc$numberDislikes , "</li>\n"
                   )
            )
        
}
