library(xml2)

URL_count <- c(1:74) ##adjust for number of pages on statistics webpage
i = 0

## initialize all vectors
player_names_list <- character(0)
team_names_list <- character(0)
numerical_stats_list <- character(0)
goals_list <- character(0)

## for loop to scrape stats sheet
for(i in URL_count) {
  page_counter <- URL_count[i]
  url_final <- 'https://www.uslleaguetwo.com/stats/league_instance/134228?dir=desc&order_by=soig&page='
  url_middle <- paste(url_final, i, sep="")
  url_final <-  paste(url_middle, '&stat_module=soccer_individual&subseason=731558', sep="")
  url_read <- read_html(url_final)
  player_names <- xml_text(xml_find_all(url_read,"//div[@class='NginTableScroll']//table[@id='player-sm-soccer_individual-table']
                                        //td[@class='statPlayer ']//a"))
  player_names_list <- c(player_names_list, player_names)
  team_names <- xml_attr(xml_find_all(url_read, "//div[@class='NginTableScroll']//table[@id='player-sm-soccer_individual-table']
                                      //td[@class='statTeam ']//a"),"title")
  team_names_list <- c(team_names_list, team_names)
  numerical_stats <- xml_text(xml_find_all(url_read, "//div[@class='NginTableScroll']
                                        //table[@id='player-sm-soccer_individual-table']//tbody//td[@class='']"))
  numerical_stats_list <- c(numerical_stats_list, numerical_stats)
  numerical_stats_matrix <- matrix(data = numerical_stats_list, ncol = 7, byrow = TRUE)
  ## order of columns: GP, min, assists, shots, yellow cards, red cards, own goals
  goals <- xml_text(xml_find_all(url_read,"//div[@class='NginTableScroll']//table[@id='player-sm-soccer_individual-table']
                                 //td[@class='highlight']"))
  goals_list <- c(goals_list, goals)
  Sys.sleep(2)
}

## dataframe creation, editing
df <- data.frame(Player_Name=player_names_list, Team_Name=team_names_list, Goals=goals_list, numerical_stats_matrix)
names(df)[which(names(df)=="X1")] <- "Games Played"
names(df)[which(names(df)=="X2")] <- "Mins"
names(df)[which(names(df)=="X3")] <- "Assists"
names(df)[which(names(df)=="X4")] <- "Shots"
names(df)[which(names(df)=="X5")] <- "YC"
names(df)[which(names(df)=="X6")] <- "RC"
names(df)[which(names(df)=="X7")] <- "OG"
names(df)[which(names(df)=="Player_Name")] <- "Player Name"
names(df)[which(names(df)=="Team_Name")] <- "Team"
df$Goals <- as.numeric(df$Goals)
df$`Games Played` <- as.numeric(df$`Games Played`)
df$Mins <- as.numeric(df$Mins)
df$Assists <- as.numeric(df$Assists)
df$Shots <- as.numeric(df$Shots)
df$YC <- as.numeric(df$YC)
df$RC <- as.numeric(df$RC)
df$OG <- as.numeric(df$OG)


## team season information
standings_url <- 'https://www.uslleaguetwo.com/standings/show/6155280?subseason=731558' ## 2021 season

team_games_played <- character(0)
team_name_standings_list <- character(0)

standings_url_read <- read_html(standings_url)
team_games_played <- xml_text(xml_find_all(standings_url_read, "//ul//table[@class='statTable']//td"))
team_games_played <- gsub("\n","", team_games_played)
team_games_played <- gsub("      ","", team_games_played)
team_games_played <- gsub("    ","", team_games_played)
teams_gp_matrix <- matrix(data=team_games_played, ncol = 10, byrow = TRUE) ## adjust data types still
teams_gp_df <- data.frame(teams_gp_matrix)
names(teams_gp_df)[which(names(teams_gp_df)=="X1")] <- "Team Name"
names(teams_gp_df)[which(names(teams_gp_df)=="X2")] <- "Team Abbreviation"
names(teams_gp_df)[which(names(teams_gp_df)=="X3")] <- "Wins"
names(teams_gp_df)[which(names(teams_gp_df)=="X4")] <- "Losses"
names(teams_gp_df)[which(names(teams_gp_df)=="X5")] <- "Ties"
names(teams_gp_df)[which(names(teams_gp_df)=="X6")] <- "Points"
names(teams_gp_df)[which(names(teams_gp_df)=="X7")] <- "GF"
names(teams_gp_df)[which(names(teams_gp_df)=="X8")] <- "GA"
names(teams_gp_df)[which(names(teams_gp_df)=="X9")] <- "GD"
names(teams_gp_df)[which(names(teams_gp_df)=="X10")] <- "Division Record"
teams_gp_df$Wins <- as.numeric(teams_gp_df$Wins)
teams_gp_df$Ties <- as.numeric(teams_gp_df$Ties)
teams_gp_df$Losses <- as.numeric(teams_gp_df$Losses)
teams_gp_df$Team_GP <- teams_gp_df$Wins+teams_gp_df$Losses+teams_gp_df$Ties
teams_gp_df <- teams_gp_df[,c(1,11,10,2:9)]
teams_gp_df2 <- teams_gp_df[1:3]

## merging team data with player data
merged_data <- merge(df, teams_gp_df2,
                     by.x = "Team", by.y = "Team Name",
                     all.x = TRUE)
merged_data <- merged_data[,c(2,1,4,11,12,3,5:10)]

write.csv(merged_data, file = "player_stats.csv")

## testing player data from googleAPI spreadsheet
url4 <- 'https://sheets.googleapis.com/v4/spreadsheets/1hJzsNZpqxoKq_MzLe258bedmrkUEF25wVZ45x3LvKls/values/public?key=AIzaSyBoR2fNeRaKdufS56OGyCAcTUUrRY4Ee9k'
url4_read <- read_html(url4)
player_data <- xml_text(xml_find_all(url4_read, "//body"))
player_data
player_data <- strsplit(player_data, "\n")
player_data <- matrix(unlist(player_data[19:52945]), ncol = 21, byrow = TRUE)
player_data_matrix <- matrix(data=player_data, ncol=21)
?strsplit
