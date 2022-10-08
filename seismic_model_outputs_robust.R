# Robust Multilevel Mixed Models #

#rlmer(All main fx)####
#run a mixed model wtih all main effects only, each offering as a random effect, for each course
  #controlling for GPAO 
  #race/ethnicity defined as ethniccode_cat

main_fx_all_rob <-
  dat_new %>%
  group_by(crs_name) %>% nest() %>%
  mutate(fit = map(data, ~rlmerRcpp(numgrade ~ gpao + female + as.factor(ethniccode_cat) + firstgen + transfer + lowincomeflag +
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
  group_by(university, crs_name) %>% nest() %>%
  mutate(fit = map(data, ~rlmerRcpp(numgrade ~ female + as.factor(ethniccode_cat) + firstgen + transfer + lowincomeflag +
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
#write.csv(main_fx_urm_rob, paste0(institution, "_mixed_model_outputs_main_effects_urm_robust_",current_date,".csv"))

