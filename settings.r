#settings.R

#----------------------------SETTINGS----------------------------------------------------------
SETTINGS = list(
    #---SELECT AND TRANSFORMATION DATA SETTINGS
    MONTH     = 1,
    YEAR     = 2016,   
    THRESHOLD = 0,           
    CATEGORY = "zahranicni",
    #CATEGORY  = "all",
    TO_DIVIDE = 9, #transformation of edges weight
    TAGS = "all", 
    #TAGS = c("Islámský stát", "Příliv uprchlíků do Evropy", "Terorismus", "Terorismus, teroristické útoky",
    #         "Islám", "Uprchlíci", "Útok na francouzský týdeník", "Situace po teroristických útocích v Paříži"),
    #TAGS  = "Miloš Zeman",
    #TAGS = "Příliv uprchlíků do Evropy",
    
    #---CLUSTERING SETTINGS
    SIZE_OF_GROUP = 5, #how big should be the smallest analzyed subgroup
    GROUPS = 3, #How many groups will be indetified in data
    GROUP_ALG = 1, #1 - random walks, 2 - spinglass (exact number of groups)
    GROUP_COLORS = c("red","green","blue", "orange", "grey", "brown", "purple", "black", "white"),
    
    #---EXPORT SETTINGS
    CACHE_DATA = 1, #true/false - should be generated graph, groups and others procesed data saved for further using?
    EXPORT    = "HTML"
)

#Apeend path of cached graph
SETTINGS = c(SETTINGS, GRAPH_PATH = paste0("./data/graphs/", SETTINGS$YEAR ,"/",
                                           SETTINGS$YEAR, "_",
                                           SETTINGS$MONTH, "_",
                                           SETTINGS$THRESHOLD,"_", 
                                           SETTINGS$CATEGORY,"_",
                                           SETTINGS$TO_DIVIDE,"(",
                                           paste(SETTINGS$TAGS, collapse = '-')
                                           ,")graph.txt"))

#Apeend path of cached membership
SETTINGS = c(SETTINGS, MEMBERSHIP_PATH = paste0("./data/groups/", SETTINGS$YEAR ,"/",
                                           SETTINGS$YEAR, "_",
                                           SETTINGS$MONTH, "_",
                                           SETTINGS$THRESHOLD,"_", 
                                           SETTINGS$CATEGORY,"_",
                                           SETTINGS$TO_DIVIDE,"(",
                                           paste(SETTINGS$TAGS, collapse = '-')
                                           ,")groups.txt"))

