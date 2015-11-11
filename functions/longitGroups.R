#longitGroups.R

#Its nescesary to get groups data from basic algorithm
groupResults1 = groupResults
groupResults2 = groupResults


#----------------------------Transition between two groups------------------------
    g1 = membership(groupResults1[[length(groupResults1)]])   
    g1 = t(rbind(names(g1),g1))
    g1 = data.frame(g1)
    names(g1) = c("id", "group1")
    g1[, 2] = as.integer(g1[, 2])
    
    g2 = membership(groupResults2[[length(groupResults2)]])
    g2 = t(rbind(names(g2),g2))
    g2 = data.frame(g2)
    names(g2) = c("id", "group2")
    g2[, 2] = as.integer(g2[, 2])
    
    #Rename groups to be same in the month
    #YOU HAVE TO DO THIS MANUALLY!
    table(g1$group1) #you must identify groups by comments in standart output
    g1$group1[g1$group1!=1 & g1$group1!=23 & g1$group1!=34] = 999 #insert right groups
    g1$group1[g1$group1==1] = 1
    g1$group1[g1$group1==23] = 2
    g1$group1[g1$group1==34] = 3
    table(g1$group1)
    
    table(g2$group2) #you must identify groups by comments in standart output
    g2$group2[g2$group2!=12 & g2$group2!=22 & g2$group2!=24] = 999 #insert right groups
    g2$group2[g2$group2==22] = 1
    g2$group2[g2$group2==12] = 2
    g2$group2[g2$group2==24] = 3
    table(g2$group2)
    
    #---END OF MANAUL SECTION---
    
    merged = merge(x = g1, y = g2, by = "id", all = TRUE)
    
    merged[is.na(merged)] = 0
    results = data.frame(table(merged$group1, merged$group2))
    g1 = g2 # for another loop
    
    