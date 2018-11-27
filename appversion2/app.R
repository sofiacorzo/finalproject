#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(ggplot2)
library(tidyverse)

# Define UI for application that draws a histogram
ui <- fluidPage(
  
  # Application title
  h1("Visualizing Post-Conflict Transitional Justice Mechanisms"),
  "by",
  strong("Sofía Corzo"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
      dateRangeInput("dates", label = h3("Date range")),
      
      hr(),
      fluidRow(column(4, verbatimTextOutput("value"))),
      sidebarPanel(radioButtons("region", label = h3("Region"),
                                choices = list("East Asia and the Pacific" = 1, 
                                               "Europe and Central Asia" = 2, 
                                               "Latin America and the Caribbean" = 3, 
                                               "Middle East and North Africa" = 4, 
                                               "South Asia" = 5, "Sub-Saharan Africa" = 6), 
                                selected = 1),
                   
                   hr(),
                   fluidRow(column(6, verbatimTextOutput("value")))), width = 9),
    
    # Show a plot of the generated distribution
    mainPanel(
      tabsetPanel(type = "tabs",
                  tabPanel("About This Project", verbatimTextOutput("about")),
                  tabPanel("Major Episodes of Political Violence", verbatimTextOutput("MEPV")),
                  tabPanel("Post-Conflict Transitional Justice", verbatimTextOutput("table"))))
  ))



# Define server logic required to draw a histogram
server <- function(input, output) {
  output$plot <- 
    renderPlot({
      PCJbyregion <- allconflicts %>%
        group_by(wbregion, acdid) %>%
        select(acdid, wbregion, location, pcj, epbegin, epend, epstartdate, ependdate, pperid)
      ggplot(data = PCJbyregion, aes(x = wbregion), y = pcj) + geom_col()
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
