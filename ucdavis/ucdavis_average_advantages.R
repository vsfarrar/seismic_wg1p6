#UC Davis Average Advantages 

advantages_dept %>%
  filter(!is.na(disadv_no)) %>%
  ggplot(aes(x = disadv_no, y = mean_grade, color = dept)) + 
  geom_point(position = position_dodge(0.2)) + 
  geom_errorbar(aes(ymin = mean_grade - se_grade, ymax = mean_grade + se_grade), width = 0.7,
                position = position_dodge(0.2)) + 
  geom_line(aes(group = dept), position = position_dodge(0.2)) + 
  scale_x_discrete(labels = c("4", "3", "2", "1", "0")) + 
  labs(x = "No. of 'Advantages'", y = "Average Course Grade", color = "Dept.") + 
  theme_classic(base_size = 16)

#create the same graph but normalize to 0?

advantages_dept %>%
  #Normalize Grads
  filter(!is.na(disadv_no)) %>%
  group_by(dept) %>% 
  mutate(norm_mean_grade = mean_grade - mean_grade[disadv_no==0],
         norm_grade_penalty = mean_diff_grade_gpa - mean_diff_grade_gpa[disadv_no==0],
         se_grade_penalty = se_diff_grade_gpa) %>%
  #Plot
  ggplot(aes(x = disadv_no, y = norm_grade_penalty, color = dept)) + 
  geom_point(position = position_dodge(0.2)) + 
  geom_errorbar(aes(ymin = norm_grade_penalty - se_grade_penalty, 
                    ymax = norm_grade_penalty + se_grade_penalty), width = 0.7,
                position = position_dodge(0.2)) + 
  geom_line(aes(group = dept), position = position_dodge(0.2)) + 
  scale_x_discrete(labels = c("4", "3", "2", "1", "0")) + 
  labs(x = "No. of 'Advantages'", y = "Average Grade Penalty \n(relative to most advantaged group)", color = "Dept.") + 
  theme_classic(base_size = 16)

# NPB specific, normalized plot for all NPB courses ####

advantages_by_course %>%
  mutate(dept = str_sub(crs_name, 1,3)) %>%
  filter(dept == "NPB" & crs_name != "NPB101D") %>%
  #Normalize Grads
  filter(!is.na(disadv_no)) %>%
  select(crs_name,disadv_no,mean_grade, se_grade) %>%
  pivot_wider(names_from = "disadv_no", values_from = c("mean_grade", "se_grade")) %>%
  mutate(mean_1 = mean_grade_1 - mean_grade_0,
         mean_2 = mean_grade_2 - mean_grade_0,
         mean_3 = mean_grade_3 - mean_grade_0,
         mean_4 = mean_grade_4 - mean_grade_0,
         mean_0 = 0,
         se_0 = se_grade_0, 
         se_1 = se_grade_1, 
         se_2 = se_grade_2,
         se_3 = se_grade_3, 
         se_4 = se_grade_4) %>%
  pivot_longer(cols = mean_1:mean_0, names_to = "disadv_no", names_pattern = "mean_(.)",
               values_to = "norm_mean_grade") %>% 
  select(disadv_no:norm_mean_grade) %>%
  inner_join(., advantages_by_course) %>%
  #Plot
  ggplot(aes(x = disadv_no, y = norm_mean_grade, color = crs_name)) + 
  geom_point(position = position_dodge(0.2)) + 
  geom_errorbar(aes(ymin = norm_mean_grade - se_grade, ymax = norm_mean_grade + se_grade), width = 0.7,
                position = position_dodge(0.2)) + 
  geom_line(aes(group = crs_name), position = position_dodge(0.2)) + 
  scale_x_discrete(labels = c("4", "3", "2", "1", "0")) + 
  labs(x = "No. of 'Advantages'", y = "Average Course Grade \n(relative to most advantaged group)", color = "Course") + 
  theme_classic(base_size = 16)

# References Used ####
#https://stackoverflow.com/questions/59073695/mutate-column-in-r-subtract-values-from-column-based-on-another-column-conditio

