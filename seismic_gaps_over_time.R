# Gaps Over Time Table 

demog_gaps_by_term <- 
dat_new %>%
  pivot_longer(cols = c(female,ethnicode_cat,firstgen, lowincomeflag, transfer),
               names_to = "demographic_var",
               values_to = "value") %>%
  group_by(crs_name, crs_term, demographic_var, value) %>%
  summarise(n = n(),
            mean_grade = mean(numgrade),
            sem_grade = std.error(numgrade), 
            lower_ci = lower_ci(mean_grade,sem_grade,n, conf_level = 0.95), 
            upper_ci = upper_ci(mean_grade,sem_grade,n, conf_level = 0.95),
            mean_prior_gpa = mean(cum_prior_gpa),
            se_prior_gpa = std.error(cum_prior_gpa))


demog_gaps_by_year <- 
  dat_new %>%
  pivot_longer(cols = c(female,ethnicode_cat,firstgen, lowincomeflag, transfer),
               names_to = "demographic_var",
               values_to = "value") %>%
  mutate(crs_year = str_sub(crs_term, 1,4)) %>%
  group_by(crs_name, crs_year, demographic_var, value) %>%
  summarise(n = n(),
            mean_grade = mean(numgrade),
            sem_grade = std.error(numgrade), 
            lower_ci = lower_ci(mean_grade,sem_grade,n, conf_level = 0.95), 
            upper_ci = upper_ci(mean_grade,sem_grade,n, conf_level = 0.95),
            mean_prior_gpa = mean(cum_prior_gpa),
            se_prior_gpa = std.error(cum_prior_gpa))


demog_gaps_by_year_no_summers <- 
  dat_new %>%
  pivot_longer(cols = c(female,ethnicode_cat,firstgen, lowincomeflag, transfer),
               names_to = "demographic_var",
               values_to = "value") %>%
  mutate(crs_year = str_sub(crs_term, 1,4)) %>%
  mutate(summer_term = ifelse(str_sub(crs_term,5,6) %in% c("05", "06", "07"), 1,0)) %>% 
  filter(summer_term == 0) %>%
  group_by(crs_name, crs_year, demographic_var, value) %>%
  summarise(n = n(),
            mean_grade = mean(numgrade),
            sem_grade = std.error(numgrade), 
            lower_ci = lower_ci(mean_grade,sem_grade,n, conf_level = 0.95), 
            upper_ci = upper_ci(mean_grade,sem_grade,n, conf_level = 0.95),
            mean_prior_gpa = mean(cum_prior_gpa),
            se_prior_gpa = std.error(cum_prior_gpa))

#export to a table 
write.csv(demog_gaps_by_term, paste0("demographic_gaps_by_term_",current_date,".csv"))
write.csv(demog_gaps_by_year, paste0("demographic_gaps_by_year_",current_date,".csv"))

#### MEAN DIFFERENCES BY TERM ####

grade_gpa_diff <-
dat_new %>%
  pivot_longer(cols = c(female,ethnicode_cat,firstgen, lowincomeflag, transfer),
               names_to = "demographic_var",
               values_to = "value") %>%
  group_by(crs_name, crs_term, demographic_var, value) %>%
  summarise(mean_grade = mean(numgrade),
            mean_prior_gpa = mean(cum_prior_gpa)) %>%
  pivot_wider(names_from = value, values_from = c(mean_grade,mean_prior_gpa))  %>%
  mutate(grade_diff_01 = mean_grade_0 - mean_grade_1, 
         gpa_diff_01 = mean_prior_gpa_0 - mean_prior_gpa_1)

#export to a table 
write.csv(grade_gpa_diff, paste0("mean_grade_gpa_differences_by_term",current_date,".csv"))

#ISSUE: This code does not work for the ethnicity group, as Asian is currently separated out
#ISSUE: calculation of crs_year and summer terms are UC Davis entry specific. 