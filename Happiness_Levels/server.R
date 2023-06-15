library(shiny)
library(shinydashboard)
library(shinythemes)
library(leaflet)
library(plotly)
library(ggplot2)
library(DT)
library(leaflet.providers)
library(rgeos)

server <- function(input, output) {


  # Filter out NaN values from centroid_coords
  #filtered_coords <- centroid_coords[!is.nan(centroid_coords$mean_feeling_of_happiness), ]
  
      output$mymap <- renderLeaflet({
        pal <- colorBin("YlOrRd", domain = countries@data$mean_feeling_of_happiness)
        
        leaflet(countries) %>%
          addTiles() %>%
          addProviderTiles(providers$CartoDB.DarkMatter) %>%
          addLegend(position = "bottomright",
                    pal = pal,
                    values = ~mean_feeling_of_happiness,
                    title = "Mean Feeling of Happiness",
                    opacity = 1) %>%
          addPolygons(fillColor = ~pal(mean_feeling_of_happiness),
                      color = "#000000",
                      fillOpacity = 0.7,
                      smoothFactor = 0.2,
                      dashArray = "3",
                      highlightOptions = highlightOptions(
                        weight = 5,
                        color = "#666",
                        dashArray = "",
                        fillOpacity = 0.7,
                        bringToFront = TRUE),
                      label = labels,
                      labelOptions = labelOptions(
                        style = list("font-weight" = "normal", padding = "3px 8px"),
                        textsize = "15px",
                        direction = "auto"))
      })
  
  output$graph <- renderPlot({
    Happiness %>%
      filter(Feeling_of_happiness >= 1 & Feeling_of_happiness <= 2) %>%
      group_by(Region) %>%
      summarise(col_mean = mean(Feeling_of_happiness), .groups = "drop")%>%
      ggplot(aes(x = col_mean, y = Region, fill = factor(Region))) +
      geom_bar(stat = "identity") +
      labs(x = "Feeling of Happiness", y = "Count") +
      theme_minimal() 
    
  })
  
  
  filteredFM <- reactive({
    happiness_year_sex <- Happiness %>%
      filter(Feeling_of_happiness >= 1 & Feeling_of_happiness <= 2) %>%
      group_by(Year, Sex) %>%
      summarise(col_mean = mean(Feeling_of_happiness), .groups = "drop") %>%
      filter(Sex == input$sexInput, Year == input$yearInput)
  })
  
  output$plot <- renderPlotly({
    happiness_year_sex <- Happiness %>%
      filter(Feeling_of_happiness >= 1 & Feeling_of_happiness <= 2) %>%
      group_by(Sex) %>%
      summarise(Happiness = mean(Feeling_of_happiness),
                Life_satisfaction = mean(Life_satisfaction), .groups = "drop") 
    
    p <- ggplot(data = happiness_year_sex, aes(x = Life_satisfaction, y = Happiness, fill = factor(Sex))) +
      geom_bar(stat = "identity", position = position_dodge(), colour = "black") +
      scale_fill_manual(values = c("#999999", "#E69F00"))
    
    plotly::ggplotly(p) %>% 
      layout(legend = list(
        title = list(text = "Sex"),
        labels = list("Males", "Females")
      ))
  })
  
  happiness_age <- reactive({
    
    filtered_data <- Happiness %>%
      group_by(Age) %>%
      summarise(col_mean = mean(Feeling_of_happiness), .groups = "drop")
    filtered_data
  })
  
  output$happiness_age <- renderPlot({
    data <- happiness_age()
    
    ggplot(data, aes(x = Age, y = col_mean, color = Age)) +
      geom_point(size = 2) +
      xlab("Age") +
      ylab("Happiness")
  })
  
     output$country_plot <- renderPlot({
       filtered_Country_Year <- Happiness %>%
         group_by(Country) %>%
         summarize(Rate = weighted.mean(Feeling_of_happiness), .groups = "drop")%>%
         top_n(30, Country)
       
       # Plotting code
       ggplot(filtered_Country_Year, aes(x = Country, y = Rate, size = Rate, fill = Country)) +
         geom_point(alpha = 0.4, shape = 21, color = "black") +
         scale_size(range = c(.1, 15), name = "Happiness per Country") +
         ylab("Happiness") +
         xlab("Country") +
         theme(axis.text.x = element_text(color = "black", size = 8, angle = 30, vjust = .9, hjust = 0.8),
               legend.position = "right",
               legend.title = element_text(colour = "black", size = 10, face = "bold"),
               legend.text = element_text(colour = "black", size = 10),
               legend.key = element_blank(),
               legend.key.size = unit(0.6, "cm"))
       
       })
    
     output$happinessFMPlot <- renderPlot({
       # Previous code: Calculate happiness_year_age and plot the data
       
       happiness_year_age <- Happiness %>%
         group_by(Age, Sex) %>%
         summarise(col_mean = mean(Feeling_of_happiness), .groups = "drop")
       
       # Convert Sex to a factor
       happiness_year_age$Sex <- factor(happiness_year_age$Sex,
                                        labels = c("Males", "Females"))
       
       # Plot the data
       ggplot(happiness_year_age, aes(x = Age, y = col_mean, color = Sex)) +
         geom_point(size = 2) +
         xlab("Age") +
         ylab("Happiness") +
         scale_color_manual(labels = c("Males", "Females"),
                            values = c("blue", "pink"))
     })
     
     output$top20countries <- renderPlot({
       # Add your data processing code here
       filtered_Country <- Happiness %>%
         group_by(Country) %>%
         summarize(Rate = weighted.mean(Feeling_of_happiness)) %>%
         top_n(20, Rate)
       
       # Plotting code
       ggplot(filtered_Country, aes(x = Country, y = Rate, size = Rate, fill = Country)) +
         geom_point(alpha = 0.5, shape = 21, color = "black") +
         scale_size(range = c(.1, 15), name = "Happiness per Country") +
         ylab("Happiness") +
         xlab("Country") +
         theme(axis.text.x = element_text(color = "black", size = 8, angle = 30, vjust = .9, hjust = 0.8),
               legend.position = "right",
               legend.title = element_text(colour = "black", size = 10, face = "bold"),
               legend.text = element_text(colour = "black", size = 10),
               legend.key = element_blank(),
               legend.key.size = unit(0.6, "cm")) 
     })
    
     output$lifesatisfaction <- renderPlot({
      plot_country<- all_happiness %>%
       group_by(Country) %>%
         summarize(happiness = weighted.mean(Feeling_of_happiness),
                   satisfaction  = weighted.mean(Life_satisfaction))
       
       ggplot(data = plot_country, aes(x = happiness, y = satisfaction)) +
         geom_point() +
         xlab("Happiness") +
         ylab("Life Satisfaction") +
         ggtitle("Happiness vs. Life Satisfaction")
     })
     
     output$SatisfactionAge <- renderPlot({
       # Perform data manipulation
       plot_Age <- Happiness %>%
         group_by(Age) %>%
         summarize(
           satisfaction = weighted.mean(Life_satisfaction),
           .groups = "drop"
         )
       
       # Create the ggplot
       ggplot(data = plot_Age, aes(x = Age, y = satisfaction, color = Age)) +
         geom_point() +
         xlab("Life Satisfaction") +
         ylab("Age") +
         ggtitle("Life Satisfaction and Age")
     
     })
     
     output$SatisfactionYearAge <- renderPlot({
       
       happiness_year_age <- Happiness %>%
         group_by(Age, Sex) %>%
         summarise(satisfaction = mean(Life_satisfaction), .groups = "drop")
       
       happiness_year_age$Sex <- factor(happiness_year_age$Sex, labels = c("Males", "Females"))
       
       labels <- c("Males", "Females")
       
       # Create the plot with adjusted size
       ggplot(happiness_year_age, aes(x = Age, y = satisfaction, color = Sex)) +
         geom_point(size = 3) +
         xlab("Age") +
         ylab("Life satisfaction") +
         scale_color_manual(labels = labels, values = c("blue", "pink")) +
         theme(
           plot.title = element_text(size = 16),  
           axis.title = element_text(size = 14),  
           legend.title = element_text(size = 14),  
           legend.text = element_text(size = 12),  
           legend.key.size = unit(1.5, "lines")  
         )
       
     })
     
     output$happinessFinancialPlot <- renderPlot({
       plot_country2 <- Happiness %>%
         group_by(Country) %>%
         summarize(happiness = weighted.mean(Feeling_of_happiness),
                   money = weighted.mean(Financial_satisfaction))
       
       ggplot(data = plot_country2, aes(x = happiness, y = money)) +
         geom_point() +
         xlab("Happiness") +
         ylab("Financial satisfaction") +
         ggtitle("Happiness vs. Financial Satisfaction")
     })
     
     output$FinancialPlot <- renderPlot({
       happiness_year_age <- Happiness %>%
         group_by(Age, Sex) %>%
         summarise(Money = mean(Financial_satisfaction), .groups = "drop")
       
       happiness_year_age$Sex <- factor(happiness_year_age$Sex, labels = c("Males", "Females"))
       
       labels <- c("Males", "Females")
       colors <- c("blue", "pink")
       
       # Create the plot with adjusted size
       ggplot(happiness_year_age, aes(x = Age, y = Money, color = Sex)) +
         geom_point(size = 3) +
         xlab("Age") +
         ylab("Financial satisfaction") +
         scale_color_manual(labels = labels, values = colors) +
         theme(
           plot.margin = margin(1, 1, 1, 1, "cm")  # Adjust the margin size here
         )
     })
     
     lmSex <- reactive({

       lm(Feeling_of_happiness ~ Sex, data = Happiness)
     })
     
     output$lmSummary <- renderPrint({
       summary(lmSex())
     })
     
     output$text1 <- renderText("The coefficients in the following linear model shows the relationship between happiness and sex. The estimated coefficient of 0.011997 suggests
                               that women are slighly happier than men.")
     
     lmAge <- reactive({
       lm(Feeling_of_happiness~Age, data = Happiness)
     })
     
     output$lmSummaryAge <- renderPrint({
       summary(lmAge())
     })
     
     output$text2 <- renderText("The coefficients in the following linear model show the relationship between happiness and age. where in this case, happiness does not necesarily increase 
                     by age. However, the relationship between age and happiness is not statistically significant.")
     
     lmAgeFM <- reactive({
       lm(Feeling_of_happiness ~ Sex + Age, data = Happiness)
     })
     
     output$lmSummaryAgeFM <- renderPrint({
       summary(lmAgeFM())
     })
     
     output$text3 <- renderText("The coefficients in the following linear model show the relationship between, sex, age, and happiness. The coefficients of this model show that on average, women are 1.255 have a slightly higher level of happiness compared to males, after controlling for age.
                                As for the coefficient of age, there is a negative relationship between age and feeling of happiness.")
     
     lmcountryage <- reactive({
       lm(Feeling_of_happiness ~ Sex + Age + Country, data = Happiness)
     })
     
     output$lmSummarycountry <- renderPrint({
       summary(lmcountryage())
     })
     
     output$text4 <- renderText("The coefficients in the following linear model show the relationship between, country, sex, and age. the model suggests that even thoug sex shows a small relationship with happiness, age is still not that relevant in happiness. In terms of the country, each coefficient shows the relationship between happiness and the country.")
     
     lmlifesatisfaction <- reactive({
       lm(Feeling_of_happiness ~ Life_satisfaction, data = Happiness)
     })
     
     output$lmsummarylife <- renderPrint({
       summary(lmlifesatisfaction())
     })
     
     output$text5 <- renderText("This linear model represents the relationship between happiness and life satisfaction. It indicates that for each unit increase of life satisfaction there's an increase in happiness")
     
     lmAgesatisfaction <- reactive({
       lm(Life_satisfaction ~ Age + Sex, data = Happiness)
     })
     
     output$lmsummaryAgelife <- renderPrint({
       summary(lmAgesatisfaction())
     })
     
     output$lmAgesatisfaction <- renderPrint({
       lmSummary <- summary(lmAgesatisfaction())
       return(lmSummary)
     })
     
     output$text6 <- renderText("This linear model represent the relationship between life satisfaction, sex and age. this model show that the increase of age, life satisfaction algo increases. However, the relationship between these two variables ((p-value = 0.206)) suggests that age may not have a significant impact on life satisfaction in this model.
                                The coefficient of sex, indicates that on average, females have a 0.0375910 unit higher in life satisfaction compared to males")
     
     lmFinancial <- reactive({
       
       lm(Feeling_of_happiness ~ Life_satisfaction + Financial_satisfaction, data = Happiness)
     })
     
     output$lmFinancialSummary <- renderPrint({
       summary(lmFinancial())
})
     output$lmFinancial <- renderPrint({
       lmSummary <- summary(lmFinancial())
       return(lmSummary)
     })
     
     output$text7 <- renderText("This linear model represents the relationship between happiness, life satisfaction and financial satisfacion, where there is a constant between life satisfaction increasing one unit as happiness increases by 0.1215623. Also, financial satisfaction  is associated with a 0.0352582 increase in happiness.")
      }

server
  
