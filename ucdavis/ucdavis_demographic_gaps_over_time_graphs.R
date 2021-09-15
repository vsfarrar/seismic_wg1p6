#GAPS OVER TIME GRAPHS 

#requires seismic setup, filtering and gaps over time to be already run
setwd("/Users/vsfarrar/Documents/GitHub/seismic_wg1p6")
source("seismic_setup.R")

#create group indicies for terms 
demog_gaps_by_term$term_no <- demog_gaps_by_term %>% group_by(crs_term) %>% group_indices()

#by gender 
demog_gaps_by_year %>%
  mutate(dept = str_sub(crs_name, 1,3)) %>%
  filter(dept == "NPB") %>%
  filter(demographic_var == "female" & !is.na(value) & value !=2) %>%
  mutate(value = as.factor(value)) %>%
  ggplot(aes(x = crs_year, y = mean_grade, group = value, color = value))+ 
  geom_point(aes(shape = value), size = 3)+
  geom_line( size = 1) +
  geom_errorbar(aes(ymin=mean_grade - sem_grade, ymax= mean_grade + sem_grade), width=.1,
                position=position_dodge(0.05)) + 
  labs(x = "Year", y = "Mean Course Grade", color = NULL, shape = NULL) +
  facet_wrap(~crs_name) + 
  scale_color_manual(values = c("black", "#B9B9B9"), labels = c("M", "W"))+ 
  scale_shape_discrete(labels = c("M","W")) +
  theme_classic(base_size = 14) +
  theme(axis.text.x = element_text(size = 10,angle = 90))

#by ethnicity
demog_gaps_by_year %>%
  mutate(dept = str_sub(crs_name, 1,3)) %>%
  filter(dept == "NPB") %>%
  filter(demographic_var == "ethnicode_cat" & !is.na(value) & value !=3) %>%
  mutate(value = as.factor(value)) %>%
  ggplot(aes(x = crs_year, y = mean_grade, group = value, color = value))+ 
  geom_point(aes(shape = value), size = 3)+
  geom_line( size = 1) +
  geom_errorbar(aes(ymin=mean_grade - sem_grade, ymax= mean_grade + sem_grade), width=.1,
                position=position_dodge(0.05)) + 
  labs(x = "Year", y = "Mean Course Grade", color = NULL, shape = NULL) +
  facet_wrap(~crs_name) + 
  scale_color_manual(values = c("black", "#B9B9B9", "#004C99"), labels = c("White", "URM", "Asian"))+ 
  scale_shape_discrete(labels = c("White","URM", "Asian")) +
  theme_classic(base_size = 14) +
  theme(axis.text.x = element_text(size = 10,angle = 90))

#ISSUE: can you functionize these plots?


