# Load libraries
library(tidyverse)

# load data
nl <- read_csv('non_linear_relationship.csv')

# plot data
ggplot(data = nl, aes(x = predictor, y = response)) +
  geom_point() + geom_smooth()

# model
mod_nl <- glm(data = nl,
              formula = response ~ poly(predictor, 5)

add_predictions(nl, mod_nl) %>% 
  ggplot(aes(x = predictor, y = response)) +
  geom_point() + geom_smooth()
