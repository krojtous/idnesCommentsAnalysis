#color another graph with colors from graoh before
V(graph)$membership = 5

namesOfGroup = names( membership(groups)[membership(groups) == 1] )
V(graph)$membership[names(V(graph)) %in% namesOfGroup] = 1

namesOfGroup = names( membership(groups)[membership(groups) == 2] )
V(graph)$membership[names(V(graph)) %in% namesOfGroup] = 2

namesOfGroup = names( membership(groups)[membership(groups) == 3] )
V(graph)$membership[names(V(graph)) %in% namesOfGroup] = 3

groupColorEng   = c("red","green","blue", "orange", "grey", "brown", "purple", "black", "white")
V(graph)$color = groupColorEng[V(graph)$membership]

groupsOld = groups
groups = groupsOld
