#selectData.R


#-----------------------------selectData------------------------------------------------
selectData = function ( relations, SETTINGS){
    #-----main function for selecting data
    
    relations = selectWithoutNA ( relations )
    if( SETTINGS$CATEGORY != "all" )
        relations = selectByCategory( relations, SETTINGS$CATEGORY )
    #notice that we choose first category and then  treshold (we want only active users in given category)
    relations = selectByThreshold( relations, SETTINGS$THRESHOLD )
}


#---------------------------selectWithoutNA--------------------------------------------
selectWithoutNA = function ( relations )
{
    #---- Remove rows with NA  
    return = relations[!is.na(relations$commenting_person_id),]  
}


#---------------------------selectByCategory-------------------------------------------
selectByCategory = function ( relations, category )
{
    #----select only realtions which are in the article of given category (zahranicni, domaci...)
    relations = relations[which(relations$category == category),] 
    return = relations
}


#-------------------------selectByThreshold-------------------------------------------
selectByThreshold = function ( relations, threshold )
{
    #----Select users which gives and get more likes than given treshold

    tableRelations = table(c(relations$reacting_person_id, relations$commenting_person_id))
    freRelations = data.frame(tableRelations)
    freRelations = freRelations[which(freRelations[2] > threshold),]
    relations = relations[which(relations$reacting_person_id %in% freRelations[,1]),]
    relations = relations[which(relations$commenting_person_id %in% freRelations[,1]),]
    
    return = relations
}