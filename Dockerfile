FROM rocker/tidyverse:4.1.0

RUN R -e "install.packages(c('tidyverse', 'googlesheets4', 'googledrive'), repos = 'http://cran.us.r-project.org')"

COPY . .

CMD Rscript app.R