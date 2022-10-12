

all_gaps %>%
  #create grade anomaly for 0 and 1 groups 
  mutate(mean_gradeanom_0 = mean_grade_0 - mean_gpao_0,
         mean_gradeanom_1 = mean_grade_1 - mean_gpao_1) %>%
  select(university, crs_topic, crs_name:mean_gpao_1, mean_gradeanom_0, mean_gradeanom_1) %>%
  pivot_longer(cols = c(mean_grade_0:mean_gradeanom_1),
               names_to = c("metric", "demog_value"),
               names_pattern = "mean_(.*)_(.*)",
               values_to = "value") %>%
  filter(metric  %in% c("grade", "gradeanom")) %>%
  #Plot
  ggplot(aes(x = demographic_var, y = value, color = demog_value)) + 
  #geom_hline(yintercept = 0) + 
    geom_boxplot() + 
    facet_grid(cols = vars(crs_topic), 
             rows = vars(metric))



all_gaps %>%
  #create grade anomaly for 0 and 1 groups 
  mutate(mean_gradeanom_0 = mean_grade_0 - mean_gpao_0,
         mean_gradeanom_1 = mean_grade_1 - mean_gpao_1) %>%
  mutate(gradeanom_diff_01 = mean_gradeanom_0 - mean_gradeanom_1) %>%
  select(university, crs_topic, crs_name, grade_diff_01, demographic_var, gradeanom_diff_01) %>%
  pivot_longer(cols = c(grade_diff_01, gradeanom_diff_01),
               names_to = c("metric"),
               names_pattern = "(.*)_diff_01",
               values_to = "difference") %>%
  #Plot
  ggplot(aes(x = demographic_var, y = -difference, color = metric)) + 
  #geom_hline(yintercept = 0) + 
  geom_boxplot() + 
  geom_hline(yintercept = 0) +
  facet_wrap(~crs_topic) +
  theme_seismic