# Load libraries
library(tidyverse)

# Load in data
covid <- read.csv("./exam_1/cleaned_covid_data.csv")

# Sub-setting the data to just get the states that begin with "A"
A_states <- subset(covid, grepl("^A", Province_State))

# Creating a plot of 'A_states' that shows deaths over time for each state
A_state_plot <- 
  A_states %>% 
  ggplot(aes(x = as.Date(Last_Update), y = Deaths)) +
  geom_point() +
  geom_smooth(method = "loess", se = FALSE, color = "red") +
  facet_wrap(~Province_State, scales = "free") +
  theme_bw() +
  labs(x = "Date", title = "Covid Deaths Over Time") +
  theme(strip.text = element_text(face = "bold.italic", size = 14),
        plot.title = element_text(hjust = 0.5, size = 24, face = "bold"),
        axis.title = element_text(size = 12),
        axis.text = element_text(size = 12))

A_state_plot # Print the plot

# Finding the “peak” of Case_Fatality_Ratio for each state and saving it as a new data frame
state_max_fatality_rate <- covid %>% 
  mutate(Province_State = factor(Province_State)) %>% 
  group_by(Province_State) %>% 
  summarize(Maximum_Fatality_Ratio = max(Case_Fatality_Ratio, na.rm = TRUE)) %>% 
  arrange(Maximum_Fatality_Ratio)

# Creating a plot for 'state_max_fatality_rate'
Fatality_plot <- 
  state_max_fatality_rate %>%
  mutate(Province_State = fct_reorder(Province_State, desc(Maximum_Fatality_Ratio))) %>%
  ggplot(aes(x = Province_State,
             y = Maximum_Fatality_Ratio,
             fill = Maximum_Fatality_Ratio)) +
  geom_col() +
  scale_y_continuous(limits = c(0,7), expand = c(0, 0)) + # Gets rid of space underneath 0 on the y axis
  scale_fill_gradient(low = "#cacccb", high = "#000000") +
  labs(y = "Maximum Fatality Ratio",
       title = "Maximum Covid Fatality Ratio by State") +
  theme_classic() +
  theme(legend.position = "none",
        axis.title.x = element_blank(),
        plot.title = element_text(size = 20, hjust = .5),
        axis.text.x = element_text(angle = 90, face = "bold"),
        panel.grid.major.y = element_line(color = "black", size = .1),
        panel.ontop = TRUE,
        panel.background = element_blank())
  
Fatality_plot # Print the plot

# bonus: plot cumulative deaths for the entire US over time
bonus_plot <- 
  covid %>% 
  mutate(Date = as.Date(Last_Update)) %>% 
  group_by(Date) %>% 
  summarize(Cumulative_Deaths = sum(Deaths)) %>% 
  ggplot(aes(x = Date, y = Cumulative_Deaths)) +
  geom_line() + 
  theme_bw() +
  labs(y = "Total Deaths",
       title = "Deaths from COVID-19 in the USA")


bonus_plot # Print the plot
