# Gaps Over Time Table 

# Demographic Gaps by each term of a course ####

demog_gaps_by_term <- 
dat_new %>%
  pivot_longer(cols = c(female,urm,firstgen, lowincomeflag, transfer),
               names_to = "demographic_var",
               values_to = "value") %>%
  group_by(university, crs_name, crs_term, demographic_var, value) %>%
  summarise(n = n(),
            mean_grade = mean(numgrade),
            sem_grade = std.error(numgrade), 
            lower_ci = lower_ci(mean_grade,sem_grade,n, conf_level = 0.95), 
            upper_ci = upper_ci(mean_grade,sem_grade,n, conf_level = 0.95),
            mean_prior_gpa = mean(cum_prior_gpa),
            se_prior_gpa = std.error(cum_prior_gpa))

# Demographic gaps by year of a course ####
#ISSUE: calculation of crs_year and summer terms are UC Davis entry specific. 

# demog_gaps_by_year <- 
#   dat_new %>%
#   pivot_longer(cols = c(female,urm,firstgen, lowincomeflag, transfer),
#                names_to = "demographic_var",
#                values_to = "value") %>%
#   mutate(crs_year = str_sub(crs_term, 1,4)) %>%
#   group_by(crs_name, crs_year, demographic_var, value) %>%
#   summarise(n = n(),
#             mean_grade = mean(numgrade),
#             sem_grade = std.error(numgrade), 
#             lower_ci = lower_ci(mean_grade,sem_grade,n, conf_level = 0.95), 
#             upper_ci = upper_ci(mean_grade,sem_grade,n, conf_level = 0.95),
#             mean_prior_gpa = mean(cum_prior_gpa),
#             se_prior_gpa = std.error(cum_prior_gpa))

#export to a table 
write.csv(demog_gaps_by_term, paste0(institution, "_demographic_gaps_by_term_",current_date,".csv"))
#write.csv(demog_gaps_by_year, paste0("demographic_gaps_by_year_",current_date,".csv"))

#### MEAN DIFFERENCES BY TERM ####

#calculate differences in course grades, GPA across demographics for each term of a course 

grade_gpa_diff <-
dat_new %>%
  pivot_longer(cols = c(female,urm,firstgen, lowincomeflag, transfer),
               names_to = "demographic_var",
               values_to = "value") %>%
  group_by(university, crs_name, crs_term, demographic_var, value) %>%
  summarise(mean_grade = mean(numgrade, na.rm = T),
            mean_prior_gpa = mean(cum_prior_gpa, na.rm = T),
            mean_gpao = mean(gpao, na.rm = T)) %>%
  pivot_wider(names_from = value, values_from = c(mean_grade,mean_prior_gpa, mean_gpao))  %>%
  mutate(grade_diff_01 = mean_grade_0 - mean_grade_1, 
         gpa_diff_01 = mean_prior_gpa_0 - mean_prior_gpa_1,
         gpao_diff_01 = mean_gpao_0 - mean_gpao_1)

#export to a table 
write.csv(grade_gpa_diff, paste0(institution,"_mean_grade_gpa_differences_by_term_",current_date,".csv"))


#### ETHNICCODE_CAT: MEAN DIFFERENCES BY TERM ####

#calculate differences in course grades, GPA across ethniccode_cat levels 

grade_gpa_diff_ethniccode <-
  dat_new %>%
  pivot_longer(cols = ethniccode_cat,
               names_to = "demographic_var",
               values_to = "value") %>%
  group_by(university, crs_name, crs_term, demographic_var, value) %>%
  summarise(mean_grade = mean(numgrade, na.rm = T),
            mean_prior_gpa = mean(cum_prior_gpa, na.rm = T),
            mean_gpao = mean(gpao, na.rm = T)) %>%
  pivot_wider(names_from = value, values_from = c(mean_grade,mean_prior_gpa, mean_gpao))  %>%
  mutate(grade_diff_01 = mean_grade_0 - mean_grade_1, 
         grade_diff_02 = mean_grade_0 - mean_grade_2, 
         grade_diff_03 = mean_grade_0 - mean_grade_3,
         grade_diff_12 = mean_grade_1 - mean_grade_2,
         grade_diff_23 = mean_grade_2 - mean_grade_3,
         gpa_diff_01 = mean_prior_gpa_0 - mean_prior_gpa_1,
         gpa_diff_02 = mean_prior_gpa_0 - mean_prior_gpa_2,
         gpa_diff_03 = mean_prior_gpa_0 - mean_prior_gpa_3,
         gpa_diff_12 = mean_prior_gpa_1 - mean_prior_gpa_2,
         gpa_diff_23 = mean_prior_gpa_2 - mean_prior_gpa_3,
         gpao_diff_01 = mean_gpao_0 - mean_gpao_1,
         gpao_diff_02 = mean_gpao_0 - mean_gpao_2,
         gpao_diff_03 = mean_gpao_0 - mean_gpao_3,
         gpao_diff_12 = mean_gpao_1 - mean_gpao_2,
         gpao_diff_23 = mean_gpao_2 - mean_gpao_3)

#export .csv
write.csv(grade_gpa_diff_ethniccode, paste0(institution,"_mean_grade_gpa_differences_by_ethniccode_term_",current_date,".csv"))
