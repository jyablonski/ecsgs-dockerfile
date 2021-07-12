FROM rocker/tidyverse:4.1.0

RUN R -e "install.packages(c('dplyr', 'googlesheets4', 'googledrive', 'gmailr', 'DBI', 'RMySQL', 'logger'), repos = 'http://cran.us.r-project.org')"

COPY . .

CMD Rscript app.R