updiv <- read.csv("~/Documents/projects/dber_seismic/UCD_CBS_upper_division_SEISMIC-format_2021-08-06.csv", 
                na.strings=c("","NA"))

ttest_avggrade_gender <-
  updiv %>%
  filter(!is.na(female) & female != 2) %>%
  group_by(crs_name) %>%
  do(tidy(t.test(numgrade ~ female, data = .))) %>% #uses broom
  #clean up table
  select(crs_name,p.value) %>%
  mutate(significant = ifelse(p.value <= 0.05, 1,0))


ttest_avggrade_urm <-
  updiv %>%
  mutate(urm = ifelse(ethnicode_cat %in% c(1,3), 1,0)) %>%
  group_by(crs_name) %>%
  do(tidy(t.test(numgrade ~ urm, data = .))) %>% #uses broom
  #clean up table
  select(crs_name,p.value) %>%
  mutate(significant = ifelse(p.value <= 0.05, 1,0))


ttest_avggrade_fg <-
  updiv %>%
  filter(!is.na(firstgen)) %>%
  group_by(crs_name) %>%
  do(tidy(t.test(numgrade ~ firstgen, data = .))) %>% #uses broom
  #clean up table
  select(crs_name,p.value) %>%
  mutate(significant = ifelse(p.value <= 0.05, 1,0))


ttest_avggrade_transfer <-
  updiv %>%
  filter(!is.na(transfer)) %>%
  group_by(crs_name) %>%
  do(tidy(t.test(numgrade ~ transfer, data = .))) %>% #uses broom
  #clean up table
  select(crs_name,p.value) %>%
  mutate(significant = ifelse(p.value <= 0.05, 1,0))

#URM
updiv %>%
  mutate(urm = ifelse(ethnicode_cat %in% c(1,3), 1,0)) %>%
  group_by(crs_name, urm) %>%
  summarise(avg_grade = mean(numgrade, na.rm = T), 
            avg_prior_gpa = mean(cum_prior_gpa, na.rm = T)) %>%
  pivot_wider(names_from = urm, values_from = c(avg_grade, avg_prior_gpa)) %>%
  mutate(grade_diff = avg_grade_0 - avg_grade_1,
         gpa_diff = avg_prior_gpa_0 - avg_prior_gpa_1) %>%
  mutate(dept = str_sub(crs_name, 1,3)) %>%
  left_join(., ttest_avggrade_urm, by = "crs_name") %>%
  ggplot(aes(x = gpa_diff, y= grade_diff, color = dept)) + 
  geom_point(aes(shape = as.factor(significant)))+ 
  geom_text(aes(label = crs_name),hjust = -0.1) + 
  geom_hline(yintercept = 0) + 
  geom_vline(xintercept = 0) + 
  labs(x = "Prior GPA Difference (nonURM-URM)", y = "Course Grade Difference (nonURM-URM)",
       color = "Department", shape = "Grade diff. significant?") + 
  theme_classic(base_size =14)


updiv %>%
  filter(!is.na(female)) %>%
  filter(female != 2) %>%
  group_by(crs_name, female) %>%
  summarise(avg_grade = mean(numgrade, na.rm = T), 
            avg_prior_gpa = mean(cum_prior_gpa, na.rm = T)) %>%
  pivot_wider(names_from = female, values_from = c(avg_grade, avg_prior_gpa)) %>%
  mutate(grade_diff = avg_grade_0 - avg_grade_1,
         gpa_diff = avg_prior_gpa_0 - avg_prior_gpa_1) %>%
  mutate(dept = str_sub(crs_name, 1,3)) %>%
  left_join(., ttest_avggrade_gender, by = "crs_name") %>%
  ggplot(aes(x = gpa_diff, y= grade_diff, color = dept)) + 
  geom_point(aes(shape = as.factor(significant)))+ 
  geom_text(aes(label = crs_name),hjust = -0.1) + 
  geom_hline(yintercept = 0) + 
  geom_vline(xintercept = 0) + 
  labs(x = "Prior GPA Difference (M-W)", y = "Course Grade Difference (M-W)",
       color = "Department", shape = "Grade diff. significant?") + 
  theme_classic(base_size =14)

#FIRST GEN

updiv %>%
  filter(!is.na(firstgen)) %>%
  group_by(crs_name, firstgen) %>%
  summarise(avg_grade = mean(numgrade, na.rm = T), 
            avg_prior_gpa = mean(cum_prior_gpa, na.rm = T)) %>%
  pivot_wider(names_from = firstgen, values_from = c(avg_grade, avg_prior_gpa)) %>%
  mutate(grade_diff = avg_grade_0 - avg_grade_1,
         gpa_diff = avg_prior_gpa_0 - avg_prior_gpa_1) %>%
  mutate(dept = str_sub(crs_name, 1,3)) %>%
  left_join(., ttest_avggrade_fg, by = "crs_name") %>%
  ggplot(aes(x = gpa_diff, y= grade_diff, color = dept)) + 
  geom_point(aes(shape = as.factor(significant)))+ 
  geom_text(aes(label = crs_name),hjust = -0.1) + 
  geom_hline(yintercept = 0) + 
  geom_vline(xintercept = 0) + 
  labs(x = "Prior GPA Difference (CG-FG)", y = "Course Grade Difference (CG-FG)",
       color = "Department", shape = "Grade diff. significant?") + 
  theme_classic(base_size =14)


#TRANSFER
updiv %>%
  filter(!is.na(transfer)) %>%
  group_by(crs_name, transfer) %>%
  summarise(avg_grade = mean(numgrade, na.rm = T), 
            avg_prior_gpa = mean(cum_prior_gpa, na.rm = T)) %>%
  pivot_wider(names_from = transfer, values_from = c(avg_grade, avg_prior_gpa)) %>%
  mutate(grade_diff = avg_grade_0 - avg_grade_1,
         gpa_diff = avg_prior_gpa_0 - avg_prior_gpa_1) %>%
  mutate(dept = str_sub(crs_name, 1,3)) %>%
  left_join(., ttest_avggrade_transfer, by = "crs_name") %>%
  ggplot(aes(x = gpa_diff, y= grade_diff, color = dept)) + 
  geom_point(aes(shape = as.factor(significant)))+ 
  geom_text(aes(label = crs_name),hjust = -0.1) + 
  geom_hline(yintercept = 0) + 
  geom_vline(xintercept = 0) + 
  labs(x = "Prior GPA Difference (Fresh-Transfer)", y = "Course Grade Difference (Fresh-Transfer)",
       color = "Department", shape = "Grade diff. significant?") + 
  theme_classic(base_size =14)

