library(tidyverse)
library(googlesheets4)
library(googledrive)

Sys.setenv(TZ="America/Los_Angeles")

connection_function <- function(){
  if (gs4_user() == 'jacobs-googledrive@hardy-rhythm-306423.iam.gserviceaccount.com'){
    print('CONNECTION SUCCESSFUL')
  }
  else {
    print('CONNECTION FAILED')
  }

}
connection_function()

current_time <- strftime(Sys.time(), format = "%B %d, %Y - %I:%M %p %Z") %>%
  as.data.frame() %>%
  select(time = 1)

print(paste0('Printing Current Time to Google Sheets at ', current_time))

sheet_append(data = current_time, 
            ss = 'https://docs.google.com/spreadsheets/d/1iVCGoVT6JsuRnNY7sR38e_yZxVOQZLZibmbeNGeyJgU/edit#gid=0',
            sheet = 3)
print('Exiting Out')
