#---------------prevMonth-------------------
prevMonth = function( month, year ){
    if(month == 1){
        month = 12
        year = year - 1;
    } else{
        month = month - 1
    }
    out = list(month = month,year = year)
}

#---------------nextMonth-------------------
nextMonth = function( month, year ){
    if(month == 12){
        month = 1
        year = year + 1;
    } else {
        month = month + 1
    }
    out = list(month = month, year = year)
}