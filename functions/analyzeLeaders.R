#analyzeLeaders.R

#centr = eigen_centrality(graph)

#centr = names(sort(centr$vector, decreasing = TRUE)[1:10])

#-----------------------FIND LEADERS----------------------------------------
degreeNames = names(sort(degree(graph), decreasing = TRUE)[1:10])
allNames = names(V(graph)) 
inds = which(allNames %in% degreeNames)



#------------------------PLOT GRAPH------------------------------------------
shape = rep("circle", length(V(graph)))
shape[inds] = "square"

size = rep(1.5, length(V(graph)))
size[inds] = 10

label = rep("", length(V(graph)))
label[inds] = c("1","2","3","4","5","6","7","8","9","10")

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


#-----------------------COMMENTS--------------------------------------------
com = comments[comments$commenting_person_id == degreeNames[3],]
com = com[order(-com$positive_score),]
com = com[1:2,c(1,5,6,8)]
