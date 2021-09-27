#GOAL: Recreate Harris et al.(2020) Figure 1 DOI: 10.1126/sciadv.aaz5687 #

# Setup ####
library(lme4)
library(lmerTest)

#source NPB101D joins from advantages data
source("ucdavis/ucdavis_npb101_advantages_analysis.R")

#filter npb101 only 
npb101_19 <- dat19 %>% filter(crs_name == "NPB101")

# Predict Values based on Linear Model ####
lm_gpa <- lm(numgrade ~ cum_prior_gpa, data = npb101_19)

npb101_19 <- npb101_19 %>% add_predictions(lm_gpa, var = "predicted_gpa")

# PLOT ####

test <-
npb101_19 %>%
  group_by(crs_term, female, urm, firstgen, lowincomeflag) %>%
  summarise(avg_grade_raw = mean(numgrade, na.rm = T),
            se_grade_raw = std.error(numgrade, na.rm = T), 
            avg_grade_pred = mean(predicted_gpa, na.rm = T), 
            se_grade_pred = std.error(predicted_gpa, na.rm = T)) 

test %>%
  pivot_longer(cols = avg_grade_raw: se_grade_pred, 
               names_to = c("statistic","model_source"), names_pattern = "(.*)_grade_(.*)", 
               values_to = "value") %>%
  ggplot(aes(x = model_source, y =  ))
            
