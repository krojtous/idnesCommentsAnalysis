#longitudinal analysis of leaders


#----------------------------SETTINGS----------------------------------------------------------
SETTINGS = list(
    MONTH     = 1,            
    THRESHOLD = 50,           
    CATEGORY  = "zahranicni",    
    EXPORT    = "HTML"
)

#---------------------------LOAD FUNCTIONS-----------------------------------------------------
source("./functions/selectData.R")
source("./functions/transformData.R")

#----------------------------------------------------------------------------------------------
for(i in 1:7){
    SETTINGS$MONTH = 8
    main(SETTINGS)
}

main = function(SETTINGS){
    #----------------------------LOAD DATA---------------------------------------------------------
    relations = read.csv (paste0("./data/relations_2015_", SETTINGS$MONTH,".csv"))
    comments  = read.csv (paste0("./data/comments_2015_", SETTINGS$MONTH,".csv"))
    relationsBackup = relations
    
    #----------------------------SELECT AND TRANSFROM DATA-----------------------------------------
    relations = selectData ( relations, SETTINGS )
    graph     = transformData ( relations )
    
    #----------------------------ANALYZE DATA------------------------------------------------------
    degreeNames2 = names(sort(degree(graph), decreasing = TRUE)[1:20])
    table = cbind(table, degreeNames2)
}

write.csv(table, file = "./leaders_long.csv")
all = c(table[,1:8])
table(all)
a = table(table)
table(a)
