library(tidyverse)

setwd("~/Downloads/song")

set.seed(100)

data <- read_csv("data/baseline_data.csv")

# 1667 receive treatment 1
# 1667 receive treatment 2
# 1666 receive control

# the default treatment status is 0
data$treat <- 0

data %>% count(educ)

# let's stratify by education to increase likelihood of balance across treatment and control

# number of people of educational category 1 in the same treatment group
num_treat1 <- round(0.1*1667)
num_treat2 <- round(0.57*1667)
num_treat3 <- 1667 - num_treat1 - num_treat2

# ids of people of educational category 1 receiving one of the treatments
treat_ids1 <- sample(data$id[data$educ == 1], 2*num_treat1, replace = FALSE)

# ids of people of educational category 1 receiving treatment 1
treat_ids11 <- sample(treat_ids1, num_treat1, replace = FALSE)

data$treat <- ifelse(data$id %in% treat_ids1, 
                     ifelse(data$id %in% treat_ids11, 1, 2), 
                     data$treat)
  
# ids of people of educational category 2 receiving one of the treatments
treat_ids2 <- sample(data$id[data$educ == 2], 2*num_treat2, replace = FALSE)

# ids of people of educational category 2 receiving treatment 1
treat_ids21 <- sample(treat_ids2, num_treat2, replace = FALSE)

data$treat <- ifelse(data$id %in% treat_ids2, 
                     ifelse(data$id %in% treat_ids21, 1, 2), 
                     data$treat)

# ids of people of educational category 3 receiving one of the treatments
treat_ids3 <- sample(data$id[data$educ == 3], 2*num_treat3, replace = FALSE)

# ids of people of educational category 3 receiving treatment 1
treat_ids31 <- sample(treat_ids3, num_treat3, replace = FALSE)

data$treat <- ifelse(data$id %in% treat_ids3, 
                     ifelse(data$id %in% treat_ids31, 1, 2), 
                     data$treat)

write_csv(data, "data/treat_data.csv")