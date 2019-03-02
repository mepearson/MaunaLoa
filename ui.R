library(shiny)
library(plotly)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Mauna Loa CO2 levels: 1959-present"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
      p('Enter a date on or after March 1, 1958 then hit submit to see how average global CO2 has increased since that date.'),
      hr()
,      dateInput(
        inputId =  "birthdate", 
        label = "Enter date (after 1958)", 
        format = "mm/dd/yyyy",
        value=Sys.Date()
      ),
      submitButton(text = "Submit", icon = NULL, width = NULL),
      hr(),
      htmlOutput("co2")
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
       plotlyOutput("co2Plot")
       
    )
  ),
  hr(),
  p("This page utilizes CO2 data provided by NOAA and presented using a Shiny interface for R data. The ui.R and server.R files for
        the application are available at [github link]"),
  p("Data from Dr. Pieter Tans, NOAA/ESRL (www.esrl.noaa.gov/gmd/ccgg/trends/) and Dr. Ralph Keeling, Scripps Institution of Oceanography (scrippsco2.ucsd.edu/).")
))
