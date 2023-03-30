# Robust Multilevel Mixed Models #

#rlmer(All main fx)####
#run a mixed model wtih all main effects only, each offering as a random effect, for each course
  #controlling for GPAO 
  #race/ethnicity defined via the PEER variable (PEER: ethniccode_cat == 1)

main_fx_all_rob <-
  dat_new %>%
  group_by(crs_subject) %>% nest() %>%
  mutate(fit = map(data, ~rlmerRcpp(numgrade ~ gpao + female + peer + firstgen + transfer + lowincomeflag + international +
                               + (1|crs_offering), data = ., method = "DASvar")), 
         results = map(fit, tidy)) %>%
  unnest(results) %>%
  select(-data, -fit, - group) %>%
  mutate(s.sig = case_when(statistic > 1.96 | statistic < -1.96 ~ "***",
                           statistic <= 1.96 & statistic >= -1.96 ~ "",)) 

#rlmer(no GPAO)####
#robust mixed model with all main effects WITHOUT GPAO CONTROL

main_fx_no_gpao_rob <-
  dat_new %>%
  group_by(university, crs_subject) %>% nest() %>%
  mutate(fit = map(data, ~rlmerRcpp(numgrade ~ female + peer + firstgen + transfer + lowincomeflag + international +
                                + (1|crs_offering), data = ., method = "DASvar")), 
         results = map(fit, tidy)) %>%
  unnest(results) %>%
  select(-data, -fit, - group) %>%
  mutate(s.sig = case_when(statistic > 1.96 | statistic < -1.96 ~ "***",
                           statistic <= 1.96 & statistic >= -1.96 ~ "",)) 

#rlmer: grade_anomaly as dependent var####
#robust mixed model with all main effects, but with grade anomaly as the dependent variable

grade_anom_main_fx <-
  dat_new %>%
  mutate(grade_anomaly = numgrade -gpao) %>%
  group_by(university, crs_subject) %>% nest() %>%
  mutate(fit = map(data, ~rlmerRcpp(grade_anomaly ~ female + peer + firstgen + transfer + lowincomeflag + international +
                                      + (1|crs_offering), data = ., method = "DASvar")), 
         results = map(fit, tidy)) %>%
  unnest(results) %>%
  select(-data, -fit, - group) %>%
  mutate(s.sig = case_when(statistic > 1.96 | statistic < -1.96 ~ "***",
                           statistic <= 1.96 & statistic >= -1.96 ~ "",)) 

#rlmer: interactions model, all vars*gpao ####
#robust mixed model with interactions between all variables and GPAO
#this will allow us to see if any variables significantly interact with GPAO in the dataset

interactions_gpao_rob <-
  dat_new %>%
  group_by(university, crs_subject) %>% nest() %>%
  mutate(fit = map(data, ~rlmerRcpp(numgrade ~ female*gpao + peer*gpao + firstgen*gpao + transfer*gpao + lowincomeflag*gpao + international*gpao +
                                      + (1|crs_offering), data = ., method = "DASvar")), 
         results = map(fit, tidy)) %>%
  unnest(results) %>%
  select(-data, -fit, - group) %>%
  mutate(s.sig = case_when(statistic > 1.96 | statistic < -1.96 ~ "***",
                           statistic <= 1.96 & statistic >= -1.96 ~ "",)) 

#rlmer: interactions between only gender*GPAO ####
#robust mixed model with interaction between gender and GPAO only
#allows for comparison of information criteria between main fx only and gender*GPAO

interactions_gpao_gender <-
  dat_new %>%
  group_by(university, crs_subject) %>% nest() %>%
  mutate(fit = map(data, ~rlmerRcpp(numgrade ~ female*gpao + peer + firstgen + transfer + lowincomeflag + international +
                                      + (1|crs_offering), data = ., method = "DASvar")), 
         results = map(fit, tidy)) %>%
  unnest(results) %>%
  select(-data, -fit, - group) %>%
  mutate(s.sig = case_when(statistic > 1.96 | statistic < -1.96 ~ "***",
                           statistic <= 1.96 & statistic >= -1.96 ~ "",)) 

#rlmer: prior GPA instead of GPAO ####
#robust mixed model with prior GPA instead of GPAO
#for supplemental in the MS

main_fx_prior_gpa_rob<-
  dat_new %>%
  group_by(university, crs_subject) %>% nest() %>%
  mutate(fit = map(data, ~rlmerRcpp(numgrade ~ cum_prior_gpa + female + peer + firstgen + transfer + lowincomeflag + international +
                                      + (1|crs_offering), data = ., method = "DASvar")), 
         results = map(fit, tidy)) %>%
  unnest(results) %>%
  select(-data, -fit, - group) %>%
  mutate(s.sig = case_when(statistic > 1.96 | statistic < -1.96 ~ "***",
                           statistic <= 1.96 & statistic >= -1.96 ~ "",)) 

#export models ####
#export model outputs from each course
write.csv(main_fx_all_rob, paste0(institution, "_mixed_model_outputs_main_effects_robust_",current_date,".csv"))
write.csv(main_fx_no_gpao_rob, paste0(institution, "_mixed_model_outputs_noGPAO_robust_",current_date,".csv"))
write.csv(grade_anom_main_fx, paste0(institution, "_mixed_model_grade_anomaly_main_fx_robust_",current_date,".csv"))
write.csv(interactions_gpao_rob, paste0(institution, "_mixed_model_interactions_all-vars-x-GPAO_",current_date,".csv"))
write.csv(interactions_gpao_gender, paste0(institution, "_mixed_model_interactions_gender-x-GPAO_",current_date,".csv"))
write.csv(main_fx_prior_gpa_rob, paste0(institution, "_mixed_model_outputs_main_fx_prior-gpa_",current_date,".csv"))

