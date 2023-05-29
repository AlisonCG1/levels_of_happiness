library(shiny)
library(shinydashboard)
library(shinythemes)
library(leaflet)
library(plotly)
library(ggplot2)
library(DT)

server <- function(input, output, session) {
  
  output$mymap <- renderLeaflet(
    leaflet()%>%
      addProviderTiles(providers$CartoDB.DarkMatter)%>%
      addLayersControl(
        position = "bottomright",
        overlayGroups = c("Happiness Levels", "Life Satisfaction"),
        options = layersControlOptions(collapsed = FALSE)))
    }
