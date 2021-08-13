
#run a mixed model wtih all main effects only, term as a random effect, for each course 

main_fx_all <-
dat_new %>%
  nest(-crs_name) %>%
  mutate(fit = map(data, ~lmer(numgrade ~ cum_prior_gpa + female + as.factor(ethnicode_cat) + firstgen + transfer + lowincomeflag + international
                               + (1|crs_term), data = .)), 
         results = map(fit, tidy)) %>%
  unnest(results) %>%
  select(-data, -fit) %>%
  mutate(p.value = round(p.value, digits = 4)) 

#model with URM as defined previously 
main_fx_urm <-
dat_new %>% 
  mutate(urm = ifelse(ethnicode_cat %in% c(1,3), 1, 0)) %>%
  nest(-crs_name) %>%
  mutate(fit = map(data, ~lmer(numgrade ~ cum_prior_gpa + female + urm + firstgen + transfer + lowincomeflag + international
                               + (1|crs_term), data = .)), 
         results = map(fit, tidy)) %>%
  unnest(results) %>%
  select(-data, -fit) %>%
  mutate(p.value = round(p.value, digits = 4)) 

#export model outputs from each course
write.csv(main_fx_all, paste0("mixed_model_outputs_main_effects_",current_date,".csv"))
write.csv(main_fx_urm, paste0("mixed_model_outputs_main_effects_urm_",current_date,".csv"))


