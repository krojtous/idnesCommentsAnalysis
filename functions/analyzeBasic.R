#---------------------basicStats---------------------------
basicStats = function(relations, name){
    #----Zobrazi zakladni statistiky (počet komentářů, užeivatelů a vztahů) 
    #----a hsitogram počtu vztahů (log10)
    relations = relations[!is.na(relations$commenting_person_id),]  #Remove rows with NA
    #Basic statistics
    commnetsNumber  = length(unique(relations$comment_id))
    usersNumber     = length(unique(c(relations$commenting_person_id, relations$reacting_person_id)))
    relationsNumber = nrow(relations)
    
    
    tableActions = table(c(relations$reacting_person_id, relations$commenting_person_id))
    hist(log10(tableActions),
         breaks = 30,
         main = paste("Histogram počtu vztahů mezi uživateli - log 10\n(", name,")"),
         xlab = "Počet vztahů (log 10)", ylab = "Počet uživatelů")
    
    return = list(
        name      = name,
        commnets  = commnetsNumber,
        users     = usersNumber,
        relations = relationsNumber
    )
}