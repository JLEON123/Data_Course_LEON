# Load libraries
library(tidyverse)

# load Data
df <- read_csv("./Utah_Religions_by_County.csv")

# Tidy Data
tidy_df <- 
  df %>% 
  pivot_longer(cols = 5:17,
               names_to = "Religion",
               values_to = "Percent")
  

### Question 1 ###
### Does population of a county correlate with the proportion of any specific religious group in that county? ###


## The proportions of the following religious groups are positively correlated with an increase in population size
# 'Assemblies of God', 
# 'Buddhism-Mahayana'
# 'Catholic'
# 'Muslim'
# 'Greek Orthodox'
# 'Orthodox'
# 'Pentecostal Church of God'

## The proportions of the following religious groups are negatively correlated with an increase in population size
# 'Episcopal Church'
# 'Southern Baptists Convention

## The proportions of the following religious groups have little to no correlation with population size
# 'LDS' 
# 'United Methodist Church' 
# 'Evangelical'
# 'Non Denominational'
tidy_df %>%
  ggplot(aes(x = Pop_2010, y = Percent)) +
  geom_point() + 
  geom_smooth(method = "lm", se = FALSE, color = "red") +
  theme_classic() +
  labs(y = "Proportion of population",
       x = "2010 Population") +
  facet_wrap(~Religion, scales = "free")

### Question 2 ###
### Does proportion of any specific religion in a given county correlate with the proportion of non-religious people? ###

# The proportion of non-religious people is negatively correlated with the proportion of LDS members
tidy_df %>% 
  filter(Religion == 'LDS') %>% 
  ggplot(aes(x = Percent, y = `Non-Religious`, color = County)) +
  geom_point() +
  geom_smooth(color = "black", se = FALSE)+
  theme_classic() +
  labs(x = "Proportion of population that are LDS",
       y = "Proportion of population that are non-relgious") +
  scale_color_viridis_d()
 
# Showing the correlation between the proportion of non-religious for all religions
# Filtered the data to show only the proportions that are not 0 because it made the graphs look weird
# Also filtered out LDS data because it has it's own graph

## The proportion of non-religious people is positively correlated with the proportions for the following religious groups
# 'Episcopal Church'
# 'Evangelical'
# 'Southern Baptist Church'
# 'United Methodist Church'

## The proportion of non-religious people is negatively correlated with the proportions for the following religious groups
# 'Buddhism-Mahayana'
# 'Orthodox'
# 'Greek Orthodox'

## There is little to no correlation between non-religious and the remaining religious groups
tidy_df %>% 
  filter(Percent != 0,
         Religion != 'LDS') %>% 
  ggplot(aes(x = Percent, y = `Non-Religious`)) +
  geom_line() +
  geom_smooth(method = "loess", se = FALSE, color = "red") +
  theme_classic() +
  labs(x = "Proportion of population that are apart of the specified religion",
       y = "Proportion of population that are non-relgious") +
  facet_wrap(~Religion, scales = "free")


# IDK if this shows anything useful
tidy_df %>% 
  mutate(Relgion_to_Non_Religion = Percent/`Non-Religious`) %>% 
  ggplot(aes(x = County, y = Relgion_to_Non_Religion, color = Religion)) +
  geom_point() +
  theme_classic() +
  theme(axis.text.x = element_text(angle = 90)) +
  scale_color_viridis_d(option = "A")
  
