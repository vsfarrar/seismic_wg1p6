updiv %>%
  mutate(year_transfer = case_when(
    transfer == 1 & between(terms_since_admit,0,3)  ~ "1",
    transfer == 1 & between(terms_since_admit,4,7)  ~ "2",
    transfer == 1 & between(terms_since_admit,8,11) ~ "3",
    transfer == 1 & terms_since_admit >=12 ~ "4+",
    transfer == 0 ~ "nt",
    TRUE ~ "NA"
  )) %>%
  mutate(dept = str_sub(crs_name, 1,3)) %>%
  group_by(dept, transfer, year_transfer) %>%
  summarise(n = n(),
            mean_grade = mean(numgrade, na.rm = T),
            se_grade = std.error(numgrade, na.rm = T)) %>%
  filter(year_transfer != "4+" & !is.na(year_transfer) & year_transfer != "NA") %>%
  mutate(year_transfer = as.factor(year_transfer)) %>%
  mutate(year_transfer = relevel(year_transfer, ref = "nt")) %>%
  #PLOT
  ggplot(aes(x=year_transfer, y = mean_grade, color = dept)) + 
  geom_point(position = position_dodge(0.1)) + 
  geom_errorbar(aes(ymin = mean_grade -se_grade, ymax = mean_grade +se_grade),
                    position = position_dodge(0.1), width = 0.3) + 
  geom_line(aes(group = dept),position = position_dodge(0.1)) + 
  labs(x = "Year since transfer to UC", y = "Average grade", color = "Dept.") + 
  scale_x_discrete(labels = c("Non-Transfer", "1", "2","3")) + 
  theme_classic(base_size = 16)

#can you normalize this code to non-transfers as you did before?
# and make NPB specific?
  