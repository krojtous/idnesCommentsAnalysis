#exportGeneral.R


exportGeneral = function( resultsGeneral, SETTINGS ){
    exportGeneralHTML( resultsGeneral, SETTINGS )
}

exportGeneralHTML = function( results, SETTINGS ){
    source("./functions/exportHTML.R")
    sink(paste0("./output/", SETTINGS$MONTH,"_general.html"))  
    
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
                <li>Vertices: ", results$V,"</li>
                <li>Edges: ", results$E,"</li>
                <li>Density: ", results$density,"</li>",
               "</ul>"))
    
    
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