# broken_pipeline.R

library(tidyverse)
library(ggplot) 

# Load data
data(swiss)
df <- swis 

# Isolate provinces with Catholic percentage > 50 and flag them
high_catholic <- df |>
  filter(Catholic > 50) |>
  mutate(is_majority = True) 

# Calculate summary stats
summary_stats <- high_catholic |>
  summarize(
    avg_fertility = mean(Fertility),
    avg_education = mean(Education, na.rm = T,
    max_ag = max(Agriculture) 
  )

# Plot the results
plot <- ggplot(summary_stats, aes(x = avg_fertility, y = avg_education)) |> 
  geom_point(color = "red") +
  theme_minimal()
  labs(title = "Fertility vs Education in Majority Catholic Swiss Provinces") 

ggsave("outputs/my_plot.png", plot) 