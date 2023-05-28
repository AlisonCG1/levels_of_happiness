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
graph_cumulative_plot = function(Happiness, plot_year) {
  plot_df = subset(Happiness, year <= plot_year)
  g1 = ggplot(plot_df, aes(x = Year, y = Feeling_of_happiness, color = Region)) +
    geom_line() + geom_point(size = 1, alpha = 0.8) +
    ylab("Cumulative happiness") + xlab("Year") + theme_bw() + 
    scale_colour_manual(values = c(happiness_cols)) +
    scale_y_continuous(labels = function(l) {trans = l / 1000000; paste0(trans, "M")}) +
    theme(legend.title = element_blank(), legend.position = "", 
          plot.title = element_text(size = 10), plot.margin = margin(5, 12, 5, 5))
  return(g1)
}

#Plotting cumulative of life satisfaction for map functions. 

new_cases_plot = function(Happiness, plot_date) {
  plot_df_new = subset(Happiness, date<=plot_date)
  g1 = ggplot(plot_df_new, aes(x = Year, y = Life_satisfaction, colour = Region)) + geom_line() + geom_point(size = 1, alpha = 0.8) +
    # geom_bar(position="stack", stat="identity") + 
    ylab("Life Satisfaction") + xlab("Date") + theme_bw() + 
    scale_colour_manual(values=c(Life_satistaction_cols)) +
    scale_y_continuous(labels = function(l) {trans = l / 1000000; paste0(trans, "M")}) +
    theme(legend.title = element_blank(), legend.position = "", plot.title = element_text(size=10), 
          plot.margin = margin(5, 12, 5, 5))
  g1
}



