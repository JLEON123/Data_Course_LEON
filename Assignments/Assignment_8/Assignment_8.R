# Load in Libraries -------------------------------------------------------
library(tidyverse)
library(modelr)
library(broom)
library(easystats)

# Read in and organize data -----------------------------------------------
shroom_growth <- read_csv('mushroom_growth.csv')

# Changing Light, Nitrogen, and Temperature variables
  # from num types to factors types.
  # This is because they aren't continuous variables.  
  # They are discrete groups with:
    # 3 levels for Light
    # 9 levels for Nitrogen
    # 2 levels for Temperature
shroom_growth$Light <- as.factor(shroom_growth$Light)
shroom_growth$Nitrogen <- as.factor(shroom_growth$Nitrogen)
shroom_growth$Temperature <- as.factor(shroom_growth$Temperature)

# Plotting ----------------------------------------------------------------

# Creating Functions
  # plots a single predictor on the response 'GrowthRate'
shroom_func <- function(df, pred, geom){
  
  if(!is.data.frame(df))(stop('df must be a data frame'))
  
  ggplot(df, aes(x = df %>% pluck(pred),
                 y = df %>% pluck('GrowthRate'))) +
    geom +
    theme_bw() +
    labs(x = pred,
         y = 'Growth Rate')
}

  # plots two predictors on the response 'GrowthRate'
shroom_func2 <- function(df, pred, pred2, geom){
  
  if(!is.data.frame(df))(stop('df must be a data frame'))
  
  ggplot(df, aes(x = df %>% pluck(pred),
                 y = df %>% pluck('GrowthRate'),
                 fill = df %>% pluck(pred2))) +
    geom +
    theme_bw() +
    labs(x = pred,
         y = 'Growth Rate') +
    guides(fill=guide_legend(title= pred2)) +
    scale_fill_viridis_d()
}

  # plots two predictors on the response 'GrowthRate'
  # uses a third predictor to facet
shroom_func3 <- function(df, pred, pred2, pred3, geom){
  
  if(!is.data.frame(df))(stop('df must be a data frame'))
  
  ggplot(df, aes(x = df %>% pluck(pred),
                 y = df %>% pluck('GrowthRate'),
                 fill = df %>% pluck(pred2))) +
    geom +
    theme_bw() +
    labs(x = pred,
         y = 'Growth Rate') +
    guides(fill=guide_legend(title= pred2)) +
    scale_fill_viridis_d() +
    facet_wrap(~df %>% pluck(pred3)) +
    theme(strip.background = element_blank())
}

# Function calls
  # Single predictor function
shroom_func(shroom_growth, 'Species', geom_boxplot(na.rm = TRUE))
shroom_func(shroom_growth, 'Light', geom_boxplot(na.rm = TRUE))
shroom_func(shroom_growth, 'Nitrogen', geom_col(na.rm = TRUE))
shroom_func(shroom_growth, 'Humidity', geom_boxplot(na.rm = TRUE))
shroom_func(shroom_growth, 'Temperature', geom_jitter(na.rm = TRUE))

  # Two predictors function
    # Species as the X-axis
shroom_func2(shroom_growth, 'Species', 'Light', geom_boxplot(na.rm = TRUE))
shroom_func2(shroom_growth, 'Species', 'Nitrogen', geom_violin(na.rm = TRUE))
shroom_func2(shroom_growth, 'Species', 'Humidity', geom_boxplot(na.rm = TRUE))
shroom_func2(shroom_growth, 'Species', 'Temperature', geom_boxplot(na.rm = TRUE))

    # Light as the X-axis
shroom_func2(shroom_growth, 'Light', 'Species', geom_boxplot(na.rm = TRUE))
shroom_func2(shroom_growth, 'Light', 'Nitrogen', geom_violin(na.rm = TRUE))
shroom_func2(shroom_growth, 'Light', 'Humidity', geom_boxplot(na.rm = TRUE))
shroom_func2(shroom_growth, 'Light', 'Temperature', geom_boxplot(na.rm = TRUE))

  # Three predictors function
    # P.cornucopiae in high humidity and high light levels
    # appear to have the highest growth rate
shroom_func3(shroom_growth, 'Humidity', 'Species', 'Light',  geom_boxplot(na.rm = TRUE))
shroom_func3(shroom_growth, 'Light', 'Species', 'Humidity',  geom_boxplot(na.rm = TRUE))

    # Faceting by Nitrogen doesn't show any obvious differences
    # Meaning that Nitrogen may not be the best predictor
