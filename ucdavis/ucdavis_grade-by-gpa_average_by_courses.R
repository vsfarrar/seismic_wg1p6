updiv <- read.csv("~/Documents/projects/dber_seismic/UCD_CBS_upper_division_SEISMIC-format_2021-08-06.csv", 
                na.strings=c("","NA"))

#filter data first 
updiv <- dat %>%
  add_count(crs_name, crs_term, name = "n_term") %>%
  mutate(summer_term = ifelse(str_sub(crs_term, 5,6) %in% c("05","06","07"),1,0)) %>%
  filter(n_term >= 50 & summer_term == 0 ) %>%
  filter(crs_term < 202001) %>% #remove COVID (2020+) terms %>%
  filter(crs_name != "NPB101D") #remove NPB101D since no numgrades given 

#T-tests by demographic variables ####

ttest_avggrade_gender <-
  updiv %>%
  filter(!is.na(female) & female != 2 & crs_name != "NPB101D") %>%
  group_by(crs_name) %>%
  summarise(ttest = list(t.test(numgrade ~ female))) %>%
  mutate(ttest = map(ttest, broom::tidy)) %>%
  unnest(cols = c(ttest)) %>%
  #clean up table
  #select(crs_name,t.value = statistic, p.value) %>%
  mutate(significant = ifelse(p.value <= 0.05, 1,0))

ttest_avggrade_urm <-
  updiv %>%
  mutate(urm = ifelse(ethnicode_cat %in% c(1,3), 1,0)) %>%
  filter(!is.na(urm) & crs_name != "NPB101D") %>%
  group_by(crs_name) %>%
  summarise(ttest = list(t.test(numgrade ~ urm))) %>%
  mutate(ttest = map(ttest, broom::tidy)) %>%
  unnest() %>%
  #clean up table
  select(crs_name,t.value = statistic, p.value) %>%
  mutate(significant = ifelse(p.value <= 0.05, 1,0))


ttest_avggrade_fg <-
  updiv %>%
  filter(!is.na(firstgen) & crs_name != "NPB101D") %>%
  group_by(crs_name) %>%
  summarise(ttest = list(t.test(numgrade ~ firstgen))) %>%
  mutate(ttest = map(ttest, broom::tidy)) %>%
  unnest() %>%
  #clean up table
  select(crs_name,t.value = statistic, p.value) %>%
  mutate(significant = ifelse(p.value <= 0.05, 1,0))


ttest_avggrade_transfer <-
  updiv %>%
  filter(!is.na(transfer) & crs_name != "NPB101D") %>%
  group_by(crs_name) %>%
  summarise(ttest = list(t.test(numgrade ~ transfer))) %>%
  mutate(ttest = map(ttest, broom::tidy)) %>%
  unnest(cols = c(ttest)) %>%
  #clean up table
  select(crs_name,t.value = statistic, p.value) %>%
  mutate(significant = ifelse(p.value <= 0.05, 1,0))

# Average Plots ####

#URM gaps 
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

#SANDBOX: crosshair SEM averages ####

#works for NPB specifically
updiv %>%
  filter(!is.na(female) & female != 2) %>%
  group_by(crs_name, crs_term, female) %>%
  summarise(avg_grade = mean(numgrade, na.rm = T), 
            avg_prior_gpa = mean(cum_prior_gpa, na.rm = T)) %>%
  pivot_wider(names_from = female, values_from = c(avg_grade, avg_prior_gpa)) %>%
  mutate(grade_diff = avg_grade_0 - avg_grade_1,
         gpa_diff = avg_prior_gpa_0 - avg_prior_gpa_1) %>%
  group_by(crs_name) %>%
  summarise(avg_grade_diff = mean(grade_diff, na.rm = T), 
            avg_gpa_diff = mean(gpa_diff, na.rm = T), 
            se_grade_diff = std.error(grade_diff),
            se_gpa_diff = std.error(gpa_diff)) %>%
  mutate(dept = str_sub(crs_name, 1,3)) %>%
  filter(dept == "NPB") %>%
  ggplot(aes(x = avg_gpa_diff, y= avg_grade_diff, color = crs_name)) + 
  geom_point() + 
  geom_text(aes(label = crs_name),hjust = -0.1) + 
  geom_errorbar(aes(ymin = avg_grade_diff-se_grade_diff, ymax =avg_grade_diff+ se_grade_diff)) +
  geom_errorbarh(aes(xmin = avg_gpa_diff-se_gpa_diff, xmax =avg_gpa_diff+ se_gpa_diff)) + 
  geom_hline(yintercept = 0) + 
  geom_vline(xintercept = 0) + 
  labs(x = "Prior GPA Difference (M-W)", y = "Course Grade Difference (M-W)",
       color = "Course") + 
  theme_classic(base_size =14)
