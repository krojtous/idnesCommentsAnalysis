#exportGroups.R


#-----------------------------------exportGroups------------------------------------------------
exportGroups = function( graph, groupResults, SETTINGS ){
    #-------------------making graphs--------------------

    png(width = 800, height = 800, filename=paste0(SETTINGS$OUTPUT_PATH, "/graphs/", SETTINGS$MONTH, "group_graph.png"))
        drawGraph( graph, groupResults, SETTINGS )
    dev.off()

if( file.exists(SETTINGS$MEMBERSHIP_PATH)){
    png(width = 800, height = 800, filename=paste0(SETTINGS$OUTPUT_PATH, "/graphs/", SETTINGS$MONTH, "group_msd_graph.png"))
       groupResults$MDSmessage = drawMDS(groupResults)
    dev.off()
}
  
    #------------------data export-------------------------
    switch( SETTINGS$EXPORT,
            HTML = exportGroupsHTML( groupResults, SETTINGS ))
}
    
#-----------------------------------exportGroupsHTML--------------------------------------------
exportGroupsHTML = function( groupResults, SETTINGS ){

    MONTH = SETTINGS$MONTH #for sake of clarity of code
    sink(paste0(SETTINGS$OUTPUT_PATH,"/", MONTH,"_groups.html"))  
    HTMLheader( "groups" , SETTINGS )
    
    
    #----------------------------------DATA--------------------------------
    cat("<div id=\"left_column\">")
    cat(paste0("<img src=\"graphs/",MONTH,"group_graph.png\" class=\"main_image\">"))
    
    #Export matrix of proximity (only if groups are recoded)
    if( file.exists(SETTINGS$MEMBERSHIP_PATH)){
        
        # proximity matrix
        exportOpinionMatrixHTML(groupResults$proximityMatrix, SETTINGS)
        
        #multidimensinal image
        exportMDSImageHTML(groupResults$MDSmessage, SETTINGS)
        
        #transition matrix
        exportTransitionMatrixHTML(groupResults$transitionMatrix, SETTINGS)
    }
    
    
    cat("</div>")
    
    #description of each group
    cat("<div id=\"right_column\">")
    for(i in  1:(length(groupResults$groups) - 1) ){
        exportGroupDescHTML(groupResults, i, SETTINGS)
    }
    #Description of merged too small groups 
    exportSmallGroupDescHTML(groupResults, length(groupResults$groups), SETTINGS)
    cat("</div>")
    
    #------------------------------FOOTER------------------------------------------------
    HTMLfooter( "groups" , SETTINGS )
    sink()
}

