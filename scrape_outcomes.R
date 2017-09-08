library(rvest)
library(dplyr)
years <- seq.int(2006, 2016)
weeks <- seq.int(1, 17)
urls <- rep(NA, 187)
i <- 1
for (year in years) {
  for (week in weeks) {
    y <- paste("https://www.pro-football-reference.com/years/", year, sep='')
    w <- paste(paste("/week_", week, sep=""), ".htm", sep ="")
    urls[i] <- paste(y, w, sep="")
    i <- i + 1
  }
}

for (url in urls) {
  html <- read_html(url)
  week_data <- html %>% 
    html_nodes("table.teams") %>%
    html_table()
  
  for (w in week_data) {
    df <- week_data[[1]]
    date_str <- df[1,1]
    date <- as.Date(date_str, "%b %d, %Y")
    print(date)
  }
}
