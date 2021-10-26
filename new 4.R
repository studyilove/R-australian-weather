data = read.csv("./app/weatherAUS.csv", encoding="UTF-8")
install.packages("dplyr")
install.packages("lubridate")
#data=na.omit(data)
data[is.na(data)] <- 0
library(dplyr)
library(lubridate)

library(shiny)
ui <- shinyUI(fluidPage(

  
  titlePanel("Wind direction changes in different areas of Australia in recent ten years"),
  
  sidebarLayout(    
    sidebarPanel(

      
     ("enter location and year 2008-2017"),
     selectInput("loc","select",c(unique(data$Location))),
     textInput("day","enter",""),
    ),   
    mainPanel( ("WindDir"),
               tableOutput("myy")      
          )
  )
))

server <- shinyServer(function(input,output){

    output$myy <- renderTable({
    s=data%>%filter(Location==input$loc & year(Date)==input$day)
    s[,c('Date','Location','WindDir9am','WindDir3pm')]

   
    
    })
})

shinyApp(ui = ui, server = server)