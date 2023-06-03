library(shiny)
library(shinydashboard)
library(leaflet)



ui <- dashboardPage(
  skin = "black",
  dashboardHeader(title = "Happiness levels", titleWidth = 450),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Map", tabName = "Map", icon = icon("map")),
      menuItem("Plots", icon = icon("th"), tabName = "Plots"),
      selectInput("country", "Country:", choices = unique(Happiness$Country))
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
              fluidPage(plotOutput("graph", height = 250))
      ),
      
      tabItem(tabName = "Explanation",
              fluidRow(
                box(
                  title = "Happiness Explained",
                  plotOutput("point", height = 250, width = 800)
                )
              )
      )
    )
  )
)