# This app has been created primarily with the package shinydashboard, as I knew
# I was going to use several tabs in my app. To learn more about shinydashboard
# see here: https://rstudio.github.io/shinydashboard/index.html

library(shiny)
library(ggplot2)
library(readr)
library(stringr)
library(shinydashboard)
library(DT)
library(haven)
library(rsconnect)
library(tidyverse)

# All RDS files can be accessed on the "data" folder on the original github, where this shiny app file is also located.

all_data <- read_rds("PCJ_ALL_clean.rds")
trials_data <- read_rds("trials.rds")


ui <- dashboardPage(
   
   # Application title
   dashboardHeader(title = "Post-Conflict Transitional Justice Mechanisms, 1946 - 2006",
                   titleWidth = 570),
   
   # All 8 menu items correspond to side tabs that can be accessed to look at
   # different transitional justice mechanisms and their characteristics. I am
   # using icons from the fontawesome library, accessed here:
   # https://fontawesome.com/icons?d=gallery
   
   dashboardSidebar(
     width = 250,
     sidebarMenu(
       menuItem("About", tabName = "about_app", icon = icon("info", lib = "font-awesome")),
       menuItem("Transitional Justice at a Glance", tabName = "tj_glance", icon = icon("eye", lib = "font-awesome")),
       menuItem("Trials", tabName = "trials_tab", icon = icon("balance-scale", lib = "font-awesome")),
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
         justice (PCJ) mechanisms from 1946-2006 based on their distinct characteristics, in order to gain a more thorough understanding
         of how, where, and under what conditions trials, truth commissions, reparations, and so forth have been 
         implemented following a period of conflict. Users will be able to examine PCJ mechanisms 
         and their unique characteristics by being able to create a customizable data table to fit specific 
         parameters and then download the table for their use. This project was inspired by the",
         a("Uppsala Conflict Data Program", href = "http://ucdp.uu.se/"), "with the", a("Peace Research Institute in Oslo", href = "https://www.prio.org/"),
        ", which allows users to explore different past and ongoing conflicts around the world. Ultimately, this app is meant to make data (which is publicly available)
        easier to understand in an interactive environment.", br(), h3("Instructions"), "To use this app, navigate to any of the selections on the sidebar and then use the different input options to render a data table.
        Once you have selected all the parameters you want, use the 'Download' button to download a data table with the specificed parameters." 
         ),
         box(
           title = "Data Sources",
           status = "primary",
           solidHeader = TRUE,
           "I have used the", a("Post-Conflict Justice (PCJ) Dataset", href = "http://www.justice-data.com/pcj-dataset"),
"created by the Peace Research Institute in Oslo, as it is the most thorough and rigorously coded data source available, 
and the dataset has been used in dozens of articles in the", a("Journal of Peace Research", href = "https://journals.sagepub.com/home/jpr"), 
", a major journal regarding peace and conflict studies,
           as well as transitional justice.")),

# I thought it was very important to let the user know that due to the way this
# data has been coded, it has certain limitations regarding the scope of the
# conflict episodes and PCJ mechanisms evaluated.


fluidRow(box(
  title = "Specifications and Limitations",
  status = "warning",
  solidHeader = FALSE, "The PCJ dataset has been coded very specifically, so I recommend anyone that wants to explore this dataset 
  further to read the", a("PCJ Codebook", href = "http://www.justice-data.com/pcj-dataset/PCJ%20codebook%20-%20Binningsb%C3%B8%20et%20al%20JPR_49(5).pdf"),
  "which includes the PRIO’s rationale for coding some conflicts or mechanisms in a certain way. 
  The PRIO defines a “conflict” as any episode with at least 25 annual battle-related deaths, and any “post-conflict” period as 
  the period lasting up to five years after the end of an internal armed conflict. All other relevant variable definitions will 
  be provided in their specific tabs. Most importantly, this app is not meant to be taken as a way to explore the causal relationships between a 
  conflict’s characteristics and its PCJ mechanisms, but to make PCJ mechanisms easier to identify, explore, and use in other 
  analyses."
  ),
  box(
    title = "Further Reading",
    color = "teal",
    "For further information on transitional justice, consult the", a("International Center for Transitional Justice", href = "https://www.ictj.org/about/transitional-justice"),
    ", the", a("Rule of Law Information", href = "https://www.ohchr.org/EN/Issues/RuleOfLaw/Pages/RuleOfLawIndex.aspx"), 
"from the UN Office of the High Commissioner for Human Rights, and the", a("Journal on Mass Conflict and Resistance", href = "http://www.sciencespo.fr/mass-violence-war-massacre-resistance/fr/document/transitional-justice-new-discipline-human-rights-0"),
"from Paris' SciencesPo. For a more detailed exploration behind the technical aspects of this project, consult", 
a("this GitHub repository.", href = "https://github.com/sofiacorzo/finalproject")
  ))),
      
       tabItem(tabName = "tj_glance"),


# All tabs regarding PCJ mechanisms follow a similar structure, where there is a
# tab box that allows users to define conflict parameters, then actor
# parameters, and then mechanism-specific parameters. All tabs also include a
# basic definition of what the PCJ mechanism is, directly from the PCJ codebook.
       
       # Trials
       tabItem(tabName = "trials_tab",
               h4(strong("'The formal examination of alleged wrongdoing through judicial proceedings within a legal structure'"), "(PCJ Codebook, 2012)."),
               br(),
               fluidRow(width = 6,
                        tabBox(title = tagList(shiny::icon("gear"), title = "SPECIFICATIONS"),
                        height = "250px",
                        selected = "Conflict",
                        id = "tabset1",
                        tabPanel("Conflict",
                                          sliderInput("conflict_date_trial",
                                                      label = "Conflict Episode Date",
                                                      min(trials_data$conflict_episode_begins), max(trials_data$conflict_episode_ends),
                                                      value = c(1950, 1980),
                                                      sep =""),
                                          selectInput("region_trial",
                                                      label = "Region",
                                                      choices = c("All", levels(trials_data$region)),
                                                      selected = "All",
                                                      multiple = TRUE),
                                          selectInput("conflict_type_trial",
                                                      label = "Type",
                                                      choices = c("All", levels(trials_data$conflict_type)),
                                                      selected = "All",
                                                      multiple = TRUE),
                                          h6(helpText(
                                            "An 'Internationalized internal' armed conflict refers to internal 
                                            conflicts that are also supplemented by international intervention 
                                            on either side (government or opposition).")),
                                          checkboxGroupInput("conflict_end_trial",
                                                             label = "End",
                                                             choices = levels(trials_data$conflict_end),
                                                             selected = "Victory"),
                                          h6(helpText("'Bargained solutions' include peace agreements and ceasefires. 
                                                      Conflict terminations coded as 'Other' correspond to state failure and termination of colonial rule.")),
                                          radioButtons("civil_war_trial",
                                                       label = "Civil War?",
                                                       choices = levels(trials_data$civil_war),
                                                       selected = "No"),
                                          h6(helpText("Civil war is defined as at least 1000 battle-related deaths for the duration of the conflict episode."))),
                                 tabPanel("Trial Actors",
                                 checkboxGroupInput("trial_sender",
                                                    label = "Trial sender",
                                                    choices = c("All", levels(trials_data$sender)),
                                                    selected = "All"),
                                 h6(helpText("Group who initiated the trial process. The 'international' option refers 
                                             to when neither the government nor the opposition are the instigators of 
                                             the post-conflict trial process")),
                                 checkboxGroupInput("trial_target", 
                                                    label = "Target of trial", 
                                                    choices = c("All", levels(trials_data$target)),
                                                    selected = "All"),
                                 selectInput("trial_scope",
                                             label = "Scope",
                                             choices = c("All", levels(trials_data$scope)),
                                             selected = "All",
                                             multiple = TRUE),
                                 h6(helpText("The scope of the trial is defined by the amount of people it affected or reached, 
                                             specifically which groups or individuals were targeted throughout the process. This can range from single individuals (a certain general)
                                             to elites (rebel leaders) or a specific group(such as the military)."))),
                        tabPanel("Trial Characteristics",
                                 checkboxGroupInput("trial_setting",
                                                    label = "Trial setting:",
                                                    choices = levels(trials_data$setting),
                                                    selected = "Domestic"),
                                 h6(helpText("Domestic trials usually take place in the country of the conflict,
                                             while international trials involve international criminal prosecution, lawyers or judges
                                             from outside the country, and/or an international tribunal")),
                                 radioButtons("absentia",
                                              label = "In absentia?",
                                              choices = levels(trials_data$absentia),
                                              selected = "No"),
                                 h6(helpText("Whether the target of the trial was tried in absentia.")),
                                 radioButtons("execution",
                                              label = "Did the trial involve an execution?",
                                              choices = levels(trials_data$execute),
                                              selected = "No"),
                                 radioButtons("trial_breach",
                                              label = "Was there a breach of justice in the trial?",
                                              choices = levels(trials_data$breach),
                                              selected = "No"),
                                 h6(helpText("A 'breach of justice' refers to a trial
                                             that was undertaken with weak legal standards or a
                                             deliberate breach of justice. For example, summary trials without due
                                             process, etc.")))),
                   box(title = "TABLE",
                       status = "info",
                       solidHeader = TRUE,
                              DTOutput("trials_table", width = "50%"),
                       downloadButton("download_trial", label = "Download Table")))))))
                 


server <- function(input, output) {
   output$trials_table <- renderDT({
    data <- trials_data
    data <- subset(
      data,
      conflict_episode_begins >= input$conflict_date_trial[1] &
        conflict_episode_ends <= input$conflict_date_trial[2])
    if (input$region_trial != "All") {
      data <- subset(
        data,
        region %in% input$region_trial
      )}
    if (input$conflict_type_trial != "All") {
      data <- subset(
        data,
        conflict_type %in% input$conflict_type_trial)}
    data <- subset(
      data, conflict_end %in% input$conflict_end_trial
    )
    data <- subset(
      data, civil_war == input$civil_war_trial)
    if (input$trial_sender != "All") {
      data <- subset(
        data,
        sender %in% input$trial_sender
      )}
    if (input$trial_target != "All") {
      data <- subset(
        data,
        target %in% input$trial_target
      )
    }
    if (input$trial_scope != "All") {
      data <- subset(
        data,
        scope %in% input$trial_scope
      )
    }
    data <- subset(
      data, setting %in% input$trial_setting)
    data <- subset(
      data, absentia == input$absentia)
    data <- subset(
      data, execute == input$execution
    )
    data <- subset(
      data, breach == input$trial_breach
    )
    data %>%
      rename(start_year = conflict_episode_begins,
             end_year = conflict_episode_ends) %>%
      select(start_year, end_year, territory, government, opposition)})
   
   output$download_trial <- downloadHandler("trials.csv", content = function(file){
     data <- trials_data
     data <- subset(
       data,
       conflict_episode_begins >= input$conflict_date_trial[1] &
         conflict_episode_ends <= input$conflict_date_trial[2])
     if (input$region_trial != "All") {
       data <- subset(
         data,
         region %in% input$region_trial
       )}
     if (input$conflict_type_trial != "All") {
       data <- subset(
         data,
         conflict_type %in% input$conflict_type_trial)}
     data <- subset(
       data, conflict_end %in% input$conflict_end_trial
     )
     data <- subset(
       data, civil_war == input$civil_war_trial)
     if (input$trial_sender != "All") {
       data <- subset(
         data,
         sender %in% input$trial_sender
       )}
     if (input$trial_target != "All") {
       data <- subset(
         data,
         target %in% input$trial_target
       )
     }
     if (input$trial_scope != "All") {
       data <- subset(
         data,
         scope %in% input$trial_scope
       )
     }
     data <- subset(
       data, setting %in% input$trial_setting)
     data <- subset(
       data, absentia == input$absentia)
     data <- subset(
       data, execute == input$execution
     )
     data <- subset(
       data, breach == input$trial_breach
     )
     write.csv(data, file, row.names = FALSE)
   })}

# Run the application 
shinyApp(ui = ui, server = server)

