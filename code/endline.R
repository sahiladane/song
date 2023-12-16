library(tidyverse)

setwd("~/Downloads/song")

data <- tibble(.rows = 5000)

set.seed(100)

# endline outcome
data <- read_csv("data/treat_data.csv")

# assign endline treatment outcome 
# let's assume that there is a positive trend in the control group too
# the individual shock is drawn from a normal distribution with positive mean
data$vacc_e <- 1
data$vacc_e[data$treat == 0] <- 
  round(data$vacc_b[data$treat == 0] + rnorm(1666, 0.4, 1))
data$vacc_e <- ifelse(data$vacc_e >= 5, 5, data$vacc_e)
data$vacc_e <- ifelse(data$vacc_e <= 1, 1, data$vacc_e)

# let's assume that there is a positive trend in the both treatment groups

data$vacc_e[data$treat == 1] <- 
  round(data$vacc_b[data$treat == 1] + rnorm(1667, 0.8, 0.5))
data$vacc_e <- ifelse(data$vacc_e >= 5, 5, data$vacc_e)
data$vacc_e <- ifelse(data$vacc_e <= 1, 1, data$vacc_e)

data$vacc_e[data$treat == 2] <- 
  round(data$vacc_b[data$treat == 2] + rnorm(1667, 0.5, 0.9))
data$vacc_e <- ifelse(data$vacc_e >= 5, 5, data$vacc_e)
data$vacc_e <- ifelse(data$vacc_e <= 1, 1, data$vacc_e)

# # missing status assigned based on low endline outcome
# missing_ids <- sample(data$id[data$vacc_e == 1], 500, replace = FALSE)
# data$missing <- ifelse(data$id %in% missing_ids, 1, 0)

# missing status assigned randomly
missing_ids <- sample(1:5000, 500, replace = FALSE)
data$missing <- ifelse(data$id %in% missing_ids, 1, 0)

# delete endline outcome if missing status is 1
data$vacc_e <- ifelse(data$missing == 1, NA, data$vacc_e)

write_csv(data, "data/endline_data.csv")

haven::write_dta(data, "data/total_data_short.dta")

data <- data %>%
  pivot_longer(
    cols = c("vacc_b", "vacc_e"),
    names_to = "time",
    values_to = "vacc"
  ) %>%
  mutate(time = if_else(time == "vacc_b", 0, 1)) 

haven::write_dta(data, "data/total_data_long.dta")
