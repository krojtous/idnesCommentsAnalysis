#fileManip.R

#---------------getOutputPath-------------------
getOutputPath = function(SETTINGS){
  return = paste0("./output/",SETTINGS$TIME_GRANULARITY,"/", SETTINGS$YEAR)
}

#---------------getGraphPath-------------------
getGraphPath = function(SETTINGS){
    return = paste0("./data/graphs/", SETTINGS$YEAR ,"/",SETTINGS$TIME_GRANULARITY,"/",
           SETTINGS$YEAR, "_",
           SETTINGS$MONTH, "_",
           SETTINGS$THRESHOLD,"_",
           SETTINGS$CATEGORY,"_",
           SETTINGS$TO_DIVIDE,"(",
           paste(SETTINGS$TAGS, collapse = '-')
           ,")graph.txt")
}
#---------------getMemberPath-------------------
getMemberPath = function(SETTINGS){
    return = paste0("./data/groups/", SETTINGS$YEAR ,"/",SETTINGS$TIME_GRANULARITY,"/",
                    SETTINGS$YEAR, "_",
                    SETTINGS$MONTH, "_",
                    SETTINGS$THRESHOLD,"_", 
                    SETTINGS$CATEGORY,"_",
                    SETTINGS$TO_DIVIDE,"_",
                    SETTINGS$GROUPS,"_",
                    SETTINGS$SIZE_OF_GROUP,"_",
                    SETTINGS$GROUP_ALG,"(",
                    paste(SETTINGS$TAGS, collapse = '-')
                    ,")groups.txt")
}

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