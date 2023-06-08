library(shiny)
library(shinydashboard)
library(shinythemes)
library(leaflet)
library(plotly)
library(ggplot2)
library(DT)

server <- function(input, output) {
  
filtered_data <- reactive({
  filtered <- Happiness  # Replace 'Happiness' with your actual dataset
  
  # Remove rows with NaN values in happiness
  filtered <- filtered[!is.na(filtered$mean_feeling_of_happiness), ]
  # Remove rows with missing or invalid lat/lon values
  filtered <- filtered[complete.cases(filtered$Latitude, filtered$Longitude), ]
  
  # Join with the unhappiness_data based on 'Country' column
  filtered <- merge(filtered, unhappiness, by = "Country", all.x = TRUE)
  
  # Round the values
  filtered$mean_feeling_of_happiness <- round(filtered$mean_feeling_of_happiness, digits = 2)
  filtered$mean_life_satisfaction <- round(filtered$mean_life_satisfaction, digits = 2)
  
  filtered
  
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
                       "Life Satisfaction:", mean_life_satisfaction, "<br>") # Add the unhappiness mean
      )
  })
  
  output$graph <- renderPlot({
    happiness_plot %>%
      filter(Feeling_of_happiness >= 1 & Feeling_of_happiness <= 2) %>%
      group_by(Region) %>%
      summarise(col_mean = mean(Feeling_of_happiness), .groups = "drop")%>%
      ggplot(aes(x = col_mean, y = Region, fill = factor(Region))) +
      geom_bar(stat = "identity") +
      labs(x = "Feeling of Happiness", y = "Count") +
      theme_minimal() 
    
  })
  
  
  filteredData <- reactive({
    happiness_plot %>%
      mutate(Year = factor(Year, levels = 1990:2022)) %>%
      filter(Year == input$yearInput) %>%
      mutate(Feeling_of_happiness = ifelse(Feeling_of_happiness %in% c(1, 2), "Happiness", "Unhappiness"))
  })
  
  output$interactivePlot <- renderPlotly({
    filteredData <- filteredData()
    
    p <- ggplot(filteredData(), aes(x = Year, fill = Feeling_of_happiness)) +
      geom_bar(position = "fill") +
      labs(x = "Year", y = "Percentage") +
      scale_fill_manual(values = c("Happiness" = "green", "Unhappiness" = "#999999")) +
      facet_wrap(~ Region, ncol = 2) +
      theme_minimal() +
      scale_y_continuous(labels = scales::percent)
    
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
      summarise(Happiness = mean(Feeling_of_happiness),
                Life_satisfaction = mean(Life_satisfaction), .groups = "drop") 
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
      summarise(col_mean = mean(Feeling_of_happiness), .groups = "drop")
    filtered_data
  })
  
  output$happiness_plot <- renderPlot({
    data <- happiness_year_age()
    
    ggplot(data, aes(x = Age, y = col_mean, color = Age)) +
      geom_point(size = 2) +
      xlab("Age") +
      ylab("Happiness")
  })
  
     output$country_plot <- renderPlot({
      filtered_data <- happiness_plot %>%
        group_by(Country) %>%
        summarize(Rate = weighted.mean(Feeling_of_happiness))
      
      ggplot(filtered_data, aes(x = Country, y = Rate, size = Rate, fill = Country)) +
        geom_point(alpha = 0.5, shape = 21, color = "black") +
        scale_size(range = c(.1, 15), name = "Happiness per Country") +
        ylab("Happiness") +
        xlab("Country") +
        theme(axis.text.x = element_text(color = "black", size = 10, angle = 30, vjust = .9, hjust = 0.8),
              legend.position = "right",
              legend.title = element_text(colour = "black", size = 5, face = "bold"),
              legend.text = element_text(colour = "black", size = 5),
              legend.key = element_blank(),
              legend.key.size = unit(0.6, "cm"))
    
  })
    

      }

server
  
