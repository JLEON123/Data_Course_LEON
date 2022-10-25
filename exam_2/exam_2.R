# Load Libraries ----------------------------------------------------------
library(tidyverse)
library(broom)
library(easystats)
library(modelr)

# Read and Clean Data -----------------------------------------------------
df <- read_csv('unicef-u5mr.csv') %>% janitor::clean_names() # Wasn't using janitor for some reason

clean_df <- df %>% 
  pivot_longer(cols = starts_with('u5mr_'),
               names_to = 'Year',
               values_to = 'U5MR') %>% 
  filter(!is.na(U5MR))

clean_df$Year <- str_remove(clean_df$Year, 'u5mr_') # Returns just the year
clean_df$Year <- as.numeric(clean_df$Year) # Turns the Year values into numeric types


# Plotting the Data -------------------------------------------------------
# Plotting each country’s U5MR over time.
P1 <- clean_df %>% 
  ggplot(aes(x = Year, y = U5MR, color = country_name)) +
  geom_line(show.legend = FALSE) +
  facet_wrap(~continent) +
  theme_bw() +
  scale_colour_grey(start = 0, end = 0)
P1
#ggsave(filename = 'LEON_Plot_1.png', plot = P1, device = 'png', dpi = 300)  

# Plotting the mean U5MR of each continent over time.
P2 <- clean_df %>% 
  group_by(continent, Year) %>% 
  summarise(Mean_U5MR = mean(U5MR),
            Year = Year) %>% 
  ggplot(aes(x = Year, y = Mean_U5MR, color = continent)) +
  geom_line(size = 3) +
  theme_classic()+
  scale_colour_viridis_d(option = 'D')
P2
#ggsave(filename = 'LEON_Plot_2.png', plot = P2, device = 'png', dpi = 300) 


# Creating Models ---------------------------------------------------------
# mod1 takes the only the Year as a predictor.
mod1 <-
  glm(data = clean_df, 
      formula = U5MR ~ Year)

# mod2 takes Year and Continent as the predictors.
mod2 <-
  glm(data = clean_df, 
      formula = U5MR ~ Year + continent)

# mod3 takes Year and Continent as the predictors
# as well as their interaction.
mod3 <-
  glm(data = clean_df, 
      formula = U5MR ~ Year * continent)

# Comparing the three models, mod3 appears to be the best by far.
compare_performance(mod1, mod2, mod3, rank = TRUE)
compare_performance(mod1, mod2, mod3) %>% plot()

# Plotting the model predictions
P3 <- 
  gather_predictions(clean_df,mod1, mod2, mod3, .pred = 'Predicted U5MR') %>% 
  ggplot(aes(x = Year, y = `Predicted U5MR`, color = continent)) +
  geom_line(size = 1) +
  facet_wrap(~model) + 
  theme_minimal() +
  scale_colour_viridis_d(option = 'D')
P3
#ggsave(filename = 'LEON_Plot_3.png', plot = P2, device = 'png', dpi = 300)


# BONUS -------------------------------------------------------------------
# It gets real ugly
# Getting the stats for Ecuador
clean_df %>% 
  filter(country_name == 'Ecuador') %>% 
  summary()

# Finding the min, max, and average for each region every year
region_stats <- 
  clean_df %>% 
  group_by(as.factor(region), Year) %>% 
  summarize(Min_U5MR = min(U5MR),
            Average_U5MR = mean(U5MR),
            Max_U5MR = max(U5MR))

# Filtering to just the regions whose min, max and average
# fall within the stats for Ecuador.
# stats for Ecuador
# min = 21.60, q1 = 34.40, mean = 88.61, q3 = 138.00, max = 207.80
similar_U5MR_regions <- 
  region_stats %>% 
  filter(between(x = Min_U5MR, left = 21.60, right = 34.40),
         between(x = Average_U5MR, left = 34.40, right = 138.00),
         between(x = Max_U5MR, left = 138.00, right = 207.80))

# Regions to keep are South-Eastern Asia, Caribbean, Northern Africa, Western Africa, Central America, South America, and South Asia
similar_U5MR_regions$`as.factor(region)` %>% summary()

# New data frame to with the filtered regions and having Ecuador as the first level in the factored country_name variable
Similar_U5MR_Countries <- 
  clean_df %>% 
  filter(region %in% similar_U5MR_regions$`as.factor(region)`)

Similar_U5MR_Countries$country_name <- as.factor(Similar_U5MR_Countries$country_name)
Similar_U5MR_Countries$country_name <- relevel(Similar_U5MR_Countries$country_name, 'Ecuador')

# A model to show all predictors and their interactions
bonus_mod <- 
  glm(data = Similar_U5MR_Countries,
      formula = U5MR ~ .^2)
# Finding the meaningful values which are country, year, and the interaction between country and year
bonus_mod_df <- 
  tidy(bonus_mod) %>% 
  filter(p.value < 0.05)

# Creating a new model with just the country and year as predictors
# They are the exact same
bonus_mod2 <- 
  glm(data = Similar_U5MR_Countries,
      formula = U5MR ~ country_name * Year)
compare_performance(bonus_mod, bonus_mod2)

# Adding predictions for the year 2020
fake_data <- data.frame(country_name = 'Ecuador',
                        Year = 2020)

# Not sure how its negative?  It returns -22.8
pred = abs(predict(bonus_mod2, fake_data))

# difference is 9.83
pred_reality_diff = pred - 13
