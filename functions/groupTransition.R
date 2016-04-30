#-------------------groupTransition---------------------
#function makes matrix with transition between groups in two months
#You need in both months recoded groups
groupTransition = function( groups, SETTINGS ){
    groupCurr = t(rbind(names(membership(groups)),groups$membership))
    groupPrev = membershipPrevMonth(SETTINGS)
    typeof(groupCurr)
    typeof(groupCurr)
    #check if previous group exists
    if(groupPrev == "NO_DATA") return("Apropriate data from previous month doesn't exist")
    
    #adjusting data format
    groupCurr = data.frame(groupCurr)
    names(groupCurr) = c("id", "groupCurr")
    groupCurr[, 2] = strtoi(groupCurr[, 2])
    
    groupPrev = data.frame(groupPrev)
    names(groupPrev) = c("id", "groupPrev")
    groupPrev[, 2] = strtoi(groupPrev[, 2])
    
    #merging data from two months
    merged = merge(x = groupCurr, y = groupPrev, by = "id", all = TRUE)
    merged[is.na(merged)] = "0"
    groupCount = length(groups)+1 
    
    #making table with rows and cols where is no any number
    C = matrix( 
      c(rep(0, groupCount*groupCount )), 
      nrow=groupCount, 
      ncol=groupCount) 
     
    for( i in  0:groupCount-1)
      for( j in  0:groupCount-1)
        C[i+1,j+1] = nrow(merged[which(merged$groupCurr == i & merged$groupPrev == j ),])
    C = addmargins(C)
    return = C
    
}

#-------------------membershipPrevMonth---------------------

membershipPrevMonth = function(SETTINGS){
    source("./functions/monthShift.R")
    source("./functions/analyzeGroups.R")
    #Getting path to previous month
    prevM = prevMonth(SETTINGS$MONTH, SETTINGS$YEAR)
    SETTINGS_NEW = SETTINGS
    SETTINGS_NEW$MONTH = prevM$month
    SETTINGS_NEW$YEAR = prevM$year
    SETTINGS_NEW$GRAPH_PATH = getGraphPath(SETTINGS_NEW)
    SETTINGS_NEW$MEMBERSHIP_PATH = getMemberPath(SETTINGS_NEW)
    
    #loading data from previous month
    if(!file.exists(SETTINGS_NEW$MEMBERSHIP_PATH) || !file.exists(SETTINGS_NEW$GRAPH_PATH)){
        return("NO_DATA")
    }
    load(file = SETTINGS_NEW$MEMBERSHIP_PATH) #load vector "newMembership" from text file
    graph2 = read.graph(SETTINGS_NEW$GRAPH_PATH, "ncol")

    #finding groups in previous month
    groups2 = findGroups( graph2, SETTINGS_NEW )
    groups2 = mergingSmallGroups( groups2, SETTINGS_NEW )
    groups2$membership = as_membership(newMembership)
    
    #export groups
    return = t(rbind(names(membership(groups2)),groups2$membership))
    
}