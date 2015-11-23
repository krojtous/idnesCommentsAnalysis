
articlesAll = data.frame()
commentsAll = data.frame()
for( i in  1:10 ){
    comments  = read.csv (paste0("./data/comments_2015_", i,".csv"))
    articles  = read.csv (paste0("./data/articles_2015_", i,".csv"))
    articles = articles[articles$tag %in% c("Islámský stát", "Příliv uprchlíků do Evropy", "Terorismus", "Terorismus, teroristické útoky",
                                                   "Islám", "Uprchlíci", "Útok na francouzský týdeník"), c(1,6)]
    articles = unique(articles)
    comments = comments[comments$article_id %in% as.vector(articles[,2]),]
    articlesAll = rbind(articlesAll, articles)
    commentsAll = rbind(commentsAll, comments)
}

articlesAll[,3] = as.integer(strftime(as.Date(articlesAll[,1]),format="%W"))
commentsAll = commentsAll[,c(3,6,9)]

merged = merge(x = articlesAll, y = commentsAll, by = "article_id")
library(plyr)
data = merge(count(merged, 'V3'), count(articlesAll, 'V3'), by = "V3")

data = aggregate(merged$positive_score, by=list(V3 = merged$V3), FUN=sum)
data = merge(data, count(articlesAll, 'V3'), by = "V3")


model = lm(x ~ freq, data = data)
summary(model)
plot(x ~ freq, main="Linear Regression - Relations ~ Articles", data = data)
abline(model, col="red")


plot(data[,c(1,2)], main = "New Haven Temperatures")
dygraph(data[,c(1,2)], main = "New Haven Temperatures") 

library(dygraphs)
dygraph(data[,c(2,3)])
