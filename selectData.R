#selectData.R


#-----------------------------selectData------------------------------------------------
selectData = function ( relations, treshold, category = "all" ){
    #-----main function for selecting data
    
    relations = selectWithoutNA ( relations )
    if( category != "all" )
        relations = selectByCategory( relations, category )
    #notice that we choose first category and then  rteshold (we want only active users in given category)
    relations = selectByTreshold( relations, treshold )
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


#-------------------------selectByTreshold-------------------------------------------
selectByTreshold = function ( relations, threshold )
{
    #----Select users which gives and get more likes than given treshold

    tableRelations = table(c(relations$reacting_person_id, relations$commenting_person_id))
    freRelations = data.frame(tableRelations)
    freRelations = freRelations[which(freRelations[2] > threshold),]
    relations = relations[which(relations$reacting_person_id %in% freRelations[,1]),]
    relations = relations[which(relations$commenting_person_id %in% freRelations[,1]),]
    
    return = relations
}