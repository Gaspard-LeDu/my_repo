# fixed_pipeline.R
# Corrected version of broken_pipeline.R

library(tidyverse)

# Load data
data(swiss)
df <- swiss

# Isolate provinces with Catholic percentage > 50 and flag them
high_catholic <- df |>
  filter(Catholic > 50) |>
  mutate(is_majority = TRUE)

# Calculate summary stats
summary_stats <- high_catholic |>
  summarize(
    avg_fertility = mean(Fertility),
    avg_education = mean(Education, na.rm = TRUE),
    max_ag = max(Agriculture)
  )

# Plot the results
plot <- ggplot(summary_stats, aes(x = avg_fertility, y = avg_education)) +
  geom_point(color = "red") +
  theme_minimal() +
  labs(title = "Fertility vs Education in Majority Catholic Swiss Provinces")

# Create output directory if needed, then save the plot
dir.create("output", showWarnings = FALSE)
ggsave("output/my_plot.png", plot)
