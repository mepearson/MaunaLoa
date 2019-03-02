
#Load libraries and Data
library(shiny)
library(plotly)
library(lubridate)
library(dplyr)

#Get Data from NOAA hosted site
co2URL <- 'ftp://aftp.cmdl.noaa.gov/products/trends/co2/co2_mm_mlo.txt'
ml <- read.table(co2URL)
#Rename columns to useful labels for data filtering
colnames(ml) <- c("Year","Month", "decimal","average","interpolated","trend","other" )

#Calculate recent data and initialize data input to this value
recentAvg <- ml[nrow(ml),6]
recentDecimal <- ml[nrow(ml),3]
testAvg <- recentAvg
testDecimal <- recentDecimal

# Define server logic required to draw a histogram
shinyServer(function(input, output,session) {
  #Get Basic Values when birthdate changes
  #birthMonth <- reactive({month(as.POSIXlt(input$birthdate, format="%m/%d/%Y"))}) 
  #birthYear <- reactive({year(as.POSIXlt(input$birthdate, format="%m/%d/%Y"))})
  #monthName <- reactive({month.name[birthMonth()]})
  #mlB <- ml
  #mlB <- reactive({ mlB() %>% filter(Year == birthYear()) %>% filter(Month == 2) })
  #mlBirth <- ml %>% filter(Month == 2) 
  #mlBirth <-  reactive({ ml %>% filter(Month == birthMonth()) %>% filter(Year == birthYear()) })
  
  #birthCO2 <-   reactive({  mlBirth()})
  #birthCO2Seasonal <-   reactive({ mlBirth()[,6] })
  #co2Increase <-   recentAvg - birthCO2Seasonal() 
  #increasePercent <-   (100 * recentAvg / birthCO2Seasonal())  

  
  output$co2Plot <- renderPlotly({
    if(input$birthdate  != Sys.Date()) {
      birthMonth <- month(as.POSIXlt(input$birthdate, format="%m/%d/%Y"))
      birthYear <- year(as.POSIXlt(input$birthdate, format="%m/%d/%Y"))
      monthName <- month.name[birthMonth]
      mlBirth <-  ml %>% filter(Month == birthMonth) %>% filter(Year == birthYear) 
      testAvg <-   mlBirth[,6] 
      testDecimal <-   mlBirth[,3] }
    p <- plot_ly(ml) %>% add_trace(x=~decimal, y=~interpolated, type = 'scatter', mode = 'lines', name="Monthly Average", transforms = list(
           list(
                 type = 'filter',
                 target = 'y',
                 operation = '>',
                 value = 0
             )
      )) %>% add_trace(x=~decimal, y=~trend, type = 'scatter', mode = 'lines', name="Seasonally Adjusted Trend") %>%
        layout(legend = list(x = 0.05, y = .95), xaxis=list(title='Date'),yaxis=list(title='CO<sub>2</sub> [ppm]'))%>%
      add_markers(x=testDecimal, y = testAvg,name="Input",marker=list(symbol=~17 , size=25 , color="orange", text='input'))  %>%
      add_markers(x=recentDecimal, y = recentAvg,name="Today",marker=list(symbol=~17 , size=25 , color="red", text='today')) 
    
  })
  
  output$co2<- renderText({ 

    if(input$birthdate  != Sys.Date()) {
    birthMonth <- month(as.POSIXlt(input$birthdate, format="%m/%d/%Y"))
    birthYear <- year(as.POSIXlt(input$birthdate, format="%m/%d/%Y"))
    monthName <- month.name[birthMonth]
    mlBirth <-  ml %>% filter(Month == birthMonth) %>% filter(Year == birthYear) 
    birthCO2 <-   mlBirth[,5] 
    birthCO2Seasonal <-   round(mlBirth[,6],1) 
    co2Increase <-   round((recentAvg - birthCO2Seasonal),1) 
    increasePercent <-   round((100 * recentAvg / birthCO2Seasonal),0)  
     # paste('In','mn','of')
      paste('<h4>Global Average CO2:</h4>',monthName,birthYear,': <b>',birthCO2Seasonal,'</b>ppm<br />Today:<b>',recentAvg,'</b> ppm<br /><br />
            <b> Increase:</b> <br/>',co2Increase,'ppm <br />', increasePercent,'% ') 
      
    }
  })
  

  
})
