# load library
library(tidyverse)

# load data 
fake_data <- read.csv("./Assignments/Assignment_4/fake_data.csv")
# Make a plot
p1 <- fake_data %>%
  ggplot(aes(x = Required.degree, y = Salary)) +
  geom_boxplot(aes(fill = Required.degree)) +
  geom_jitter(color = "black")


p2 <- p1 +
  theme_classic() +
  scale_fill_grey() +
  labs(
    title = "Degrees and their Salaries",
    x = "Degree") +
  theme(
    axis.title = element_text(face = "bold", size = 18),
    plot.title = element_text(face = "bold", size = 24),
    axis.text = element_text(colour = "black", size = 14)
  )

p2

ggsave("./Assignments/Assignment_4/fake_plot.png", plot = p2, width = 6, dpi = 300)  
