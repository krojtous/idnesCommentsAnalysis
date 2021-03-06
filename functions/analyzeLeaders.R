#analyzeLeaders.R


analyzeIndividuals = function(graph, comments, relations, SETTINGS){
  return = list(
    transitions = leadersTransition(graph, SETTINGS),
    activity = usersActivity(relations, comments, graph, SETTINGS))

}

usersActivity = function(relations, comments, graph, SETTINGS){
  #measure of acitivity people in graph (users out of the graph are excluded)
  return = list(
  commentingCount = length(unique(comments$commenting_person_id[which(comments$commenting_person_id %in% V(graph)$name)])),
  commentsCount = length(comments$commenting_person_id[which(comments$commenting_person_id %in% V(graph)$name)]),
  relatingCount = length(unique(relations$reacting_person_id[which(relations$reacting_person_id %in% V(graph)$name)])),
  relationsCount = length(relations$reacting_person_id[which(relations$reacting_person_id %in% V(graph)$name)])
  )
  }

#-----------------------leadersTransition----------------------------------------
leadersTransition = function(graph, SETTINGS){
#---Count relativle how many people stay in discussion from previous month
  
  #get graph from previous month
  graphPrev = graphPrevMonth(SETTINGS)
  if(graphPrev == "NO_DATA"){
    return("Apropriate data from previous month doesn't exist")
  }
  
  #degree leaders
  degreeNames = names(sort(degree(graph), decreasing = TRUE)[1:SETTINGS$COUNT_LEADERS])
  degreeNamesPrev = names(sort(degree(graphPrev), decreasing = TRUE)[1:SETTINGS$COUNT_LEADERS])
  degreeStability = length(degreeNames[degreeNames %in% degreeNamesPrev])/SETTINGS$COUNT_LEADERS
  
  #betweenness leaders
  betweennessNames = names(sort(betweenness(graph), decreasing = TRUE)[1:SETTINGS$COUNT_LEADERS])
  betweennessNamesPrev = names(sort(betweenness(graphPrev), decreasing = TRUE)[1:SETTINGS$COUNT_LEADERS])
  betweennessStability = length(betweennessNames[betweennessNames %in% betweennessNamesPrev])/SETTINGS$COUNT_LEADERS
  
  #closeness leaders
  closenessNames = names(sort(closeness(graph), decreasing = TRUE)[1:SETTINGS$COUNT_LEADERS])
  closenessNamesPrev = names(sort(closeness(graphPrev), decreasing = TRUE)[1:SETTINGS$COUNT_LEADERS])
  closenessStability = length(closenessNames[closenessNames %in% closenessNamesPrev])/SETTINGS$COUNT_LEADERS
  
  #people in general in graph
  usersStability = length(which(V(graph)$name %in% V(graphPrev)$name))/length(V(graph))
  
  out = list(
    degreeStability = degreeStability,
    betweennessStability = betweennessStability,
    closenessStability = closenessStability,
    allUsersStability = usersStability
    
  )
}




#-------------------graohPrevMonth---------------------

graphPrevMonth = function(SETTINGS){
  source("./functions/monthShift.R")
  source("./functions/analyzeGroups.R")
  #Getting path to previous month
  prevM = prevMonth(SETTINGS$MONTH, SETTINGS$YEAR)
  SETTINGS_NEW = SETTINGS
  SETTINGS_NEW$MONTH = prevM$month
  SETTINGS_NEW$YEAR = prevM$year
  SETTINGS_NEW$GRAPH_PATH = getGraphPath(SETTINGS_NEW)
  
  #loading data from previous month
  if(!file.exists(SETTINGS_NEW$GRAPH_PATH)){
    return("NO_DATA")
  }
  return = read.graph(SETTINGS_NEW$GRAPH_PATH, "ncol")
  
}



#------------------------drawLeadersGraph------------------------------------------
drawLeadersGraph = function(graph, leaders){
  allNames = names(V(graph)) 
  inds = which(allNames %in% degreeNames)
  
  shape = rep("circle", length(V(graph)))
  shape[leadersPos] = "square"
  
  size = rep(1.5, length(V(graph)))
  size[leadersPos] = 10
  
  label = rep("", length(V(graph)))
  label[leadersPos] = c("1","2","3","4","5","6","7","8","9","10")
  
  in.deg = degree(graph,v=V(graph), mode="in")
  plot(graph,  
       vertex.label=label,
       vertex.label.cex = 1.1,
       vertex.label.font = 2,
       vertex.label.color = "black",
       vertex.size=size,
       vertex.shape = shape, 
       edge.color = "black", 
       edge.width=E(graph)$weight/2,
       main = "Graph of relations with leaders", mark.groups = NULL)
}


#-----------------------COMMENTS--------------------------------------------
com = comments[comments$commenting_person_id == degreeNames[3],]
com = com[order(-com$positive_score),]
com = com[1:2,c(1,5,6,8)]
