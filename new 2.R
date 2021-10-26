data = read.csv("./app/weatherAUS.csv", encoding="UTF-8")
install.packages("dplyr")
install.packages("lubridate")
#data=na.omit(data)
data[is.na(data)] <- 0
library(dplyr)
library(lubridate)
y=data$Date
data$date=year(y)

s=data%>%group_by(Location)%>%summarise(fall=sum(Rainfall))
library(maps)
df <- world.cities[world.cities$country.etc == "Australia",]

colnames(s)[1]='name'
dff=merge(s,df,by='name')
dff

install.packages("leaflet")
library(leaflet)


library(shiny)
ui <- shinyUI(bootstrapPage(

  
  tags$style(type = "text/css", "html, body {width:100%;height:100%}"),
  leafletOutput("map", width = "100%", height = "100%"),
      
    absolutePanel(top = 10, right = 10,

      
     ("select location"),
     selectInput("loc","rainfall",c(dff['name']))
     
    ),   
  )
)

server <- shinyServer(function(input,output,session){
   pal <- colorNumeric(palette = "YlOrRd",
                    domain = dff$fall)

   m=leaflet() %>%addCircles(lng = dff$long, lat = dff$lat, weight = 1,radius = 2000*30,color= pal(dff$fall),
    stroke = FALSE, fillOpacity = 0.7)%>%
    addLegend(position = "bottomleft", pal = pal, values = dff$fall) 
   
   dd<-reactive({
     dff%>%filter(name==input$loc)
    })

    
    output$map <- renderLeaflet({
      ff=dd()
     
    
     m %>%         
     addTiles() %>% 
     addMarkers(lng=ff$long, lat=ff$lat, label=as.character(ff$fall)) %>%
     setView(lng=150, lat=-33.852, zoom = 5)
             
    
    })
})

shinyApp(ui = ui, server = server)
