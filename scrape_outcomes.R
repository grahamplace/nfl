library(rvest)
library(dplyr)
library(readr)

# set working directory to whatever here:
setwd('~/nfl')

years <- seq.int(2006, 2016)
weeks <- seq.int(1, 17)
urls  <- data.frame(url = character(), year = integer(), week = integer()) 
for (y in years) {
  for (w in weeks) {
    y_str <- paste("https://www.pro-football-reference.com/years/", y, sep='')
    w_str <- paste(paste("/week_", w, sep=""), ".htm", sep ="")
    u = data.frame(url = paste(y_str, w_str, sep=""), year = y, week = w)
    urls <- rbind(urls, u)
  }
}
urls$url <- as.character(urls$url)

# manually clean up the broken urls
urls <- urls[-which (urls == 'https://www.pro-football-reference.com/years/2006/week_8.htm'),]

results <- data.frame(season_year  = integer(),
                      season_week  = integer(),
                      date         = as.Date(character()),
                      winner       = character(),
                      winner_score = integer(),
                      loser        = character(),
                      loser_score  = integer()
                      )

for (i in seq.int(1, nrow(urls))) {
  url <- urls[i,1]
  html <- read_html(url)
  week_data <- html %>% 
    html_nodes("table.teams") %>%
    html_table()
  
  for (j in seq.int(1, length(week_data))) {
    df <- week_data[[j]]
    date_str <- df[1,1]
    game_date <- as.Date(date_str, "%b %d, %Y")
    scores <- df[-1,-3]
    scores <- scores[order(scores$X2),]
    outcome <- data.frame(date         = game_date, 
                          winner       = scores[2,1],
                          winner_score = as.integer(scores[2,2]),
                          loser        = scores[1,1],
                          loser_score  = as.integer(scores[1,2])
    )
    results <- rbind(results, outcome)
  }
}

# write to output CSV
write_csv(results, 'data/game_results.csv')
