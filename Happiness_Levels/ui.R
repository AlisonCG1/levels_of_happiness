library(shiny)
library(shinydashboard)
library(leaflet)



ui <- dashboardPage(
  skin = "black",
  dashboardHeader(title = "Happiness levels", titleWidth = 450),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Introduction", tabName = "Intro", icon = icon("info")),
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
      tabItem(tabName = "Intro",
              fluidPage(
                titlePanel("Levels of Happiness, Shiny App"),
                HTML('
                  <h2>Project Overview</h2>
                  <p>Levels of happiness intents to measure happiness based on multiple categories as: age, sex, country, life satisfaction and financial satisfaction. As a sociologist I was curious to see how the world looks like in a data science perspective.</p>
                  <h2>Dataset</h2>
                  <p>The dataset used is from World Values Survey, which cointains waves of data from  1981 until 2022. However, this project only is focused on waves of data from 1990 until 2022.</p>
                  <h2>Variables</h2>
                  <p>The variables used as Levels of happiness are measured by the question "Feeling of happiness", with the following 4 categories:</p> 
                  <ul>
                  <li>Very Happy</li>
                  <li>Rather Happy</li>
                  <li>Not Very Happy</li>
                 <li>Not at all Happy</li>
                 </ul>
                 <p>The variables used as Levels of happiness are measured by the question "Satisfaction with your life", which is measured: 1. Dissatisfied to 10. satisfied :</p>
                  <p>For the purpose of measuring happiness, the plots and the map are calculated by the mean of happiness. Same with life satisfaction and financial satisfaction</p>
                 <h2>Purpose</h2>
                 <p>This project has the objective to answer the following questions:</p>
                 <ul>
                  <li>Are people happy and which countries have the best happiness levels?</li>
                  <li>How do people sense life satisfaction?</li>
                  <li>How do external conditions affect a country’s happiness?</li>
                 </ul>
                ')
              )
      ),
      
      tabItem(tabName = "Map",
              fluidPage(
                fluidRow(
                  column(width = 12,
                         leafletOutput("mymap", height = "800px") 
      )
      )
      )
      ),
      
      tabItem(tabName = "Plots",
              tabsetPanel(
                tabPanel(
                  "Happiess: Sex",
                  fluidPage(
                    fluidRow(
                    box(
                      title = "Happiness: Females and Males",
                      plotlyOutput("plot", height = 250)
                    )
                    ),
                    fluidRow(
                    box(
                      title = "Linear Model: F/M",
                      textOutput("text1"),
                      verbatimTextOutput("lmSummary")
                    )
                    ),
                    fluidRow(
                      box(
                        title = "Happiness: Age",
                        plotOutput("happiness_age", height = 250)
                      )
                    ),
                    
                    fluidRow(
                      box(
                        title = "Linear model: Age",
                        textOutput("text2"),
                        verbatimTextOutput("lmSummaryAge")
                      )
                    ),
                    fluidRow(
                      box(
                        title = "happiness: F/M Plot",
                        plotOutput("happinessFMPlot", height = 250)
                      )
                    ), 
                fluidRow(
                  box(
                    title = "linear model: F/M Plot",
                    textOutput("text3"),
                    verbatimTextOutput("lmSummaryAgeFM")
                  )
                ) 
              )
      ),
                
                tabPanel(
                  "top 20 countries",
                  fluidPage(
                    box(
                      title = "Happiness: Country",
                      plotOutput("top20countries", width = "800px", height = "600px")
                    )
                  ),
                  fluidRow(
                    box(
                      title = "Country happiness per Year",
                      plotOutput("country_plot",  width = "800px", height = "600px")
                    )
                ),
                
                fluidRow(
                  box(
                    title = "Linear Model: Country/Age",
                    textOutput("text4"),
                    verbatimTextOutput("lmSummarycountry")
                  )
                ) 
                
                ),
    
                tabPanel(
                  "Extra Findings",
                  fluidPage(
                    box(
                      title = "Happiness vs Life Satisfaction",
                      plotOutput("lifesatisfaction")
                    )
                  ),
                  fluidRow(
                    box(
                      title = "Linear Model: Life Satisfaction",
                      textOutput("text5"),
                      verbatimTextOutput("lmsummarylife")
                    )
                  ),
                  fluidPage(
                    box(
                      title = "Life Satisfaction:Age",
                      plotOutput("SatisfactionAge",  height = 300)
                    )
                  ),
      
                  fluidRow(
                    box(
                      title = "Life satisfaction: Sex",
                      plotOutput("SatisfactionYearAge",  height = 300) 
                )
              ),
              fluidRow(
                box(
                  title = "Linear Model: Life Satisfaction Age",
                  textOutput("text6"),
                  verbatimTextOutput("lmAgesatisfaction")
                )
              ),
              fluidRow(
                box(
                  title = "Happiness, Life Satisfaction and Financial Satisfaction",
                  plotOutput("happinessFinancialPlot",  height = 300)
                )
              ),
              fluidRow(
                box(
                  title = "Happiness, Life Satisfaction and Financial Satisfaction: Age/Sex",
                  plotOutput("FinancialPlot",  height = 300)
                )
              ),  
              fluidRow(
                box(
                  title = "Linear Model: Life Satisfaction",
                  verbatimTextOutput("lmFinancial")
                )
              )
      ),
          
      tabItem(tabName = "Findings"
              # Add content for the "Explanation" tab if needed
      )
    )
  )
)
)
)