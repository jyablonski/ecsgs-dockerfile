suppressPackageStartupMessages(library(dplyr))
suppressPackageStartupMessages(library(googlesheets4))
suppressPackageStartupMessages(library(googledrive))
suppressPackageStartupMessages(library(gmailr))
suppressPackageStartupMessages(library(DBI))

Sys.setenv(TZ="America/Los_Angeles")

connection_function <- function(){
  if (gs4_user() == 'jacobs-docker-ecs-account@docker-ecs-r-project.iam.gserviceaccount.com'){
    print('GOOGLE APIs CONNECTION SUCCESSFUL')
  }
  else {
    print('GOOGLE APIs CONNECTION FAILED')
  }
  
}
connection_function()

aws_connect <- dbConnect(drv = RMySQL::MySQL(), dbname = aws_db,
                         host = aws_host,
                         port = aws_port,
                         user = aws_user, password = aws_pw)

df <- dbGetQuery(aws_connect, 'SELECT * FROM aws_injuries;')
print(paste0('Retrieving ', nrow(df), ' rows from aws_injuries in MySQL RDS Database'))

dbDisconnect(aws_connect)

current_time <- strftime(Sys.time(), format = "%B %d, %Y - %I:%M %p %Z") %>%
  as.data.frame() %>%
  select(time = 1)

print(paste0('Printing Current Time to Google Sheets at ', current_time))

sheet_append(data = current_time, 
            ss = 'https://docs.google.com/spreadsheets/d/1iVCGoVT6JsuRnNY7sR38e_yZxVOQZLZibmbeNGeyJgU/edit#gid=0',
            sheet = 3)



test_email <-
  gm_mime() %>%
  gm_to(jacobs_email) %>%
  gm_from(jacobs_email) %>%
  gm_subject("this is just a gmailr test from Docker") %>%
  gm_html_body("Can you hear me now? <br> <br>
               <a href = 'https://docs.google.com/spreadsheets/d/1iVCGoVT6JsuRnNY7sR38e_yZxVOQZLZibmbeNGeyJgU/edit#gid=0'> </a>")

gm_send_message(test_email)

print(paste0('Sending Gmail Update to ', jacobs_email))
print('Exiting Out')
