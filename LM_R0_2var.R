library(tidyverse)

two_var <- read_csv("two_var.csv")
basic_reproductive_numbers <- read_csv("basic_reproductive_numbers.csv")

two_var <- two_var[,
                   !(names(two_var) %in% setdiff(
                     colnames(two_var),
                     basic_reproductive_numbers$location
                   )
                   )
                   ]

two_var <- two_var %>%
  rownames_to_column() %>%
  pivot_longer(-rowname) %>%
  pivot_wider(names_from = rowname)

names(two_var)[names(two_var) == "name"] <- "location"
names(two_var)[names(two_var) == "1"] <- "population"
names(two_var)[names(two_var) == "2"] <- "obesity"

two_var <- merge(
  two_var, basic_reproductive_numbers,
  by.x = 'location', by.y = 'location'
)

mod_population <- lm(R_0 ~ population, data = two_var)
mod_obseity <- lm(R_0 ~ obesity, data = two_var)

two_var %>%
  ggplot(aes(x = population, y = R_0)) +
  geom_point() +
  geom_smooth(method = "lm", se = FALSE)

two_var %>%
  ggplot(aes(x = obesity, y = R_0)) +
  geom_point() +
  geom_smooth(method = "lm", se = FALSE)

summary(mod_population)$r.squared
summary(mod_obseity)$r.squared