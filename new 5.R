data = read.csv("./app/weatherAUS.csv", encoding="UTF-8")
install.packages("dplyr")
install.packages("lubridate")
#data=na.omit(data)
data[is.na(data)] <- 0
library(dplyr)
library(lubridate)
y=data$Date
data$date=year(y)

data['p']=data['Pressure3pm']-data['Pressure9am']
pre=data%>%group_by(Location,date)
pp=pre%>%summarise(
  ps=mean(p)  
)

library(shiny)
ui <- shinyUI(fluidPage(

  
  titlePanel("Changes of daily mean air pressure in major Australian cities in recent ten years"),
  
  sidebarLayout(    
    sidebarPanel(

      
     ("enter year 2008-2017"),
     textInput("y","","2008")
    ),   
    mainPanel( ("pressure"),
               plotOutput("myy")      
          )
  )
))

server <- shinyServer(function(input,output){

    output$myy <- renderPlot({

    v=pp%>%filter(date==input$y)

    plot(seq(1,10),v$ps[1:10],axes=FALSE,type='b', xlab='country',ylab='pressure')
    axis(2);box()
    axis(1,at=seq(1,10),labels=c(unlist(c(unique(v['Location'])))[1:10])
    )

    })
})

shinyApp(ui = ui, server = server)


