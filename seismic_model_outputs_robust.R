
#run a mixed model wtih all main effects only, term as a random effect, for each course
#controlling for GPAO 
#race/ethnicity defined as ethnicode_cat

main_fx_all_1 <-
  dat_new %>%
  nest(-crs_name) %>%
  mutate(fit = map(data, ~rlmer(numgrade ~ gpao + female + as.factor(ethnicode_cat) + firstgen + transfer + lowincomeflag + international
                               + (1|crs_term), data = ., method = "DAStau")), 
         results = map(fit, tidy)) %>%
  unnest(results) %>%
  select(-data, -fit, - group) %>%
  mutate(s.sig = case_when(statistic > 1.96 | statistic < -1.96 ~ "***",
                           statistic <= 1.96 & statistic >= -1.96 ~ "",)) 

main_fx_all_1 = main_fx_all_1b
#nixed model with main effects, controlling for GPAO
#race/ethnicity defined as urm

main_fx_urm_1 <-
  dat_new %>%
  nest(-crs_name) %>%
  mutate(fit = map(data, ~rlmer(numgrade ~ gpao + female + urm + firstgen + transfer + lowincomeflag + international
                                + (1|crs_term), data = ., method = "DAStau")), 
         results = map(fit, tidy)) %>%
  unnest(results) %>%
  select(-data, -fit, - group) %>%
  mutate(s.sig = case_when(statistic > 1.96 | statistic < -1.96 ~ "***",
                           statistic <= 1.96 & statistic >= -1.96 ~ "",)) 


#export model outputs from each course
write.csv(main_fx_all_1, paste0("mixed_model_outputs_main_effects_robust_",current_date,".csv"))
write.csv(main_fx_urm_1, paste0("mixed_model_outputs_main_effects_urm_robust_",current_date,".csv"))

