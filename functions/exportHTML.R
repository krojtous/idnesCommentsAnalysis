#exportHTML.R

HTMLheader = function ( subject , SETTINGS){
    months = c( "January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December" )
    MONTH = SETTINGS$MONTH
    
    cat("<!doctype html>
    <HTML>
    <HEAD>")
        cat(paste0("<title>",subject, " results: ", months[MONTH] ,"</title>"))
        cat("<meta http-equiv=\"content-type\" content=\"text/html;charset=UTF-8\">
        <link rel=\"stylesheet\" type=\"text/css\" href=\"../styles/groups.css\">
        </HEAD>
      <BODY>")
        
    cat(paste0("
            <h1>",subject, " results: ", months[MONTH] ," ", SETTINGS$YEAR,"</h1>
"))
    
    cat(paste0("
<div id=\"navigation\">
<a href=\"",MONTH,"_general.html\">General</a> |
<a href=\"",MONTH,"_groups.html\">Groups</a> |
<a href=\"",MONTH,"_leaders.html\">Leaders</a> |
<a href=\"",MONTH,"_ties.html\">Ties</a> <br/>
<a href=\"",MONTH - 1,"_",subject,".html\"><< Previous month</a> |   
<a href=\"",MONTH + 1,"_",subject,".html\">Next month >></a>
</div>
"))
}

HTMLfooter = function ( subject , SETTINGS){

     cat("
    </BODY>
</HTML>")

}