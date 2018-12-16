# This is the starter code that will be useful for anyone wanting to explore the data I used to create my Shiny app on post-conflict
# transitional justice.


# Loading relevant libraries

library(ggplot2)
library(readr)
library(kableExtra)
library(haven) # Useful for reading .dta files
library(stringr)
library(tidyverse)
library(formattable) 
# Essential to replicate the aesthetics of the table in the final Shiny app.
# More information here: https://github.com/renkun-ken/formattable
library(DT)

# Automating download of the data. Original data also available on GitHub with
# the name "PCJ_all.dta" (if anyone wants to have a copy of the original .dta
# file)

download.file("http://www.justice-data.com/pcj-dataset/PCJ%20dataset%20-%20Binningsb%C3%B8%20et%20al%20JPR_49(5).dta", 
              "PCJ_all.dta")
PCJ_ALL <- read_dta("PCJ_all.dta")

PCJ_ALL_clean_tbl <- PCJ_ALL %>%
  select(- acdid, -pperid, -ccode, -EP08) %>%
  rename(conflict_episode_begins = epbegin,
         conflict_episode_ends = epend,
         conflict_ep_start_date = epstartdate,
         conflict_ep_end_date = ependdate,
         government = sidea,
         opposition = sideb,
         conflict_incompatibility = incomp,
         conflict_type = type,
         battle_deaths = btldeath, 
         civil_war = civilwar, 
         region = wbregion, 
         conflict_end = termination) %>%
  select(-ends_with("termpro"), -ends_with("prec")) %>%
  mutate(conflict_incompatibility = case_when(conflict_incompatibility == 1 ~ "Government",
                                              conflict_incompatibility == 2 ~ "Territory"),
         conflict_type = case_when(conflict_type == 1 ~ "Extrasystemic (Colonial)",
                                   conflict_type == 3 ~ "Internal",
                                   conflict_type == 4 ~ "Internationalized internal"),
         conflict_end = case_when(conflict_end == 1 ~ "Victory",
                                  conflict_end == 2 ~ "Bargained solution",
                                  conflict_end == 3 ~ "Other"),
         region = case_when(region == 1 ~ "East Asia and the Pacific",
                            region == 2 ~ "Europe and Central Asia",
                            region == 3 ~ "Latin America and the Caribbean",
                            region == 4 ~ "Middle East and North Africa",
                            region == 5 ~ "South Asia",
                            region == 6 ~ "Sub-Saharan Africa"),
         civil_war = case_when(civil_war == 0 ~ "No",
                               civil_war == 1 ~ "Yes")) %>%
  mutate(conflict_incompatibility = as.factor(conflict_incompatibility),
       conflict_type = fct_relevel(as.factor(conflict_type), "Victory", "Bargained solution", "Other"),
       conflict_end = as.factor(conflict_end),
       civil_war = fct_relevel(as.factor(civil_war), "Yes", "No"),
       region = as.factor(region)) %>%
  select(conflict_episode_begins,
         conflict_episode_ends,
         location,
         territory,
         government,
         opposition,
         starts_with("conflict"),
         battle_deaths,
         civil_war,
         region,
         starts_with("pcj"),
         -pcj_dummy,
         starts_with("trial"),
         -trial_intl,
         starts_with("truth"),
         starts_with("rep"),
         starts_with("amnesty"),
         starts_with("purge"),
         starts_with("exile")) %>%
  mutate(trial_target = case_when(trial_target == 1 ~ "Government",
                                  trial_target == 2 ~ "Opposition",
                                  trial_target == 3 ~ "Both"),
         trial_sender = case_when(trial_sender == 1 ~ "Government",
                                  trial_sender == 2 ~ "Opposition",
                                  trial_sender == 3 ~ "Both",
                                  trial_sender == 4 ~ "International",
                                  trial_sender == 5 ~ "Other"),
         trial_scope = case_when(trial_scope == 1 ~ "Single individuals",
                                 trial_scope == 2 ~ "Elites",
                                 trial_scope == 3 ~ "Specific group/Subset of group",
                                 trial_scope == 4 ~ "General group/Community"),
         trial_setting = case_when(trial_domestic == 1 ~ "Domestic",
                                   trial_domestic == 0 ~ "International")) %>%
  mutate(trial_target = fct_relevel(as.factor(trial_target), "Government", "Opposition", "Both"),
         trial_sender = as.factor(trial_sender),
         trial_scope = as.factor(trial_scope),
         trial_setting = as.factor(trial_setting),
         trial_absentia = as.factor(trial_absentia),
         trial_execute = as.factor(trial_execute),
         trial_breach = as.factor(trial_breach))
         

trials_tbl <- PCJ_ALL_clean_tbl %>%
  select(conflict_episode_begins,
         conflict_episode_ends,
         location,
         territory,
         government,
         opposition,
         starts_with("conflict"),
         starts_with("pcj"),
         battle_deaths, civil_war, region, 
         starts_with("trial")) %>%
  mutate(civil_war = fct_relevel(as.factor(civil_war), "Yes", "No")) %>%
  filter(trial == 1) %>%
  select(-trial) %>%
  select(-trial_domestic) %>%
  mutate(trial_date_start = paste(trial_day, trial_month, trial_year, sep = "-")) %>%
  select(-trial_day, -trial_month, -trial_year) %>%
  rename(target = trial_target,
         sender = trial_sender,
         scope = trial_scope,
         absentia = trial_absentia,
         execute = trial_execute,
         breach = trial_breach,
         setting = trial_setting) %>%
  mutate(breach = case_when(execute == 0 ~ "No",
                            execute == 1 ~ "Yes")) %>%
  mutate(absentia = case_when(absentia == 0 ~ "No",
                              absentia == 1 ~ "Yes"),
         execute = case_when(execute == 0 ~ "No",
                             execute == 1 ~ "Yes")) %>%
  mutate(absentia = fct_relevel(as.factor(absentia), "Yes", "No"),
         execute = fct_relevel(as.factor(execute), "Yes", "No"),
         breach = fct_relevel(as.factor(breach), "Yes", "No"))

PCJ_ALL_clean <- saveRDS(PCJ_ALL_clean_tbl, file = "PCJ_ALL_clean.rds")
trials <- saveRDS(trials_tbl, file = "trials.rds")
         