#------------------------------------exportGroupDescHTML----------------------------------
exportGroupDescHTML = function( groupResults, group, SETTINGS ){
        groupResults= groupResults$groupsDesc
        groupColorEng   = SETTINGS$GROUP_COLORS
        groupName   = SETTINGS$GROUP_NAMES
        cat(paste0("<h2>", groupName[group]," group (",groupColorEng[group],")</h2>\n"))  
        cat(paste0("<ul>
                        <li>Size: ", groupResults[[group]]$size, "</li>\n
                        <li>Number of comments: ", groupResults[[group]]$commentsDesc$numberComm , "</li>\n
                        <li>Number of likes: ", groupResults[[group]]$commentsDesc$numberLikes , "</li>\n
                        <li>Number of dislikes: ", groupResults[[group]]$commentsDesc$numberDislikes , "</li>\n
                        <li>Density: ", round(groupResults[[group]]$density, digits = 2), "</li>\n
                        <li>Centralization (normalized): 
                            <ul>
                                    <li>Degree: ", round(groupResults[[group]]$centrality_deg, digits = 2), "</li>\n
                                    <li>Closeness: ", round(groupResults[[group]]$centrality_clo, digits = 2), "</li>\n
                                    <li>Betweeness: ", round(groupResults[[group]]$centrality_betw, digits = 2), "</li>\n
                                   
                        </ul>
                       <li>Average centrality (of subgraph): 
                           <ul>
                           <li>Degree: ", round(groupResults[[group]]$avg_centrality_deg, digits = 2), "</li>\n
                       <li>Closeness: ", round(groupResults[[group]]$avg_centrality_clo, digits = 2), "</li>\n
                       <li>Betweeness: ", round(groupResults[[group]]$avg_centrality_betw, digits = 2), "</li>\n
                       
                       </ul>"
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
    groupResults= groupResults$groupsDesc
    cat(paste0("<h2>", SETTINGS$GROUP_NAMES[group]," groups (",groupColorEng[group],", smaller than " , SETTINGS$SIZE_OF_GROUP, " and unclassifiable)</h2>\n"))  
    
    cat(paste0("<ul>
               <li>Size: ", groupResults[[group]]$size, "</li>\n
               <li>Number of comments: ", groupResults[[group]]$commentsDesc$numberComm , "</li>\n
               <li>Number of likes: ", groupResults[[group]]$commentsDesc$numberLikes , "</li>\n
               <li>Number of dislikes: ", groupResults[[group]]$commentsDesc$numberDislikes , "</li>\n"
                   )
            )
        
}

#---------------------------------------exportMatrixHTML(matrix)--------------------------------
exportOpinionMatrixHTML = function(matrix, SETTINGS){
    cat("
        <h2>Matrix of oriented opinion proximity</h2>
        <table>\n")
    #write header
    cat("<tr>\n
        <th>
            ‰\n
        </th>\n")
    
    for(j in c(1:nrow(matrix))){
            cat(paste0("<th>",SETTINGS$GROUP_NAMES[j],"</th>\n"))
    }
    cat("</tr>")

    for(i in c(1:nrow(matrix))){
        cat(paste0("<tr>\n<td>",SETTINGS$GROUP_NAMES[i],"</td>\n"))
        for(j in c(1:nrow(matrix))){
            if(i == j){
                cat(paste0("<td class=\"grey\">",matrix[i,j],"</td>\n"))
            }
            else if(matrix[i,j] > 1 && !is.nan(matrix[i,j])){
                cat(paste0("<td class=\"green\">",matrix[i,j],"</td>\n"))
            }
            else if(matrix[i,j] < -1 && !is.nan(matrix[i,j])){
                cat(paste0("<td class=\"red\">",matrix[i,j],"</td>\n"))
            }
            else{
                cat(paste0("<td>",matrix[i,j],"</td>\n"))
            }   
        }
        cat("</tr>")
    }
    
    
    cat("</table>\n")
}



#transitionMatrix = groupResults$transitionMatrix

#-----------------exportTransitionMatrix--------------------------
exportTransitionMatrixHTML = function(transitionMatrix, SETTINGS){

    namesG = SETTINGS$GROUP_NAMES
    namesG[nrow(transitionMatrix)-1] = "Sum"
    cat("
        <h2>Matrix of transitions from previous month</h2>")
    if(typeof(transitionMatrix) == "character"){
        cat(paste0("<div>",transitionMatrix,"</div>"))
        return (NA)
    }
    cat("<table>\n")
    #write header
    cat("<tr>\n
        <th></th>")
    cat("<th>Ingoing</th>\n")
    
    for(j in c(1:(nrow(transitionMatrix)-1))){
            cat(paste0("<th>",namesG[j],"</th>\n")) 
    }
    
    cat("</tr>
          <td>Outgoing</td>\n")
    
    for(j in c(1:ncol(transitionMatrix))){
      if(j == 1) cat(paste0("<td class=\"grey\">",transitionMatrix[1,j],"</td>\n"))
      else cat(paste0("<td>",transitionMatrix[1,j],"</td>\n"))
    }
    
    for(i in c(2:nrow(transitionMatrix))){
        cat("<tr>")
        cat(paste0("<td>",namesG[i-1],"</td>\n"))
        for(j in c(1:ncol(transitionMatrix))){
          if(j == i) cat(paste0("<td class=\"grey\">",transitionMatrix[i,j],"</td>\n"))
          else cat(paste0("<td>",transitionMatrix[i,j],"</td>\n"))
        }
        cat("</tr>")

    }
    cat("</table>")
    
}
#--------------------------------------------------------------
exportMDSImageHTML = function(MDSmessage, SETTINGS){
    cat("<h2>Multidimensional scaling</h2>")
    if(MDSmessage == "ok"){
        cat(paste0("<img src=\"graphs/",SETTINGS$MONTH,"group_msd_graph.png\" class=\"mds_graph\">"))
    }
    else{
        cat (MDSmessage)
    }
}