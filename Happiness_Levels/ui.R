library(shiny)
library(shinydashboard)
library(leaflet)



ui <- dashboardPage(
  skin = "black",
  dashboardHeader(title = "Happiness levels", titleWidth = 450),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Map", tabName = "Map", icon = icon("map")),
      menuItem("Plots", icon = icon("th"), tabName = "Plots")
    )
  ),
  dashboardBody(
    tags$head(tags$style(HTML('
      .main-header .logo {
        font-family: "Georgia", Times, "Times New Roman", serif;
        font-weight: bold;
        font-size: 24px;
      }
    '))),
    
    tabItems(
      tabItem(tabName = "Map",
              fluidPage(leafletOutput("mymap", height = 800))
      ),
      
      tabItem(tabName = "Plots",
              fluidPage(plotOutput("graph", height = 250)),
              selectInput("yearInput", "Select Year", choices = unique(happiness_plot$Year)),
              plotlyOutput("interactivePlot"),
              
              fluidRow(
                box(
                  title = "Happiness Females and Males",
                  plotlyOutput("plot", height = 250, width = 800)
                  
                  
                )
                 
              ),
              
              fluidRow(
                box(
                  title = "Happiness per Age",
                  plotOutput("happiness_plot", height = 250, width = 800))   

      ),
      
      fluidRow(
        box(
          title = "Top 10 happiest Countries",
          plotOutput("top10Plot", height = 250, width = 800)    
          
        )),
      
      tabItem(tabName = "Explanation"
        
      )
    )
  )
)
)