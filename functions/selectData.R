#selectData.R


#-----------------------------selectRelations------------------------------------------------
selectRelations = function ( relations, articles, SETTINGS){
    #-----main function for selecting relations

    relations = selectWithoutNA ( relations )
    if( SETTINGS$CATEGORY != "all" ){
        relations = selectByCategory( relations, SETTINGS$CATEGORY )
    }
    if( SETTINGS$TAGS[1] != "all" ){
        relations = selectByTags( relations, articles, SETTINGS )
    }
    #notice that we choose first category and tags then  treshold (we want only active users in given category)
    if( SETTINGS$TIME_GRANULARITY == "week" ){
      relations = selectByWeek( relations, articles, SETTINGS$WEEK )
    }
    relations = selectByThreshold( relations, SETTINGS$THRESHOLD )
    return = relations
}

#-----------------------------selectComments----------------------------------------------
selectComments = function ( comments, articles, relations, SETTINGS ){
    #-----main function for selecting comments
    comments = selectCommWithoutNA(comments)
    comments = unique(comments)
    if( SETTINGS$CATEGORY != "all" ){
        comments = selectCommByCategory( relations, comments, SETTINGS$CATEGORY )
    }
    if( SETTINGS$TAGS[1] != "all" ){
        comments = selectByTags( comments, articles, SETTINGS )
    }
    if( SETTINGS$TIME_GRANULARITY == "WEEK" ){
      comments = selectByWeek( comments, articles, SETTINGS$WEEK )
    }
    return = comments
}

#-----------------------------selectCommWithoutNA--------------------------------------------
selectCommWithoutNA = function ( comments )
{
    #---- Remove rows with NA  
    return = comments[!is.na(comments$positive_score),]  
}

#-----------------------------selectWithoutNA--------------------------------------------
selectWithoutNA = function ( relations )
{
    #---- Remove rows with NA  
    return = relations[!is.na(relations$commenting_person_id),]  
}

#-----------------------------selectByCategory-------------------------------------------
selectByCategory = function ( relations, category )
{
    #----select only realtions which are in the article of given category (zahranicni, domaci...)
    relations = relations[which(relations$category == category),] 
    return = relations
}

#-----------------------------selectByThreshold-------------------------------------------
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

#-----------------------------selectByTags-------------------------------------------------
selectByTags = function( data, articles, SETTINGS ){
    #----Select relations or comments (data) by tags of articles

    a = articles[articles$tag %in% SETTINGS$TAGS,6]
    
    a = unique(a)
    data = data[data$article_id %in% a,] 
    return = data
    }

#-----------------------------selectByTagKrimi-------------------------------------------------
selectByTagKrimi = function( data, articles, SETTINGS ){
    #----Select relations or comments (data) by tags of articles
    
    #a = articles[articles$tag %in% SETTINGS$TAGS,6]
    a = articles[substr(articles$tag, 1, 5) == "Krimi",6]
    a = unique(a)
    data = relations
    data = data[data$article_id %in% a,]
    comments2 = comments[comments$article_id %in% a,]
    return = data
}

#-----------------------------selectCommByCategory-------------------------------------------------
selectCommByCategory = function( relations, comments, CATEGORY ){
    listOfComments = unique(relations[,'comment_id'])
    return = comments[comments$comment_id %in% listOfComments,]
}

#-----------------------------selectByWeek--------------------------------------------------
selectByWeek = function( data, articles, WEEK ){
  #in data are two different formats of dates %d.%m.%Y and Y%-%m-%d
#WEEK = SETTINGS$WEEK
#data = relations
  listOfArticles = unique(articles[which(strftime(as.Date(articles$date),format="%V") == WEEK),'article_id'])
  return = data[data$article_id %in% listOfArticles,]
}