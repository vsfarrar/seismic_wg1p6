#Supplemental Figure ?? 
#used for writing about confidence intervals in results section for SAI 

#source original grades by SAI figure 
#loads the sai_grades dataset
source("figure_code/figII_sai_raw_grades.R")

#plot
ggplot(sai_grades, aes(x = university, y = avg_grade, color = as.factor(SAI))) + 
  geom_point() + 
  geom_errorbar(aes(ymin = lowCI, ymax = hiCI)) +
  facet_grid(~crs_topic) + 
  scale_color_brewer(palette = "Set1") + 
  scale_x_discrete(labels = c("A","B","C","D","E")) + 
  labs(x = "Institution", y = "Mean grade", color = "SAI") + 
  theme_classic()
