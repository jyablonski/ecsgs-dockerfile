suppressPackageStartupMessages(library(dplyr))
suppressPackageStartupMessages(library(googlesheets4))
suppressPackageStartupMessages(library(googledrive))
suppressPackageStartupMessages(library(gmailr))
suppressPackageStartupMessages(library(DBI))
suppressPackageStartupMessages(library(logger))
suppressPackageStartupMessages(library(pool))

aws_connect <- dbConnect(drv = RMySQL::MySQL(), dbname = aws_db,
                         host = aws_host,
                         port = aws_port,
                         user = aws_user, password = aws_pw)

dbSendQuery(aws_connect, 'CREATE DATABASE aws_database')

df <- dbGetQuery(aws_connect, 'SHOW DATABASES;')

dbClearResult(dbListResults(aws_connect)[[1]])
dbListTables(aws_connect)

odds <- readr::read_csv('data/aws_odds_df.csv') %>%
  select(-row_names)

dbWriteTable(aws_connect, name = "aws_odds_df", value = odds, append = FALSE, overwrite = TRUE)


dbListTables(aws_connect)


odds_rds <- dbReadTable(aws_connect, 'aws_odds_df')
