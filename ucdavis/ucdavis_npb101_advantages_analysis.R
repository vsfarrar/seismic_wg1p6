# Setup ####
library(tidyverse)
library(plotrix)

#import SEISMIC formatted data
dat <- read.csv("~/Documents/projects/dber_seismic/UCD_CBS_upper_division_SEISMIC-format_NPB_full_2021-09-13.csv", 
                  na.strings=c("","NA"))
#Filter data
dat19 <- 
  dat %>%
  filter(summer_crs == 0) %>% #exclude summers
  filter(crs_term <= 201910) %>% #exclude COVID19 terms
  #convert missing demographics to 0 (conservative)
  tidyr::replace_na(list(ethnicode_cat = 0, firstgen = 0, international = 0,
                         transfer = 0, lowincomeflag = 0))

# Create Dataframe with NPB101D only, get if students passed or did not ####
npb101d <- dat19 %>%
  filter(crs_name == "NPB101D" & !is.na(crs_term)) %>% #should be 3435 students
  mutate(enrolled_npb101d = 1, #all students were enrolled
         passed_npb101d = ifelse(lettergrade == "P", 1,0)) %>% #students that passed; n = 2470
  select(st_id, crs_term, enrolled_npb101d, passed_npb101d)

# How many students passed discussion? 
npb101d %>% count(is_dfw, lettergrade)
  #general issue: lettergrade "NP" should count as dfw.

# Join NPB101D data with original dataframe (dat19) ####
dat19 <- left_join(dat19, npb101d) #default joins by st_id AND crs_term

# Calculate "Advantages" ####
advantages_npb101d <- 
  dat19 %>%
  filter(crs_name == "NPB101" & crs_term >= 201610) %>%
  mutate(advantage = case_when(
    female == "0" & urm == "0" & firstgen == "0" & lowincomeflag == "0"  ~ "0",
    female == "1" & urm == "0" & firstgen == "0" & lowincomeflag == "0"  ~ "1A",
    female == "0" & urm == "1" & firstgen == "0" & lowincomeflag == "0"  ~ "1B", 
    female == "0" & urm == "0" & firstgen == "0" & lowincomeflag == "1"  ~ "1C", 
    female == "0" & urm == "0" & firstgen == "1" & lowincomeflag == "0"  ~ "1D", 
    female == "0" & urm == "1" & firstgen == "1" & lowincomeflag == "0"  ~ "2A", 
    female == "0" & urm == "1" & firstgen == "0" & lowincomeflag == "1"  ~ "2B", 
    female == "1" & urm == "1" & firstgen == "0" & lowincomeflag == "0"  ~ "2C", 
    female == "0" & urm == "0" & firstgen == "1" & lowincomeflag == "1"  ~ "2D", 
    female == "1" & urm == "0" & firstgen == "1" & lowincomeflag == "0"  ~ "2E", 
    female == "1" & urm == "0" & firstgen == "0" & lowincomeflag == "1"  ~ "2F", 
    female == "1" & urm == "0" & firstgen == "1" & lowincomeflag == "1"  ~ "3A", 
    female == "1" & urm == "1" & firstgen == "1" & lowincomeflag == "0"  ~ "3B",
    female == "1" & urm == "1" & firstgen == "0" & lowincomeflag == "1"  ~ "3C", 
    female == "0" & urm == "1" & firstgen == "1" & lowincomeflag == "1"  ~ "3D",
    female == "1" & urm == "1" & firstgen == "1" & lowincomeflag == "1"  ~ "4",
    TRUE ~ "NA")) %>%
  mutate(grade_gpa_diff = numgrade - cum_prior_gpa, #grade-gpa difference
         disadv_no = str_extract(advantage, "[[:digit:]]+")) %>% 
  group_by(enrolled_npb101d, advantage, disadv_no) %>%
  summarise(n = n(), 
            mean_grade = mean(numgrade, na.rm = T), 
            se_grade = std.error(numgrade, na.rm = T),
            mean_gpa = mean(cum_prior_gpa, na.rm = T),
            se_gpa = std.error(cum_prior_gpa, na.rm = T),
            mean_diff_grade_gpa = mean(grade_gpa_diff, na.rm = T), 
            se_diff_grade_gpa = std.error(grade_gpa_diff, na.rm = T)) %>%
  mutate(enrolled_npb101d = replace_na(enrolled_npb101d,0 )) %>%
  mutate(group_label = recode(advantage, 
                              "0" ="non-URM,non-LI,non-FG man",
                              "1A" = "+W",
                              "3D" = "+URM+FG+LI",
                              "4" = "+URM+FG+LI+W",
                              "1B" = "+URM",
                              "2C" ="+URM+W",
                              "1D" ="+FG", 
                              "2E" = "+FG+W",
                              "1C" = "+LI",
                              "2F" = "+LI+W",
                              "2A"="+URM+FG",
                              "3B"="+URM+FG+W",
                              "2B"="+URM+LI",
                              "3C"= "+URM+LI+W",
                              "2D" = "+FG+LI",
                              "3A" = "+FG+LI+W"))

# PLOT ####

#averages, normalized to the "all advantages" group
advantages_npb101d %>%
ungroup() %>%
filter(!is.na(disadv_no)) %>%
  mutate(mean_grade_norm = ifelse(enrolled_npb101d == 0, mean_grade-2.849176,mean_grade-3.051852),
         group_label = fct_reorder(as.factor(group_label), advantage, min)) %>% 
  #Plot
  ggplot(aes(x = group_label, y = mean_grade_norm, color = as.factor(enrolled_npb101d))) + 
  geom_point(position = position_dodge(0.2)) + 
  geom_errorbar(aes(ymin = mean_grade_norm - se_grade, ymax = mean_grade_norm + se_grade), width = 0.7,
                position = position_dodge(0.2)) + 
  geom_vline(xintercept = c(2.5, 5.5,11.5,15.5)) + 
  labs(x = "No. of 'Advantages'", y = "Average Course Grade \n(relative to most advantaged group)", color = "Enrolled in NPB101D?") + 
  theme_classic(base_size = 16) + 
  coord_flip()

# grade-gpa difference
advantages_npb101d %>%
  ungroup() %>%
  filter(!is.na(disadv_no)) %>%
  mutate(group_label = fct_reorder(as.factor(group_label), advantage, min)) %>% 
  #Plot
  ggplot(aes(x = group_label, y = mean_diff_grade_gpa, color = as.factor(enrolled_npb101d))) + 
  geom_point(position = position_dodge(0.2)) + 
  geom_errorbar(aes(ymin = mean_diff_grade_gpa - se_diff_grade_gpa, ymax = mean_diff_grade_gpa + se_diff_grade_gpa), width = 0.7,
                position = position_dodge(0.2)) + 
  geom_vline(xintercept = c(2.5, 5.5,11.5,15.5)) + 
  labs(x =  NULL, y = "Course Grade - Cum.Prior GPA \n(mean +/- SEM)", 
       color = "Enrolled in NPB101D?", subtitle = "Fall 2016 - Fall 2019") + 
  theme_classic(base_size = 16) + 
  coord_flip()
