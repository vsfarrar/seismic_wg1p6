
#run a mixed model wtih all main effects only, term as a random effect, for each course
  #controlling for GPAO 
  #race/ethnicity defined as ethnicode_cat

main_fx_all <-
dat_new %>%
  nest(-crs_name) %>%
  mutate(fit = purrr::map(data, ~lmer(numgrade ~ gpao + female + as.factor(ethniccode_cat) + firstgen + transfer + lowincomflag + international
                               + (1|crs_term), data = .)), 
         results = purrr::map(fit, tidy)) %>%
  unnest(results) %>%
  select(-data, -fit) %>%
  mutate(p.value = round(p.value, digits = 4)) 

#nixed model with main effects, controlling for GPAO
  #race/ethnicity defined as urm

main_fx_urm <-
dat_new %>% 
  nest(-crs_name) %>%
  mutate(fit = purrr::map(data, ~lmer(numgrade ~ gpao + female + urm + firstgen + transfer + lowincomflag + international
                               + (1|crs_term), data = .)), 
         results = purrr::map(fit, tidy)) %>%
  unnest(results) %>%
  select(-data, -fit) %>%
  mutate(p.value = round(p.value, digits = 4)) 

#export model outputs from each course
write.csv(main_fx_all, paste0("Results/mixed_model_outputs_main_effects_",current_date,".csv"))
write.csv(main_fx_urm, paste0("Results/mixed_model_outputs_main_effects_urm_",current_date,".csv"))


