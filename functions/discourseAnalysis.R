#discourseAnalysis.R

for( i in  11:12){
    SETTINGS$MONTH = i
    discourseAnalyze(SETTINGS)
}

discourseAnalyze = function( SETTINGS ){
    comments  = read.csv (paste0("./data/comments_2015_", SETTINGS$MONTH,".csv"))
    cat(SETTINGS$MONTH)
    cat("\n")
    cat(length( grep("uprchlí", comments[,1])))
    cat("\n")
    cat(length(grep("migrant", comments[,1])))
    cat("\n\n")
}
