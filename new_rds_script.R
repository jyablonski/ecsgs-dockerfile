suppressPackageStartupMessages(library(dplyr))
suppressPackageStartupMessages(library(googlesheets4))
suppressPackageStartupMessages(library(googledrive))
suppressPackageStartupMessages(library(gmailr))
suppressPackageStartupMessages(library(DBI))
suppressPackageStartupMessages(library(logger))
suppressPackageStartupMessages(library(pool))
suppressPackageStartupMessages(library(bigrquery))


aws_connect <- dbConnect(drv = RMariaDB::MariaDB(), dbname = aws_db,
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

# use get query for select statements, sendquery for create db ?
# 2021-09-14 update: dbt worked!
df <- dbGetQuery(aws_connect, 'SELECT * FROM my_real_table;')
df2 <- dbGetQuery(aws_connect, 'SELECT * FROM my_second_dbt_model;')
df3 <- dbGetQuery(aws_connect, 'SELECT * FROM my_third_dbt_model;')

df <- dbGetQuery(aws_connect, 'SELECT * FROM v_my_second_dbt_model;')
df2 <- dbGetQuery(aws_connect, 'SELECT * FROM v_my_fourth_dbt_model;')
df3 <- dbGetQuery(aws_connect, 'SELECT * FROM my_third_dbt_model;')

odds_rds <- dbReadTable(aws_connect, 'aws_odds_df')
transactions_rds <- dbReadTable(aws_connect, 'transactions')
df <- dbReadTable(aws_connect, 'pbp_prac')

str(df)
df2 <- df %>%
  mutate_at(vars(AwayScore, Score, HomeScore), ~str_replace_all(., "Jump ball", ""))

df2 <- df %>%
  mutate(AwayScore2 = case_when(str_detect(AwayScore, "Jump ball") ~ "",
                                str_detect(AwayScore, "quarter") ~ "",
                                TRUE ~ AwayScore),
         AwayScore2 = is.numeric(AwayScore2))

dbRemoveTable(aws_connect, "df")
dbRemoveTable(aws_connect, 'aws_injury_data_table')

dbListTables(aws_connect)


#### 3big query

# set this in .rprofile
# bigrquery::bq_auth(path = 'key/bigquery_python_key.json')

con <- dbConnect(
  bigrquery::bigquery(),
  project = "docker-ecs-r-project", # the database
  dataset = "dbt_jyablonski"        # the schema
)

dbListTables(con)
dbGetQuery(con, 'SELECT * FROM fct_orders;')
