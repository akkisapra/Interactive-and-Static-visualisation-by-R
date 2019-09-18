# server.R
#Author Akshay Sapra: 29858186
# Task 3, 4 & 5
#install.packages("tibble")
#install.packages("shiny")


library(shiny)
library(leaflet)
library(datasets)
library(ggplot2) # load ggplot

# Reading the data
corals = read.csv("assignment-02-data-formated.csv", header=TRUE, sep=',')
corals$value =as.numeric(gsub("%","",as.character(corals$value)))

shinyServer(function(input, output) {
  # Return the formula text for printing as a caption
  output$caption <- reactiveText(function() {
    paste("Bleaching in each year")
  })
#Sort the data
  corals<-corals[order(corals$latitude),]
  coralslocation<-unique(corals$location)
  corals$location<-factor((corals$location),levels=coralslocation)
  


  #plot for the tabular graph on 1st tab  
  output$coralPlot <- renderPlot({
    # check for the input variable
    # ggplot version
    myGraph = ggplot ( data = corals[corals$coralType %in% input$Cora, ], aes (x = year,y = value,color=location))
    myGraph+geom_point()+ facet_grid(location~coralType)+ geom_smooth(aes(group = 1), method = input$Smoothers)+labs(y="Percentage", x="Year")

    
  
  })
  #plot for the map in accordance with the average size in tab 2  
  output$mapPlot <- renderLeaflet({
    pal <- colorFactor(c("#F8766D", "#CD9600", "#7CAE00","#00BE67", "#00BFC4", "#00A9FF", "#C77CFF", "#FF61CC"), corals$location)
    
    leaflet(data = corals[corals$coralType == input$CoralT,]) %>% addTiles() %>%
      addCircles(~longitude, ~latitude,  ~mean(corals[corals$coralType == input$CoralT,]$value)^3, color = ~pal(location),
                 group = ~location, popup = ~as.character(location))
      
   
    
  })
  #plot for the map in accordance with the colour and poppup from the graph in tab 1  
  output$mapPlot1 <- renderLeaflet({
    pal <- colorFactor(c("#F8766D", "#CD9600", "#7CAE00","#00BE67", "#00BFC4", "#00A9FF", "#C77CFF", "#FF61CC"), corals$location)
    
    leaflet(data = corals[corals$coralType %in%input$Cora,]) %>% addTiles() %>%
      addCircles(~longitude, ~latitude, ~mean(corals[corals$coralType %in% input$Cora,]$value)^3, color = ~pal(location),
                  popup = ~as.character(location))%>%
      addPopups(~longitude, ~latitude, ~as.character(location)) 
      
    
    
    
  })
})
