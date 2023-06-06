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
    # Remove rows with missing or invalid lat/lon values
    filtered <- filtered[complete.cases(filtered$Latitude, filtered$Longitude), ]
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
    happiness_plot %>%
      filter(Feeling_of_happiness >= 1 & Feeling_of_happiness <= 2) %>%
      ggplot(aes(x = Feeling_of_happiness, y = Region, fill = factor(Region))) +
      geom_bar(stat = "identity") +
      labs(x = "Feeling of Happiness", y = "Count") +
      theme_minimal()
  })
  
  output$scatter_plot <- renderPlot({
   
      happiness_year <- happiness_plot %>%
      filter(Feeling_of_happiness >= 1 & Feeling_of_happiness <= 2)%>%
      group_by(Year) %>%
      summarise(col_mean = mean(Feeling_of_happiness)) %>%
      arrange(desc(Year))
    
    ggplot(happiness_year, aes(x = Year, y = col_mean)) +
      geom_line() +
      geom_point() +
      labs(x = "Year", y = "Mean Feeling of Happiness", title = "Happiness Plot")
  })
  
  filteredData <- reactive({
    happiness_plot%>%
      filter(Feeling_of_happiness >= 1 & Feeling_of_happiness <= 2) %>%
      filter(Year == input$yearInput)
  })
  
  output$interactivePlot <- renderPlotly({
    filteredData <- filteredData()
    
    p <- ggplot(filteredData, aes(x = Feeling_of_happiness, y = Region, fill = factor(Region))) +
      geom_bar(stat = "identity") +
      labs(x = "Feeling of Happiness", y = "Count") +
      theme_minimal()
    
    ggplotly(p)
  
})
  
  filteredFM <- reactive({
    happiness_year_sex <- happiness_plot %>%
      filter(Feeling_of_happiness >= 1 & Feeling_of_happiness <= 2) %>%
      group_by(Year, Sex) %>%
      summarise(col_mean = mean(Feeling_of_happiness), .groups = "drop") %>%
      filter(Sex == input$sexInput, Year == input$yearInput)
  })
  
  output$plot <- renderPlotly({
    happiness_year_sex <- happiness_plot %>%
      filter(Feeling_of_happiness >= 1 & Feeling_of_happiness <= 2) %>%
      group_by(Sex) %>%
      summarise(Happiness = sum(Feeling_of_happiness),
                Life_satisfaction = sum(Life_satisfaction), .groups = "drop") 
    # filter(Sex == input$sexInput, Year == input$yearInput)
    
    p <- ggplot(data = happiness_year_sex, aes(x = Life_satisfaction, y = Happiness, fill = factor(Sex))) +
      geom_bar(stat = "identity", position = position_dodge(), colour = "black") +
      scale_fill_manual(values = c("#999999", "#E69F00"))
    
    ggplotly(p)
  })
  
  happiness_year_age <- reactive({
    
    filtered_data <- happiness_plot %>%
      filter(Feeling_of_happiness >= 1 & Feeling_of_happiness <= 2) %>%
      group_by(Age) %>%
      summarise(col_mean = sum(Feeling_of_happiness), .groups = "drop")
    filtered_data
  })
  
  output$happiness_plot <- renderPlot({
    data <- happiness_year_age()
    
    ggplot(data, aes(x = Age, y = col_mean, color = Age)) +
      geom_point(size = 2) +
      xlab("Age") +
      ylab("Happiness")
  })
    
      
      }

server
  
