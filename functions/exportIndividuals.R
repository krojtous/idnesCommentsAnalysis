#exportIndividuals.R


exportIndividuals = function( individualsReuslts, SETTINGS ){
  exportIndividualsHTML( individualsReuslts, SETTINGS )
}

exportIndividualsHTML = function( individualsReuslts, SETTINGS ){
  source("./functions/exportHTML.R")
  sink(paste0(SETTINGS$OUTPUT_PATH,"/", SETTINGS$MONTH,"_individuals.html"))  
  
  HTMLheader( "individuals" , SETTINGS )
  
  #--------------------------------------------DATA---------------------------
  cat("<div id=\"left_column\">")

  
  cat("<h3>Individuals transitions from previous month (relative to current month)</h3>")
  if(is.character(individualsReuslts$transitions)){
    cat(paste0(individualsReuslts$transitions))
  }
  else{
    cat(paste0("<ul>
                <li>All users: ", round(individualsReuslts$transitions$allUsersLeaveIndex, 2),"</li>
                <li>Degree leave index: ", round(individualsReuslts$transitions$degreeLeaveIndex, 2),"</li>
                <li>Betweenness leave index: ", round(individualsReuslts$transitions$betweennessLeaveIndex, 2),"</li>
                <li>Coseness leave index: ", round(individualsReuslts$transitions$closenessLeaveIndex, 2),"</li>
                <li>Users with high degree (first ",SETTINGS$COUNT_LEADERS,"): ", individualsReuslts$transitions$degreeStability,"</li>
                <li>Users with high betweenness (first ",SETTINGS$COUNT_LEADERS,"): ", individualsReuslts$transitions$betweennessStability,"</li>
                <li>Users with high closeness (first ",SETTINGS$COUNT_LEADERS,"): ", individualsReuslts$transitions$closenessStability,"</li>
                </ul>"))
  }
          
  
  cat(paste0("<h3>Users activity (only users in graph)</h3>
             <ul>
             <li>Count of commenting users: ", individualsReuslts$activity$commentingCount, "</li>
             <li>Count of comments: ", individualsReuslts$activity$commentsCount, "</li>
             <li>Count of evaluating users: ", individualsReuslts$activity$relatingCount, "</li>
             <li>Count of evaluations : ", individualsReuslts$activity$relationsCount, " (only positive)</li>
             </ul>"))
  cat("</div>")

  
  #------------------------------FOOTER------------------------------------------------
  HTMLfooter( "general" , SETTINGS )    
  sink()
  
}