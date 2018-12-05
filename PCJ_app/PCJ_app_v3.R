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
library(haven)
library(rsconnect)
library(tidyverse)

all_data <- read_rds("/Users/soficorzo/finalproject/PCJ_ALL_clean.rds")
trials_data <- read_rds("/Users/soficorzo/finalproject/trials.rds")

# Define UI for application that draws a histogram
ui <- dashboardPage(
   
   # Application title
   dashboardHeader(title = "Post-Conflict Transitional Justice Mechanisms, 1946 - 2016",
                   titleWidth = 570),
   dashboardSidebar(
     width = 250,
     sidebarMenu(
       menuItem("About", tabName = "about_app", icon = icon("info", lib = "font-awesome")),
       menuItem("Transitional Justice at a Glance", tabName = "tj_glance", icon = icon("eye", lib = "font-awesome")),
       menuItem("Trials", tabName = "trials_tab", icon = icon("balance-scale", lib = "font-awesome"),
                badgeLabel = "ready!", badgeColor = "green"),
       menuItem("Truth Commissions", tabName = "truth_tab", icon = icon("comments", lib = "font-awesome")),
       menuItem("Reparations", tabName = "reparations_tab", icon = icon("hand-holding-usd", lib = "font-awesome")),
       menuItem("Amnesty", tabName = "amnesty_tab", icon = icon("flag", lib = "font-awesome")),
       menuItem("Purges", tabName = "purge_tab", icon = icon("user-slash", lib = "font-awesome")),
       menuItem("Exile", tabName = "exile_tab", icon = icon("plane-departure", lib = "font-awesome"))
     )
   ),
   
   # Body content
   
   dashboardBody(
     tabItems(
       # About application tab
       tabItem(tabName = "about_app",
       fluidRow(box(
         title = "Aim & Motivation",
         status = "info",
         solidHeader = TRUE,
         "This application aims to help transitional justice scholars identify post-conflict transitional
         justice mechanisms based on their distinct characteristics, in order to gain a more thorough understanding
         of how, where, and why trials, truth commissions, reparations, and so forth have been implemented following
         a period of conflict."),
         box(
           title = "Data Sources",
           status = "primary",
           solidHeader = TRUE,
           "I have used the Post-Conflict Justice (PCJ) Dataset created by the Peace Research Institute in Oslo. It is the most thorough and rigorously coded data source available,
           and I have also chosen it because the dataset has been used in dozens of articles in the Journal of Peace Research, the major journal regarding peace and conflict studies,
           as well as transitional justice."))),
      
       tabItem(tabName = "tj_glance"),
       
       # Trials
       tabItem(tabName = "trials_tab",
               h4("'The formal examination of alleged wrongdoing through judicial proceedings within a legal structure.' (PCJ Codebook, 2012)"),
               fluidRow(width = 6,
                        tabBox(title = tagList(shiny::icon("gear"), title = "SPECIFICATIONS"),
                        height = "250px",
                        selected = "Conflict",
                        id = "tabset1",
                        tabPanel("Conflict",
                                          sliderInput("conflict_date_trial",
                                                      label = "Conflict Episode Date",
                                                      min(trials_data$conflict_episode_begins), max(trials_data$conflict_episode_ends),
                                                      value = c(1970, 1980),
                                                      sep =""),
                                          selectInput("region_trial",
                                                      label = "Region",
                                                      choices = c("All", levels(trials_data$region)),
                                                      selected = "All",
                                                      multiple = TRUE),
                                          selectInput("conflict_type_trial",
                                                      label = "Type",
                                                      choices = levels(trials_data$conflict_type),
                                                      multiple = TRUE),
                                          h6(helpText(
                                            "An 'Internationalized internal' armed conflict refers to internal 
                                            conflicts that are also supplemented by international intervention 
                                            on either side (government or opposition).")),
                                          checkboxGroupInput("conflict_end_trial",
                                                             label = "End",
                                                             choices = levels(trials_data$conflict_end)),
                                          h6(helpText("'Bargained solutions' include peace agreements and ceasefires. 
                                                      Conflict terminations coded as 'Other' correspond to state failure and termination of colonial rule.")),
                                          radioButtons("civil_war_trial",
                                                       label = "Civil War?",
                                                       choices = levels(trials_data$civil_war),
                                                       selected = character(0)),
                                          h6(helpText("Civil war is defined as at least 1000 battle-related deaths for the duration of the conflict episode."))),
                                 tabPanel("Trial Actors",
                                 checkboxGroupInput("trial_sender",
                                                    label = "Trial sender",
                                                    choices = levels(trials_data$sender)),
                                 h6(helpText("Group who initiated the trial process. The 'international' option refers 
                                             to when neither the government nor the opposition are the instigators of 
                                             the post-conflict trial process"),
                                 checkboxGroupInput("trial_target", 
                                                    label = "Target of trial", 
                                                    choices = levels(trials_data$target))),
                                 selectInput("trial_scope",
                                             label = "Scope",
                                             choices = levels(trials_data$scope),
                                             multiple = TRUE),
                                 h6(helpText("The scope of the trial is defined by the amount of people it affected or reached, 
                                             specifically which groups or individuals were targeted throughout the process. This can range from single individuals (a certain general)
                                             to elites (rebel leaders) or a specific group(such as the military)."))),
                        tabPanel("Trial Characteristics",
                                 checkboxGroupInput("trial_setting",
                                                    label = "Trial setting:",
                                                    choices = levels(trials_data$setting)),
                                 h6(helpText("Domestic trials usually take place in the country of the conflict,
                                             while international trials involve international criminal prosecution, lawyers or judges
                                             from outside the country, and/or an international tribunal")),
                                 radioButtons("absentia",
                                              label = "In absentia?",
                                              choices = levels(trials_data$absentia),
                                              selected = character(0)),
                                 h6(helpText("Whether the target of the trial was tried in absentia.")),
                                 radioButtons("execution",
                                              label = "Did the trial involve an execution?",
                                              choices = levels(trials_data$execute),
                                              selected = character(0)),
                                 radioButtons("trial_breach",
                                              label = "Was there a breach of justice in the trial?",
                                              choices = levels(trials_data$breach),
                                              selected = character(0)),
                                 h6(helpText("A 'breach of justice' refers to a trial
                                             that was undertaken with weak legal standards or a
                                             deliberate breach of justice. For example, summary trials without due
                                             process, etc.")))),
                   box(title = "TABLE",
                       status = "info",
                       solidHeader = TRUE,
                              dataTableOutput("trials_table", width = "50%")))))))
                 
  
# Define server logic required to draw a histogram

server <- function(input, output) {
  output$trials_table <- renderDataTable({
    data <- trials_data
    data <- subset(
      data,
      conflict_episode_begins >= input$conflict_date_trial[1] &
        conflict_episode_ends <= input$conflict_date_trial[2])
      if (input$region_trial != "All"){
    data <- subset(
      data,
      region == input$region_trial
    )
      }
    data %>%
      rename(start_year = conflict_episode_begins,
             end_year = conflict_episode_ends) %>%
      select(start_year, end_year, location, government, opposition)
})}

# Run the application 
shinyApp(ui = ui, server = server)

