#GAPS OVER TIME GRAPHS 

#requires seismic setup, filtering and gaps over time to be already run
setwd("/Users/vsfarrar/Documents/GitHub/seismic_wg1p6")
source("seismic_setup.R")

#create group indicies for terms 
demog_gaps_by_term$term_no <- demog_gaps_by_term %>% group_by(crs_term) %>% group_indices()

#by gender 
demog_gaps_by_year_no_summers %>%
  mutate(dept = str_sub(crs_name, 1,3)) %>%
  filter(dept == "BIS") %>%
  filter(demographic_var == "female" & !is.na(value)) %>%
  mutate(value = as.factor(value)) %>%
  ggplot(aes(x = crs_year, y = mean_grade, group = value, color = value))+ 
  geom_point(aes(shape = value), size = 3)+
  geom_line( size = 1) +
  geom_errorbar(aes(ymin=mean_grade - sem_grade, ymax= mean_grade + sem_grade), width=.1,
                position=position_dodge(0.05)) + 
  labs(x = "Year", y = "Mean Course Grade", color = NULL, shape = NULL) +
  facet_wrap(~crs_name) + 
  scale_color_manual(values = c("black", "#B9B9B9"), labels = c("M","W"))+ 
  scale_shape_discrete(labels = c("M","W")) +
  theme_classic(base_size = 14) +
  theme(axis.text.x = element_text(size = 10,angle = 90))

#ISSUE: can you functionize these plots?
#ISSUE: if I wanted to look at trends across years, 
#would need to create a new script in the gaps over time to get averages over time by years
#for true averages and SEMS

