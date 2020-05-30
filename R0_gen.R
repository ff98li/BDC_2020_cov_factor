# install.packages("tidyverse")
# install.packages("R0")
library("tidyverse")
library(R0)

owid_covid_data <- owid_covid_data %>% filter(new_cases >= 0)

location <- distinct(owid_covid_data, location) %>%
  pull(location)

# Remove locations with no outbreak
location <- location[!location %in% c("World",
                                      "International",
                                      "Western Sahara",
                                      "Hong Kong")]

basic_reproductive_numbers <- tibble(location = character(), R_0 = numeric())

for (l in location) {
  local_data <- owid_covid_data %>%
    filter(location == l)
  
  local_new_cases <- as.numeric(local_data$new_cases)
  names(local_new_cases) <- as.Date(local_data$date)
  
  # Finding the exp growth period
  case_count <- as.numeric(local_data$new_cases)
  begin <- match(0, case_count) + 2
  if (is.na(begin)) {
    begin <- 1
  }
  end <- length(case_count) - match(0, rev(case_count)) - 3
  if (is.na(end) || end <= begin) {
    end <- length(case_count)
  }
  R_squared_curr <- 0
  R_squared_max <- 1
  if (0 %in% case_count[begin:end] || begin == end) {
    begin <- 1
    end <- length(local_new_cases) - 1
  } else {
    while (end > begin && R_squared_curr < R_squared_max) {
      period <- tibble(Case = case_count[begin:end])
      period$Day <- seq.int(1, end - begin + 1)
      expoential.model <- lm(log(Case)~Day, period)
      if (R_squared_curr != 0) {
        R_squared_max <- R_squared_curr
      }
      R_squared_curr <- summary(expoential.model)$r.squared
      end <- end - 1
    } 
  }
  # Source of SI
  # https://wwwnc.cdc.gov/eid/article/26/6/20-0357_article
  mGT <- generation.time("gamma", c(3.96, 4.75))
  
  
  R0 <- est.R0.EG(local_new_cases,
                  mGT,
                  begin = begin,
                  end = end + 1)$R
  
  basic_reproductive_numbers = basic_reproductive_numbers %>%
    add_row(location = l, R_0 = R0)
}

#basic_reproductive_numbers %>%
#  write_csv("basic_reproductive_numbers.csv")