# Table 3. Percent of offerings with mismatches by institution 

library(sjPlot)
#load data ####
all_diff <- read.csv("~/Google Drive/My Drive/WG1P6/Processed Data/all_raw_grades_GPA_gaps2022-10-11.csv")

#source functions
source("~/Documents/GitHub/seismic_wg1p6/figure_code/seismic_figures_setup.R")


diff_tab2 <- 
  all_diff %>%
  filter(!is.na(grade_diff_01)) %>%
  mutate(grade_penalty1 = ifelse(mean_grade_1 < mean_gpao_1, 1, 0),
         grade_bonus1 = ifelse(mean_grade_1 > mean_gpao_1, 1,0),
         grade_penalty_mismatch = ifelse(sign(-gpao_diff_01) == 1 & sign(-grade_diff_01) == -1, 1, 0),
         grade_bonus_mismatch = ifelse(sign(-gpao_diff_01) == -1 & sign(-grade_diff_01) == 1, 1, 0)) %>%
  group_by(university, crs_topic, demographic_var) %>%
  summarise(n = n(),
            avg_grade_anomaly0 = mean(mean_grade_0 - mean_gpao_0),
            avg_grade_anomaly1 = mean(mean_grade_1 - mean_gpao_1),
            n_grade_penalty1 = sum(grade_penalty1),
            n_grade_bonus1 = sum(grade_bonus1),
            n_gpm = sum(grade_penalty_mismatch),
            n_gbm = sum(grade_bonus_mismatch),
            perc_grade_penalty = n_grade_penalty1/n*100,
            perc_grade_bonus = n_grade_bonus1/n*100,
            perc_penalty_mismatch = n_gpm/n*100,
            perc_bonus_mismatch = n_gbm/n*100
  ) 

#percent of offerings with grade penalty mismatch (dGPAO < dGrade)
diff_tab2 %>%
  select(university, crs_topic, demographic_var,perc_penalty_mismatch) %>%
  arrange(desc(crs_topic)) %>%
  pivot_wider(names_from = c("university", "crs_topic"),
              values_from = "perc_penalty_mismatch") %>%
  tab_df(digits = 0)

#percent of offerings with grade bonus mismatch (dGPAO > dGrade)
diff_tab2 %>%
  select(university, crs_topic, demographic_var,perc_bonus_mismatch) %>%
  arrange(desc(crs_topic)) %>%
  pivot_wider(names_from = c("university", "crs_topic"),
              values_from = "perc_bonus_mismatch") %>%
  tab_df(digits = 0)
