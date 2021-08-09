# USL_2_Stats

**Description**

Scraper designed to provide up to date stats for USL League Two, the 4th tier of US soccer. The web scraper is written with functions from the XML2 library in R. Pulls both individual player data, as well as team records for the season. The data has been merged in the end to include the following attributes:
  Player Name
  Team Name
  Games Played (player)
  Games Played (team)
  Division Record
  Goals (player)
  Minutes (player)
  Assists (player)
  Shots (player)
  Yellow Cards (player)
  Red Cards (player)
  Own Goals (player)


**Methods**

For player data, the league site is laid out in 70+ pages of interactive table data. Each webpage includes 30 players. However, the filtration and query possibilities are        limited (only largest to smallest & vice versa for numerical atttributes, alphabetical order for character attributes). To scrape this, I dug into the HTML to find a page        specific URL. Then, I used a for loop to pull data from each page.

For team data, the league site is laid out far more simply. By navigating to the standings page, all of the data can be scraped without automating the process among multiple      pages. It was a little messier in spacing and extra characters (ex. "\n"), but was easy to clean up with a couple of gsub commands. Finally, I just needed to rename the column    headers and reorder the columns to prepare for a merge with player data.

For the dataset merge, I only included a few attributes from the team data for my future desired uses of the data. For this reason, I used an outer join that kept all data from player data, but not necessarily all teams from team data. The sets were merged on team name.


**Notes**

The URLs used in the code are for the 2021 season. The code will need to be updated for future seasons to pull relevant data. The code could also be changed to pull past season data. 

The "URL_count" is hard-coded and would need to be changed based on the number of web pages in the full player stats. To check the number of pages, view the stats page online here: https://www.uslleaguetwo.com/stats/league_instance/134228?subseason=731558

The data is only inclusive of field player data, no goalkeeper data is included. This may be included in a future update.
