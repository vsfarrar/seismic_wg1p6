
#run a mixed model wtih all main effects only, term as a random effect, for each course
#controlling for GPAO 
#race/ethnicity defined as ethnicode_cat

main_fx_all_1 <-
  dat_new %>%
  group_by(crs_name) %>% nest() %>%
  mutate(fit = map(data, ~rlmer(numgrade ~ gpao + female + as.factor(ethnicode_cat) + firstgen + transfer + lowincomeflag + international
                               + (1|crs_term), data = ., method = "DAStau")), 
         results = map(fit, tidy)) %>%
  unnest(results) %>%
  select(-data, -fit, - group) %>%
  mutate(s.sig = case_when(statistic > 1.96 | statistic < -1.96 ~ "***",
                           statistic <= 1.96 & statistic >= -1.96 ~ "",)) 

main_fx_all_1 = main_fx_all_1b
#mixed model with main effects, controlling for GPAO
#race/ethnicity defined as urm

main_fx_urm_1 <-
  dat_new %>%
  group_by(crs_name) %>% nest() %>%
  mutate(fit = map(data, ~rlmer(numgrade ~ gpao + female + urm + firstgen + transfer + lowincomeflag + international
                                + (1|crs_term), data = ., method = "DAStau")), 
         results = map(fit, tidy)) %>%
  unnest(results) %>%
  select(-data, -fit, - group) %>%
  mutate(s.sig = case_when(statistic > 1.96 | statistic < -1.96 ~ "***",
                           statistic <= 1.96 & statistic >= -1.96 ~ "",)) 


#robust mixed model with all main effects WITHOUT GPAO CONTROL

main_fx_no_gpao <-
  dat_new %>%
  group_by(crs_name) %>% nest() %>%
  mutate(fit = map(data, ~rlmer(numgrade ~ female + urm + firstgen + transfer + lowincomeflag + international
                                + (1|crs_term), data = ., method = "DAStau")), 
         results = map(fit, tidy)) %>%
  unnest(results) %>%
  select(-data, -fit, - group) %>%
  mutate(s.sig = case_when(statistic > 1.96 | statistic < -1.96 ~ "***",
                           statistic <= 1.96 & statistic >= -1.96 ~ "",)) 



#export model outputs from each course
write.csv(main_fx_all_1, paste0(institution, "_mixed_model_outputs_main_effects_robust_",current_date,".csv"))
write.csv(main_fx_urm_1, paste0(institution, "_mixed_model_outputs_main_effects_urm_robust_",current_date,".csv"))
write.csv(main_fx_no_gpao, paste0(institution, "_mixed_model_outputs_noGPAO_robust_",current_date,".csv"))

