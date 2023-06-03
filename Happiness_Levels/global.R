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


Happiness <- read_csv("mean_copy.csv")

happiness_plot <- read_csv("happiness_plot.csv")


#Creating correlation plots










