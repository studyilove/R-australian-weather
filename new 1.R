data = read.csv("./app/weatherAUS.csv", encoding="UTF-8")
install.packages("dplyr")
install.packages("lubridate")
#data=na.omit(data)
data[is.na(data)] <- 0
library(dplyr)
library(lubridate)
y=data$Date
data$date=year(y)

rain=data%>%group_by(Location,date)
r=rain%>% summarise(
  fall=sum(Rainfall)
  
)

library(shiny)
ui <- shinyUI(fluidPage(

  
  titlePanel("Changes in annual average rainfall in major Australian cities over the past decade"),
  
  sidebarLayout(    
    sidebarPanel(

      
     ("enter year 2008-2017"),
     textInput("y","rainfall","2008")
    ),   
    mainPanel( ("rainfall"),
               plotOutput("myy")      
          )
  )
))

server <- shinyServer(function(input,output){

    output$myy <- renderPlot({

    v=r%>%filter(date==input$y)

    plot(seq(1,10),v$fall[1:10],axes=FALSE,type='b', xlab='country',ylab='rainfall')
    axis(2);box()
    axis(1,at=seq(1,10),labels=c(unlist(c(unique(v['Location'])))[1:10])
    )

    })
})

shinyApp(ui = ui, server = server)