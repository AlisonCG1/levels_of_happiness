library(shiny)
library(shinydashboard)
library(shinythemes)
library(leaflet)
library(plotly)
library(ggplot2)
library(DT)

server <- function(input, output) {
  
 output$mymap <- renderPlot({
   
   filtered_data <- Happiness %>%
     filter(Feeling_of_happiness %in% c(1, 2))
   happiness_sum <- sum(filtered_data$Feeling_of_happiness)
    
    leaflet()%>%
     addTiles() %>%
      addProviderTiles(providers$CartoDB.DarkMatter)%>%
      addLayersControl(
        position = "bottomright",
        overlayGroups = c("Happiness Levels", "Life Satisfaction"),
        options = layersControlOptions(collapsed = FALSE))%>%
      addCircleMarkers(
       data = Really_happy,
       lat = ~Latitude,
       lng = ~Longitude,
       color = ifelse(Happiness$Feeling_of_happiness >= 2, "yellow", "red"),  # Use different colors based on the condition
       radius = 5,
       stroke = FALSE,
       fillOpacity = 0.10
     )
  })

}
  

server
  
