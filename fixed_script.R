# Library setup
library(tidyverse)

# Code part
mtcars |>
  filter(cyl == 4) |>
  ggplot(aes(x = wt, y = mpg)) +
  geom_point()
