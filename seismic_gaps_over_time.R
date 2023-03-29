# Gaps Over Time Table 

# Demographic Gaps by each term and offering of a course ####
  #produces warnings due to missing data for confidence interval function (ok)

demog_gaps_offering <- 
dat_new %>%
  group_by(crs_name) %>% mutate(n_course = n()) %>% ungroup() %>% #course total
  group_by(crs_name,crs_term) %>% mutate(n_term = n()) %>% ungroup() %>% #term total
  group_by(crs_name, crs_offering) %>% mutate(n_offering = n()) %>% #offering total
  pivot_longer(cols = c(female,peer,firstgen, lowincomeflag, transfer, international),
               names_to = "demographic_var",
               values_to = "value") %>%
  group_by(university, crs_name, crs_term, crs_offering, demographic_var, value) %>%
  summarise(n_group = n(), #total for that demographic group, by offering.
            n_offering = mean(n_offering),
            n_course = mean(n_course),
            grade = list(gmodels::ci(numgrade)), #gmodels creates a list with estimate(mean),ci, and SEM
            gpao = list(gmodels::ci(gpao))) %>%
  #unnest all statistics: estimate = mean, upper ci, lower ci, and SEM 
  unnest_wider(grade, names_sep = "_") %>%
  unnest_wider(gpao, names_sep = "_") %>%
  rename_all(~tolower(str_replace_all(.,"\\s+", ""))) #remove whitespace in colnames and make lowercase


#export to a table 
write.csv(demog_gaps_offering, paste0(institution, "_demographic_gaps_by_offering_",current_date,".csv"))

#### MEAN DIFFERENCES BY TERM ####

#calculate differences in course grades, GPA across demographics for each offering of a course 

grade_gpa_diff <-
dat_new %>%
  pivot_longer(cols = c(female, peer, firstgen, lowincomeflag, transfer, international),
               names_to = "demographic_var",
               values_to = "value") %>%
  group_by(university, crs_name, crs_term, crs_offering, demographic_var, value) %>%
  summarise(mean_grade = mean(numgrade, na.rm = T),
            mean_prior_gpa = mean(cum_prior_gpa, na.rm = T),
            mean_gpao = mean(gpao, na.rm = T)) %>%
  pivot_wider(names_from = value, values_from = c(mean_grade,mean_prior_gpa, mean_gpao))  %>%
  mutate(grade_diff_01 = mean_grade_0 - mean_grade_1, 
         gpa_diff_01 = mean_prior_gpa_0 - mean_prior_gpa_1,
         gpao_diff_01 = mean_gpao_0 - mean_gpao_1)

#export to a table 
write.csv(grade_gpa_diff, paste0(institution,"_mean_grade_gpa_differences_by_offering_",current_date,".csv"))


#### ETHNICCODE_CAT: MEAN DIFFERENCES BY TERM ####

#calculate differences in course grades, GPA across ethniccode_cat levels 

grade_gpa_diff_ethniccode <-
  dat_new %>%
  pivot_longer(cols = ethniccode_cat,
               names_to = "demographic_var",
               values_to = "value") %>%
  group_by(university, crs_name, crs_term, crs_offering, demographic_var, value) %>%
  summarise(mean_grade = mean(numgrade, na.rm = T),
            mean_prior_gpa = mean(cum_prior_gpa, na.rm = T),
            mean_gpao = mean(gpao, na.rm = T)) %>%
  pivot_wider(names_from = value, values_from = c(mean_grade,mean_prior_gpa, mean_gpao))  %>%
  mutate(grade_diff_01 = mean_grade_0 - mean_grade_1, 
         grade_diff_02 = mean_grade_0 - mean_grade_2, 
         grade_diff_03 = mean_grade_0 - mean_grade_3,
         grade_diff_12 = mean_grade_1 - mean_grade_2,
         grade_diff_13 = mean_grade_1 - mean_grade_3,
         grade_diff_14 = mean_grade_1 - mean_grade_2,
         grade_diff_23 = mean_grade_2 - mean_grade_3,
         gpa_diff_01 = mean_prior_gpa_0 - mean_prior_gpa_1,
         gpa_diff_02 = mean_prior_gpa_0 - mean_prior_gpa_2,
         gpa_diff_03 = mean_prior_gpa_0 - mean_prior_gpa_3,
         gpa_diff_12 = mean_prior_gpa_1 - mean_prior_gpa_2,
         gpa_diff_13 = mean_prior_gpa_1 - mean_prior_gpa_3,
         gpa_diff_23 = mean_prior_gpa_2 - mean_prior_gpa_3,
         gpao_diff_01 = mean_gpao_0 - mean_gpao_1,
         gpao_diff_02 = mean_gpao_0 - mean_gpao_2,
         gpao_diff_03 = mean_gpao_0 - mean_gpao_3,
         gpao_diff_12 = mean_gpao_1 - mean_gpao_2,
         gpao_diff_13 = mean_gpao_1 - mean_gpao_3,
         gpao_diff_23 = mean_gpao_2 - mean_gpao_3,
)

#export .csv
write.csv(grade_gpa_diff_ethniccode, paste0(institution,"_mean_grade_gpa_diff_offering_ethniccode_",current_date,".csv"))

# STUDENT CLASS STANDING: Descriptive Stats ####
#calculate ns, average grades and gpao for class standing

class_standing_stats <-
  dat_new %>%
  group_by(university, crs_name, crs_offering, class_standing) %>%
  summarise(n = n(), 
            mean_grade = mean(numgrade, na.rm = T),
            mean_prior_gpa = mean(cum_prior_gpa, na.rm = T),
            mean_gpao = mean(gpao, na.rm = T))

# COURSE ORDER (for students that took both courses in dataset) ####
#class standing gives us a sense of when students take each course
#but students may take both courses when they are juniors, for example
#if students in our data took both courses, look at when they took each. 

course_order_summary <-
dat_new %>%
  #concatenate crs_year and crs_semq to do sequence / order analysis 
  #(this format is the same as crs_term in UCD notation)
  mutate(crs_term2 = paste0(crs_year, crs_semq)) %>%
  select(st_id, crs_subject, crs_term2) %>% 
  drop_na(crs_subject) %>%
  pivot_wider(names_from = "crs_subject",
              names_prefix = "term_",
              values_from = "crs_term2") %>% 
  count(!is.na(term_Genetics) & !is.na(term_CellBio), 
        term_Genetics == term_CellBio,
        term_Genetics < term_CellBio,
        term_Genetics > term_CellBio) 

#export .csv
write.csv(course_order_summary, paste0(institution,"_course_order_summary_",current_date,".csv"))

