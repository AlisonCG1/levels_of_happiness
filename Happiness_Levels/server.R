library(shiny)
library(shinydashboard)
library(shinythemes)
library(leaflet)
library(plotly)
library(ggplot2)
library(DT)

server <- function(input, output) {
  
  output$mymap <- renderPlot({
    
    leaflet() %>%
      addTiles() %>%
      addProviderTiles(providers$CartoDB.DarkMatter) %>%
      addLayersControl(
        position = "bottomright",
        overlayGroups = c("Happiness Levels", "Life Satisfaction"),
        options = layersControlOptions(collapsed = FALSE)
      ) %>%
      addMarkers(
        lng =  Happiness$Longitude,
        lat = Happiness$Latitude,
        popup = paste("Country:", Happiness$Country, "<br>",
                      "Happiness:", Happiness$mean_feeling_of_happiness, "<br>",
                      "Life Satisfaction:", Happiness$mean_life_satisfaction)
      )
  })
}
  

server
  
