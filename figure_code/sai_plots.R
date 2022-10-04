sai_plot <- 
  ggplot(sai,aes(x = SAI, y = mean_grade_anomaly, color = university)) + 
  geom_point(aes(size = n),
             position = position_dodge(0.2)) + 
  geom_errorbar(aes(ymin = mean_grade_anomaly-se_grade_anomaly,
                    ymax = mean_grade_anomaly+se_grade_anomaly),
                width = 0,
                position = position_dodge(0.2)) +
  geom_hline(yintercept = 0) + 
  facet_wrap(~crs_topic) +
  theme_bw(base_size = 14) + 
  scale_color_manual(values = deid_colors, labels = deid_labels) + 
  labs(y = "Mean Grade Anomaly", color = "Institution") 
