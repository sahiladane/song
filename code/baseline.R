library(tidyverse)

setwd("~/Downloads/song")

data <- tibble(.rows = 5000)

set.seed(100)

# unique identifier 1-5000
data$id <- 1:5000

# age between 15-85
data$age <- sample(15:85, 5000, replace = TRUE)

# income categories 1-9
# 1 - below 15000, 8.4%
# 2 - 15000-24999, 7.4%
# 3 - 25000-34999, 7.6%
# 4 - 35000-49999, 10.6%
# 5 - 50000-74999, 16.2%
# 6 - 75000-100000, 12.3%
# 7 - 100000-149999, 16.4%
# 8 - 150000-199999, 9.2%
# 9 - above 200000, 11.9%
data$income <- sample(
  1:9,
  5000,
  replace = TRUE,
  prob = c(0.084, 0.074, 0.076, 0.106, 0.162, 0.123, 0.164, 0.092, 0.119)
)
# source:
# https://www.statista.com/statistics/203183/percentage-distribution-of-household-income-in-the-us/

# education categories
# 1 - below highschool
# 2 - highschool but no undergraduate degree
# 3 - undergraduate degree or higher
data$educ <- sample(1:3, 5000, replace = TRUE,
                    prob = c(0.1, 0.57, 0.33))
# probability source
# https://en.wikipedia.org/wiki/Educational_attainment_in_the_United_States

# gender
# 1 - male 
# 0 - female
data$gender <- sample(0:1, 5000, replace = TRUE)

# baseline outcome 
data$vacc_b <- sample(1:5, 5000, replace = TRUE)

write_csv(data, "data/baseline_data.csv")
