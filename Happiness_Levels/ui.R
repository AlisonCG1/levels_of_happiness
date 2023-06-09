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
              tabsetPanel(
                tabPanel(
                  "Happiness per region",
                  fluidPage(
                    plotOutput("graph", height = 250),
                    selectInput("yearInput", "Select Year", choices = unique(happiness_plot$Year)),
                    plotlyOutput("interactivePlot")
                  )
                ),
                tabPanel(
                  "Happiess per F/M",
                  fluidPage(
                    fluidRow(
                    box(
                      title = "Happiness Females and Males",
                      plotlyOutput("plot", height = 250)
                    )
                    ),
                    fluidRow(
                    box(
                      title = "Linear Model F/M",
                      verbatimTextOutput("lmSummary")
                    )
                    ),
                    fluidRow(
                      box(
                        title = "Happiness Age",
                        plotOutput("happiness_age", height = 250)
                      )
                    ),
                    
                    fluidRow(
                      box(
                        title = "Linear model age",
                        verbatimTextOutput("lmSummaryAge")
                      )
                    ),
                    fluidRow(
                      box(
                        title = "happiness F/M Plot",
                        plotOutput("happinessFMPlot", height = 250)
                      )
                    ), 
                fluidRow(
                  box(
                    title = "linear model F/M Plot",
                    verbatimTextOutput("lmSummaryAgeFM")
                  )
                ) 
              )
      ),
                
                tabPanel(
                  "Happiness per Country",
                  fluidPage(
                    box(
                      title = "Happiness per country",
                      plotOutput("country_plot", width = "800px", height = "600px")
                    )
                  )
                ),
                tabPanel(
                  "in progress...",
                  fluidPage(
                    box(
                      title = "Top 10 happiest Countries",
                      plotOutput("top10Plot")
                    )
                  )
                )
              )
      ),
      
      tabItem(tabName = "Findings"
              # Add content for the "Explanation" tab if needed
      )
    )
  )
)