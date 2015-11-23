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
    g1$group1[g1$group1!=1 & g1$group1!=2 & g1$group1!=5] = 999 #insert right groups
    g1$group1[g1$group1==1] = 1
    g1$group1[g1$group1==2] = 2
    g1$group1[g1$group1==5] = 3
    table(g1$group1)
    
    table(g2$group2) #you must identify groups by comments in standart output
    g2$group2[g2$group2!=1 & g2$group2!=3 & g2$group2!=4] = 999 #insert right groups
    g2$group2[g2$group2==1] = 5
    g2$group2[g2$group2==3] = 1
    g2$group2[g2$group2==5] = 2
    g2$group2[g2$group2==4] = 3
    table(g2$group2)
    
    #---END OF MANAUL SECTION---
    
    merged = merge(x = g1, y = g2, by = "id", all = TRUE)
    
    merged[is.na(merged)] = 0
    results = data.frame(table(merged$group1, merged$group2))
    results = data.frame(table(merged$group2.x, merged$group2.y))
    g1 = g2 # for another loop
    
    #choose specific transition
    merged[merged$group1 == 2 & merged$group2 == 3 , 1]
    #11810 29857 46223 47376  5695 66906 70388 84452
    comments[comments$commenting_person_id == c(70388) & comments$positive_score > 15, c(1,5)]
   
#---------------------------Finding Hard-core group------------------------------------
    groups = groupResults[[7]]
    
    
    g = membership(groups)
    HC3 = data.frame(names(g)[g == 3])
    
    
    g1 = membership(groupResults[[length(groupResults)]])   
    g1 = t(rbind(names(g1),g1))
    g1 = data.frame(g1)
    names(g1) = c("id", "group1")
    g1[, 1] = as.integer(g1[, 1])
    
    HC1[,2] = as.integer(HC1[,1])
    
    HC1[ HC1[,1] %in% g1[,1], 1 ]
    
     