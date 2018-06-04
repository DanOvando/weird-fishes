things <- cross_df(list(cores = 2:7, model = model_frame$model))

testfoo <- function(cores, model) {
  startime <- Sys.time()

  future::plan(future::multiprocess, workers = cores)

  test_data <- test_data %>%
    mutate(par_fits = future_map2(model, splits, ~ lm(.x, data = rsample::analysis(.y)), .progress = F))

  # doParallel::registerDoParallel(cores = cores)
  #
  # fits <-  foreach::foreach(i = 1:nrow(test_data)) %dopar% {
  #
  #   lm(test_data$model[[i]], data = analysis(test_data$splits[[i]]))
  #
  # }

  outtime <- Sys.time() - startime

  return(as.numeric(outtime))
}

things <- things %>%
  mutate(run_time = map2_dbl(cores, model, testfoo))

things %>%
  ggplot(aes(cores, run_time)) +
  geom_smooth()