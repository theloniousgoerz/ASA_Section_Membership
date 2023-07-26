# PDF Scraping 
# Thelonious Goerz 
# 7/02/23

rm(list=ls())
# Load Libraries
library(rJava)      
library(tabulizer)  
# remotes::install_github(c("ropensci/tabulizerjars", "ropensci/tabulizer"))
library(tabulizer)
library(tidyverse)
library(magrittr)


# Scrape

# Scrape Data
# 2008-2022 Section Memberships
ASA_Data <- extract_tables(
  file   = "./Data/Raw/section_membership_totals_comparison_2022.pdf", 
  method = "stream", 
  output = "data.frame", pages=1)

# Cleanup Data

## 2008-2022

ASA_Data %<>% data.frame()

# Fix Names

colnames(ASA_Data)[1] <- 'SectionName'
colnames(ASA_Data) <-  gsub('X', '', colnames(ASA_Data))

ASA_Data <- rename(ASA_Data, "Low22" = ".1",
       "Student22" = ".2",
       "Regular22" = ".3")

ASA_Data %>% 
  filter(SectionName !="") %>%
  pivot_longer(cols = c(starts_with("20")),
               names_to = "Year", values_to = "MembershipCount") %>%
  mutate(Year = as.numeric(Year),
         MembershipCount = str_replace(MembershipCount,pattern = ",",replacement = ""),
         MembershipCount = as.numeric(MembershipCount)) %>% view()

# Save Data
write_csv(ASA_Data,"./Data/Processed/ASAprocessed.csv")