shroom_func3(shroom_growth, 'Species', 'Light', 'Nitrogen',  geom_boxplot(na.rm = TRUE))
shroom_func3(shroom_growth, 'Humidity', 'Species', 'Nitrogen',  geom_boxplot(na.rm = TRUE))
shroom_func3(shroom_growth, 'Light', 'Humidity', 'Nitrogen',  geom_boxplot(na.rm = TRUE))

    # Temperature doesn't appear to have a strong affect on the growth rate
shroom_func3(shroom_growth, 'Temperature', 'Species', 'Light',  geom_boxplot(na.rm = TRUE))
shroom_func3(shroom_growth, 'Temperature', 'Species', 'Humidity',  geom_boxplot(na.rm = TRUE))
shroom_func3(shroom_growth, 'Temperature', 'Species', 'Nitrogen',  geom_boxplot(na.rm = TRUE))


# Creating Models ---------------------------------------------------------

# Model one
  # Looking at humidity and light
mod1 <- glm(data = shroom_growth,
            formula = GrowthRate ~ Humidity + Light)

# Model two
  # Looking at humidity and light
  # as well as the interaction betwen the two
mod2 <- glm(data = shroom_growth,
            formula = GrowthRate ~ Humidity * Light)

# Model three
  # Looking at all variables and interactions
mod3 <- glm(data = shroom_growth,
            formula = GrowthRate ~ .^2)

# Model four
  # Using the stepAIC model
step <- MASS::stepAIC(mod3)
#step$formula
mod4 <- glm(data = shroom_growth,
            formula = step)

# Comparing the four models
compare_performance(mod1, mod2, mod3, mod4, rank = TRUE)
compare_performance(mod1, mod2, mod3, mod4) %>% plot()

summary(mod4)
# Visual test between model 3 and 4
gather_predictions(shroom_growth, mod3, mod4) %>% 
  ggplot(aes(x = Humidity, y = pred, fill = Light)) +
  geom_boxplot() +
  facet_wrap(~model) +
  theme_bw() +
  theme(strip.background = element_blank())

# Adding predictions to mod4, super ugly, 
# couldn't figure out how to do this with box plot
add_predictions(shroom_growth, mod4) %>% 
  ggplot(aes(x=Humidity, y =pred, fill = Light)) +
  geom_boxplot() + 
  geom_violin(aes(y=GrowthRate, fill = Light), alpha = .1)


# Adding new hypothetical values 
newdf <- data.frame(Species = c('P.ostreotus', 'P.ostreotus', 'P.cornucopiae', 'P.cornucopiae'),
                    Light = c(0, 10, 0, 10),
                    Nitrogen = c(0, 45, 0, 45),
                    Humidity = c('Low', 'High','Low', 'High'),
                    Temperature = c(20, 25, 20, 25))

newdf$Light = as.factor(newdf$Light)
newdf$Nitrogen = as.factor(newdf$Nitrogen)
newdf$Temperature = as.factor(newdf$Temperature)

pred = predict(mod4, newdata = newdf)

hyp_preds <- data.frame(Species = newdf$Species,
                        Light = newdf$Light,
                        Nitrogen = newdf$Nitrogen,
                        Humidity = newdf$Humidity,
                        Temperature = newdf$Temperature,
                        pred = pred)

shroom_growth$PredictionType <- "Real"
hyp_preds$PredictionType <- "Hypothetical"

fullpreds <- full_join(shroom_growth,hyp_preds)

ggplot(fullpreds,aes(x=Humidity, y=pred, color=PredictionType)) +
  geom_point() +
  geom_boxplot(aes(y=GrowthRate),color="Black", alpha =.5) +
  theme_minimal()
  
# Checking for non-linear relationships
shroom_non_linear <- read_csv("mushroom_growth.csv")
ggplot(data = shroom_non_linear, 
       aes(x = Nitrogen, 
           y = GrowthRate, 
           color = Species)) +
  geom_point() +
  geom_smooth(se = FALSE)

mod5 <- gam(data = shroom_non_linear,
            formula = GrowthRate ~ Nitrogen * Species)

add_predictions(shroom_non_linear, mod5) %>% 
  ggplot(aes(x = Nitrogen, y = pred, color = Species)) + 
  geom_point()
