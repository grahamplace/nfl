library(rvest)
library(dplyr)
library(readr)

# set working directory to whatever here:
setwd('~/nfl')

years <- seq.int(2006, 2016)
weeks <- seq.int(1, 17)
urls  <- data.frame(url = character(), year = integer(), week = integer()) 
for (w in weeks) {
  w_str <- paste(paste("http://www.footballlocks.com/nfl_odds_week_", w, sep=""), ".shtml", sep ="")
  u = data.frame(url = w_str, week = w)
  urls <- rbind(urls, u)
}

urls$url <- as.character(urls$url)


odds <- data.frame(season_year   = integer(),
                   season_week   = integer(),
                   date_and_time = character(),
                   favorite      = character(),
                   spread        = integer(),
                   underdog      = character(),
                   total         = numeric(),
                   money         = character(),
                   odds          = character()
)

for (i in seq.int(1, nrow(urls))) {
  url <- urls[i,1]
  html <- read_html(url)
  tables <- html %>% html_nodes("table")
  strings <- character(length(tables))
  for (i in 1:length(tables)) strings[i] <- toString(tables[i])
  tables <- tables[which(grepl('<td>At', strings))]
  
  h <- html_table(tables, fill = TRUE)
}


