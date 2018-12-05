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
library(readr)
library(stringr)
library(shinydashboard)
library(DT)
library(formattable)
library(haven)
library(tidyverse)

all_data <- read_rds("/Users/soficorzo/finalproject/PCJ_ALL_clean.rds")
trials_data <- read_rds("/Users/soficorzo/finalproject/trials.rds")

# Define UI for application that draws a histogram
ui <- dashboardPage(
   
   # Application title
   dashboardHeader(title = "Post-Conflict Transitional Justice Mechanisms, 1946 - 2016",
                   titleWidth = 570),
   dashboardSidebar(
     width = 310,
     sidebarMenu(
       menuItem("About this Application", tabName = "about_app", icon = icon("info", lib = "font-awesome")),
       menuItem("Transitional Justice Mechanisms at a Glance", tabName = "tj_glance", icon = icon("eye", lib = "font-awesome")),
       menuItem("Trials", tabName = "trials_tab", icon = icon("balance-scale", lib = "font-awesome"))
     )
   ),
   
   # Body content
   
   dashboardBody(
     tabItems(
       # About application tab
       tabItem(tabName = "about_app",
       fluidRow(box(br("About")))),
      
       tabItem(tabName = "tj_glance"),
       
       # Trials
       tabItem(tabName = "trials_tab",
               h4("'The formal examination of alleged wrongdoing through judicial proceedings within a legal structure.' (PCJ Codebook, 2012)"),
               fluidRow(
                 tabBox(title = tagList(shiny::icon("gear"), title = "SPECIFICATIONS"),
                        height = "250px", side = "right",
                        id = "tabset1",
                        tabPanel("Trial",
                                 checkboxGroupInput("trial_target", 
                                                    label = "Target of trial", 
                                                    choices = levels(trials_data$target))),
                        tabPanel("Conflict",
                     sliderInput("conflict_date_trial",
                                 label = "Conflict Episode Date",
                                 min(trials_data$conflict_episode_begins), max(trials_data$conflict_episode_ends),
                                 value = c(1970, 1980),
                                 sep =""),
                     selectInput("region_trial",
                                 label = "Region",
                                 choices = levels(trials_data$region),
                                 multiple = TRUE)))),
               fluidRow(width = 6,
                   box(title = "TABLE",
                              dataTableOutput("trials_table")))))))
                 
  
# Define server logic required to draw a histogram
server <- function(input, output) {
  output$trials_table <- renderDataTable({
    subset(trials_data, target == input$trial_target &
             conflict_episode_begins >= input$conflict_date_trial[1] & 
             conflict_episode_ends <= input$conflict_date_trial[2] &
             region == input$region_trial)})}

# Run the application 
shinyApp(ui = ui, server = server)

