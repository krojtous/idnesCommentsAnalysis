#exportHTML.R

source("./functions/fileManip.R")

HTMLheader = function ( subject , SETTINGS){
    months = c( "January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December" )
    MONTH = SETTINGS$MONTH
    
    cat("<!doctype html>
    <HTML>
    <HEAD>")
        cat(paste0("<title>",subject, " results: ", months[MONTH] ,"</title>"))
        cat("<meta http-equiv=\"content-type\" content=\"text/html;charset=UTF-8\">
        <link rel=\"stylesheet\" type=\"text/css\" href=\"../../styles/groups.css\">
        </HEAD>
      <BODY>")
        
    cat(paste0("
            <h1>",subject, " results: ", months[MONTH] ," ", SETTINGS$YEAR,"</h1>
"))
    
    prevM = prevMonth(SETTINGS$MONTH, SETTINGS$YEAR)
    nextM = nextMonth(SETTINGS$MONTH, SETTINGS$YEAR)
    
    cat(paste0("
<div id=\"navigation\">
<a href=\"",MONTH,"_general.html\">General</a> |
<a href=\"",MONTH,"_groups.html\">Groups</a> |
<a href=\"",MONTH,"_individuals.html\">Individuals</a> <br/>
<a href=\"../",prevM$year,"/", prevM$month,"_",subject,".html\"><< Previous month</a> |   
<a href=\"../",nextM$year,"/", nextM$month,"_",subject,".html\">Next month >></a>
</div>
"))
}

HTMLfooter = function ( subject , SETTINGS){

     cat("
    </BODY>
</HTML>")

}