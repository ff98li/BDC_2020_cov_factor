# This script generates CFR.csv
# Data latest updated on May 25
# install.packages("tidyverse")
library("tidyverse")

covid_19_clean_complete <- read_csv("covid_19_clean_complete.csv")

covid_19_clean_complete <- covid_19_clean_complete %>%
  mutate_at("Date", funs(paste(.,"20",sep = "")))

covid_19_clean_complete$Date <- as.Date.character(covid_19_clean_complete$Date,
                                                  format = "%m/%d/%y")

covid_19_clean_complete_may25 <- covid_19_clean_complete_may25 %>%
  rename(Country_Region = 'Country/Region')

CFR <- covid_19_clean_complete_may25 %>%
  group_by(Country_Region) %>%
  summarise(CFR = sum(Deaths)/sum(Confirmed))

CFR$Country_Region <- gsub("US", "United States", CFR$Country_Region)
CFR$Country_Region <- gsub("Czechia", "Czech Republic", CFR$Country_Region)
CFR$Country_Region <- gsub("Congo (Kinshasa)",
                           "Democratic Republic of Congo",
                           CFR$Country_Region)

CFR %>% write_csv("CFR.csv")