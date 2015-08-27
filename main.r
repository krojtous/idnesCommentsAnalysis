#main.r
#script loads, select, analyze data for one dataset (month)

#----------------------------load packages (move in right files)--------------------------------
require(igraph)
require(plyr)

#----------------------------load functions-----------------------------------------------------
source("/media/matous/A4E0A47DE0A456F8/Dokumenty/R/idnesCommentsAnalysis/selectData.R")
#source('/media/matous/A4E0A47DE0A456F8/Dokumenty/Sociologie/Diplomová práce/Data/Functions/HTMOutput.R')

#----------------------------load data----------------------------------------------------------
relations = read.csv("/media/matous/A4E0A47DE0A456F8/Dokumenty/Sociologie/Diplomová práce/Data/Relations/relations_2015_07.csv")
comments = read.csv("/media/matous/A4E0A47DE0A456F8/Dokumenty/Sociologie/Diplomová práce/Data/Relations/comments_2015_07.csv")


#----------------------------select and modify data---------------------------------------------
relations = selectData ( relations, 1000, "zahranicni" )

#----------------------------analyze data-------------------------------------------------------
#TO DO

#----------------------------display data-------------------------------------------------------
#TO DO
file.choose()
