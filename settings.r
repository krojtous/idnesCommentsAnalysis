#settings.R

#----------------------------SETTINGS----------------------------------------------------------
SETTINGS = list(
    #---SELECT AND TRANSFORMATION DATA SETTINGS
    WEEK     = "02", #in format ww
    MONTH     = 6,
    YEAR     = 2015,
    TIME_GRANULARITY = "month",#month/week
    
    THRESHOLD = 0,           
    CATEGORY = "zahranicni",
    #CATEGORY = "domaci",
    #CATEGORY  = "all",
    TO_DIVIDE = 1, #transformation of edges weight
    TAGS = "all", 
    #TAGS = c("Islámský stát", "Příliv uprchlíků do Evropy", "Terorismus", "Terorismus, teroristické útoky",
    #         "Islám", "Uprchlíci", "Útok na francouzský týdeník", "Situace po teroristických útocích v Paříži"),
    #TAGS  = "Miloš Zeman",
    #TAGS = "Příliv uprchlíků do Evropy",
    
    #---CLUSTERING SETTINGS
    SIZE_OF_GROUP = 5, #how big should be the smallest analzyed subgroup
    GROUPS = 3, #How many groups will be indetified in data
    GROUP_ALG = 1, #1 - random walks, 2 - spinglass (exact number of groups)
    GROUP_COLORS = c("chocolate","blue","red", "green", "hotpink", "purple", "grey", "orange", "black", "white"),
    GROUP_NAMES = c("brown","blue","red", "green", "pink", "purple", "grey", "orange", "black", "white"),
    #GROUP_NAMES = c("anti-Islamic","pro-Western","pro-Russia", "pro-Islamic", "pro-homosexual", "anti-Barnevernet", "other", "orange", "black", "white"),
    #---FINDING LEADERS SETTINGS
    COUNT_LEADERS = 50,
   
   
    #---EXPORT SETTINGS
    CACHE_DATA = 1, #true/false - should be generated graph, groups and others procesed data saved for further using?
    EXPORT    = "HTML"
)

source("./functions/fileManip.R")
#Apeend path of cached graph
SETTINGS = c(SETTINGS, GRAPH_PATH = getGraphPath(SETTINGS))

#Apeend path of cached membership
SETTINGS = c(SETTINGS, MEMBERSHIP_PATH = getMemberPath(SETTINGS))

#Apeend path of cached membership
SETTINGS = c(SETTINGS, OUTPUT_PATH = getOutputPath(SETTINGS))

refreshPath = function(SETTINGS){
source("./functions/fileManip.R")
SETTINGS$GRAPH_PATH = getGraphPath(SETTINGS)
SETTINGS$MEMBERSHIP_PATH = getMemberPath(SETTINGS)
SETTINGS$OUTPUT_PATH = getOutputPath(SETTINGS)
return(SETTINGS)
}

