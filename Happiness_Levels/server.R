library(shiny)
library(shinydashboard)
library(shinythemes)
library(leaflet)
library(plotly)
library(ggplot2)
library(DT)

server <- function(input, output) {
  
  filtered_data <- reactive({
    # Filter the data based on user-selected input or any other criteria
    filtered <- Happiness # Replace 'Happiness' with your actual dataset
    # Remove rows with NaN values in happiness
    filtered <- filtered[!is.na(filtered$mean_feeling_of_happiness), ]
    # Apply any additional filters or transformations as needed
    filtered
  })
  
  output$mymap <- renderLeaflet({
    leaflet() %>%
      addTiles() %>%
      addProviderTiles(providers$CartoDB.DarkMatter) %>%
      addLayersControl(
        position = "bottomright",
        overlayGroups = c("Happiness Levels"),
        options = layersControlOptions(collapsed = FALSE)
      )
  })
  
  observe({
    # Access the filtered data
    data <- filtered_data()
    
    leafletProxy("mymap") %>%
      clearMarkers() %>%
      addAwesomeMarkers(
        data = data,
        lng = ~Longitude,
        lat = ~Latitude,
        icon = ~awesomeIcons(icon = "smile-o", markerColor = "orange", library = "fa"),
        popup = ~paste("Country:", Country, "<br>",
                       "Happiness:", mean_feeling_of_happiness, "<br>",
                       "Life Satisfaction:", mean_life_satisfaction)
      )
  })
  
  output$graph <- renderPlot({
    
    happiness_plot%>%
      filter(Feeling_of_happiness >= 1 & Feeling_of_happiness <= 2) %>%
      ggplot(aes(x = Feeling_of_happiness, y = Region, fill = factor(Region))) +
      geom_bar(stat = "identity") +
      labs(x = "Feeling of Happiness", y = "Count") +
      theme_minimal()
    
  })
  
  
}
  

server
  
