# Load the libraries
library(tidyverse)
library(prophet)
library(ggplot2)
library(furrr)

# Get data
git_url <- "https://github.com/tidyverts/tsibbledata/raw/master/data/aus_retail.rda"
tf <- tempfile()
download.file(git_url, tf)
load(tf)

# Inspect the data




# Set the plan for future
# plan("sequential")
plan("multiprocess")

# Time it
t0 <- Sys.time()

# Group the data
by_state_industry <- aus_retail %>%
  select(state = State, industry = Industry, ds = Month, y = Turnover) %>%
  group_by(state, industry) %>%
  nest()

# Time it
t1 <- Sys.time()

# Create the models
by_state_industry <- by_state_industry %>%
  mutate(model = future_map(data, prophet))

# Time it
t2 <- Sys.time()

# Create the futures
by_state_industry <- by_state_industry %>%
  mutate(future = future_map(model, make_future_dataframe, periods = 12, freq = 'month'))

# Time it
t3 <- Sys.time()

# Create the forecasts
by_state_industry <- by_state_industry %>%
  mutate(forecast = future_map2(model, future, predict))

# Time it
t4 <- Sys.time()

# Create the plots
by_state_industry <- by_state_industry %>%
  mutate(plot = future_map2(model, forecast, plot))

# Time it
t5 <- Sys.time()

# Inspect a random plot
my_plot <- by_state_industry %>%
  sample_n(1) %>%
  pull(plot) %>%
  .[[1]]

my_plot + theme_minimal()

# Look at the time

times <- c(t0, t1, t2, t3, t4, t5)

time_df <- tibble(step = 1:5, 
                  desc = c("nest", "model", "future", "forecast", "plot"), 
                  time = diff(times) %>% as.numeric() %>% round()) %>%
  mutate(total = cumsum(time))

# time_df_seq <- time_df
time_df_multi <- time_df
