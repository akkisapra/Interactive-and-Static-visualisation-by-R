# ui.R
#Author Akshay Sapra: 29858186
# Task 3, 4 & 5
library(shiny)
library(leaflet)

# Define UI for miles per gallon application
shinyUI(fluidPage(
  
  # Application title
  headerPanel("Coral Options"),
  # Sidebar with controls to select the variable to plot against
  sidebarLayout(
    sidebarPanel(
      #creating tab to display views
      tabsetPanel(
        tabPanel("Statastics", value = 1),
        tabPanel("Map", value = 2),
        id ="tab"
      ),
      
      conditionalPanel(condition= "input.tab == 1",
                       checkboxGroupInput(inputId='Cora', label = "Corals", c("blue corals"= "blue corals",
                                                                               "soft corals"  = "soft corals",
                                                                               "hard corals" = "hard corals",
                                                                               "sea pens" = "sea pens",   
                                                                               "sea fans"= "sea fans"), selected = "blue corals"
                                                                                                                  
                       ),
                       selectInput("Smoothers","Please select Smoother", c("lm","gam","glm","auto"))
                       
      ),
      
      conditionalPanel(condition = "input.tab==2",
                       selectInput("CoralT", "Please select Corals:", c("blue corals","soft corals","hard corals","sea pens","sea fans"))
      )
    ),
    
    
    # Show the caption and plot of the requested coral against site
    mainPanel(
      
      conditionalPanel(condition = "input.tab==1",
                       h3(textOutput("caption")),
                       plotOutput("coralPlot"),
                       leafletOutput("mapPlot1")
      ),
      conditionalPanel(condition = "input.tab==2",
                       leafletOutput("mapPlot")
                      
                       
      )
    )
  )
))