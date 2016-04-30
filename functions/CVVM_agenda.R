#script finds key words in surveys of CVVM in queiston of main public
#topic. key words are chosen for period from januarz to september 2015
#The emphsis is on the Syrian conflict and involment of Russia

keyWords = c("(S[ýy]r.*Rus)|(Rus.*S[ýy]r)","S[ýy]r","rus",
             "Teror","islámský stát","ISIS","isl[aá]m","uprchlí","migrant",
             "p[řr]ist[ěe]hoval","migrac","ukrajin",
             "nezaměst","politika","muslim",
             "korup[cč]","kriminalit","brod","hokej",
             "maturit","osvobození","nep[aá]l","nev[íi]m","dragoun","konvoj",
             "d[uů]chod","0")

months = c(1:6,9,10)
library(foreign)

data = data.frame()
for(month in months){
    if(month > 9){
        CVVM = read.spss(paste0("C:/Dokumenty/Sociologie/Diplomová práce/Data/CVVM/V15",month,"/V15",month,"_F1.sav"), use.value.labels = FALSE, to.data.frame = TRUE)
    }
    else{
        CVVM = read.spss(paste0("C:/Dokumenty/Sociologie/Diplomová práce/Data/CVVM/V150",month,"/V150",month,"_F1.sav"), use.value.labels = FALSE, to.data.frame = TRUE)
    }
    toSearch = as.character(c(as.character(CVVM$PS_21A)))  
    # toSearch = as.character(c(as.character(CVVM$PS_21A),as.character(CVVM$PS_21B)))
    data["sum",as.character(month)] =length(toSearch)
    for(word in keyWords){
        data[word,as.character(month)] = length(grep(word, toSearch, ignore.case = TRUE))
        toSearch[grep(word, toSearch , ignore.case = TRUE)] = ""
    }
}



