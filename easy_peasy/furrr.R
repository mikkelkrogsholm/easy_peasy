# Adopted from:
# https://r4ds.had.co.nz/many-models.html

# Libraries
library(modelr)
library(tidyverse)
library(gapminder)
library(furrr)

# Set the plan for future
plan("sequential")

# Look at the data
gapminder

# Nest the data
by_country <- gapminder %>% 
  group_by(country, continent) %>% 
  nest()

# Look at the data
by_country
by_country$data[[1]]

# Custom function
country_model <- function(df) {
  lm(lifeExp ~ year, data = df)
}

# Add model to the data
by_country <- by_country %>% 
  mutate(model = future_map(data, country_model))

by_country


# Add residuals
by_country <- by_country %>% 
  mutate(resids = future_map2(data, model, add_residuals))

by_country


# Model quality
by_country <- by_country %>% 
  mutate(metrics = future_map(model, broom::glance))

by_country$metrics[[1]]

by_country %>%
  unnest(metrics) %>% 
  arrange(r.squared)
