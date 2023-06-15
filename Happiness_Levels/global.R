library(shiny)
library(shinydashboard)
library(tidyverse)
library(sf)
library(ggplot2)
library(dplyr)
library(readxl)
library(hrbrthemes)
library(viridis)
library(forcats)
library(data.table)
library(scales)
library(leaflet)
library(geojsonio)
library(RColorBrewer)
library(shinythemes)
library(htmltools)
library(plotly)
library(DT)
library(sp)

# set mapping colour for each outbreak
happiness_cols = "#F7FBFF"
Life_satistaction_cols = "#FFF5F0"


Happiness <- read_csv("all_happiness.csv")


Happiness <- Happiness%>% 
  select(-c(...1))

agg_happiness <- Happiness %>%
  group_by(Country) %>%
  summarise(mean_feeling_of_happiness = mean(Feeling_of_happiness, na.rm = TRUE),
            mean_life_satisfaction = mean(Life_satisfaction, na.rm = TRUE),
            mean_financial_satisfaction = mean(Financial_satisfaction, na.rm = TRUE),
            .groups = "drop")



countries <- geojsonio::geojson_read("countries.geojson", what = "sp")

countries@data <- countries@data%>%
  mutate(randu = runif(n = 255))

countries@data


countries@data <- left_join(countries@data, agg_happiness, by = c("ADMIN" = "Country"))

labels <- sprintf(
  "<strong>%s</strong><br/>%g Country <sup>2</sup>",
  countries@data$ADMIN, countries@data$mean_feeling_of_happiness
) %>% lapply(htmltools::HTML)



