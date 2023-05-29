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

# set mapping colour for each outbreak
happiness_cols = "#F7FBFF"
Life_satistaction_cols = "#FFF5F0"


Happiness <- read_csv("happiness_levels.csv")

#Plotting cumulative of happiness for map functions.

# Filter the dataset where 1 and 2 represent happy and really happy in the dataset. 
Really_happy <- filtered_happiness %>% filter(Feeling_of_happiness >= 1 & Feeling_of_happiness <= 2)

# Calculate cumulative sum by year.
Really_happy <- Really_happy %>%
  group_by(Year) %>%
  mutate(cumulative_sum = cumsum(Feeling_of_happiness))

# Create the cumulative plot
ggplot(Really_happy, aes(x = Year, y = cumulative_sum, color = Region)) +
  geom_line() + geom_point(size = 1, alpha = 0.8)
  xlab("Year") +
  ylab("Cumulative Happiness") + theme_bw() +
    scale_colour_manual(values = c(happiness_cols)) +
    scale_y_continuous(labels = function(l) {trans = l / 1000000; paste0(trans, "M")}) +
    theme(legend.title = element_blank(), legend.position = "", 
          plot.title = element_text(size = 10), plot.margin = margin(5, 12, 5, 5))


#Plotting cumulative of life satisfaction for map functions. 








