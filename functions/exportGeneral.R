#exportGeneral.R


exportGeneral = function( resultsGeneral, SETTINGS ){
    exportGeneralHTML( resultsGeneral, SETTINGS )
}

exportGeneralHTML = function( results, SETTINGS ){
    source("./functions/exportHTML.R")
    sink(paste0(SETTINGS$OUTPUT_PATH,"/", SETTINGS$MONTH,"_general.html"))  
    
    HTMLheader( "general" , SETTINGS )
    
    #--------------------------------------------DATA---------------------------
    cat("<div id=\"left_column\">")
    cat("<ul>
        <li>Tags: ")
    cat( SETTINGS$TAGS,sep=", ")
    cat("</li>")
        
    cat(paste0("
                <li>Category: ", SETTINGS$CATEGORY,"</li>
                <li>Threshold: ", SETTINGS$THRESHOLD,"</li>
                <li>Edge divide: ", SETTINGS$TO_DIVIDE ,"</li>
               </ul>"))
    
    cat(paste0("<h3>Before select</h3>
               <ul>
                <li>Comments: ", results$beforeSelect$commentsN,"</li>
                <li>Relations: ", results$beforeSelect$relationsN,"</li>
                <li>Articles: ", results$beforeSelect$articlesN,"</li>
                <li>Users: ", results$beforeSelect$usersN,"</li>
               </ul>"))
    
    cat(paste0("<h3>After select</h3>
               <ul>
                <li>Comments: ", results$afterSelect$commentsN," (", round( results$afterSelect$commentsN/results$beforeSelect$commentsN*100 , 1)," %)</li>
                <li>Relations: ", results$afterSelect$relationsN," (", round( results$afterSelect$relationsN/results$beforeSelect$relationsN*100 , 1)," %)</li>
                <li>Positive relations: ", results$afterSelect$relationsNPos," (", round( results$afterSelect$relationsNPos/results$beforeSelect$relationsN*100 , 1)," %)</li>
                <li>Articles: ", results$afterSelect$articlesN," (", round( results$afterSelect$articlesN/results$beforeSelect$articlesN*100 , 1)," %)</li>
                <li>Users: ", results$afterSelect$usersN," (", round( results$afterSelect$usersN/results$beforeSelect$usersN*100 , 1)," %)</li>
                <br />
<h3>Graph</h3>
                <li>Edges: ", results$afterSelect$E,"</li>
                <li>Sum weight of edges: ", results$afterSelect$sumWeightEdges,"</li>
                <li>Density: ", round(results$afterSelect$density, 2),"</li>

                <li>Centralization (normalized): </li>
                <ul>
                    <li>Degree: ", round(results$afterSelect$centrality_deg, digits = 2), "</li>\n
                    <li>Closeness: ", round(results$afterSelect$centrality_clo, digits = 2), "</li>\n
                    <li>Betweeness: ", round(results$afterSelect$centrality_betw, digits = 2), "</li>\n
               
               </ul>
                <li>Average centrality: 
                           <ul>
                           <li>Degree: ", round(results$afterSelect$avg_centrality_deg, digits = 2), "</li>\n
                       <li>Closeness: ", round(results$afterSelect$avg_centrality_clo, digits = 2), "</li>\n
                       <li>Betweeness: ", round(results$afterSelect$avg_centrality_betw, digits = 2), "</li>\n
                   </ul>    
               </ul>"))
    
    
    cat(paste0("<img src=\"graphs/",SETTINGS$MONTH,"general_graph1.png\" class=\"main_image\">"))
    cat("</div>")
    
    cat("<div id=\"right_column\">")
    cat(paste0("<img src=\"graphs/",SETTINGS$MONTH,"general_graph2.png\" class=\"main_image\">"))
    cat(paste0("<img src=\"graphs/",SETTINGS$MONTH,"general_graph3.png\" class=\"main_image\">"))
    cat("</div>")
    
    #------------------------------FOOTER------------------------------------------------
    HTMLfooter( "general" , SETTINGS )    
    sink()
    
}