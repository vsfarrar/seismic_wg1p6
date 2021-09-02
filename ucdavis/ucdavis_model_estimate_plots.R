#sources seismic_model_outputs.R 

main_fx_all %>%
  mutate(dept = str_sub(crs_name, 1,3),
         signif = ifelse(p.value <= 0.05,1,0)) %>%
  filter(term %in% c("as.factor(ethnicode_cat)1","as.factor(ethnicode_cat)2",
                     "female","firstgen", "international",
                     "lowincomeflag")) %>%
  mutate(term = recode_factor(term, 
                       "as.factor(ethnicode_cat)1" = "URM (ref: White)",
                       "as.factor(ethnicode_cat)2" = "Asian (ref: White)",
                     "female" = "Female",
                     "firstgen" = "First Generation", 
                     "international" = "International",
                     "lowincomeflag" = "Low Income",
                     .ordered = TRUE)) %>% 
  ggplot(aes(x = crs_name, y = estimate, color = dept)) +
  geom_point(aes(shape = as.factor(signif)), size = 2)+ 
  #geom_text(aes(label = crs_name), hjust = 0) + 
  geom_errorbar(aes(ymin = estimate - std.error, 
                    ymax = estimate + std.error)) + 
  geom_hline(yintercept = 0) + 
  facet_wrap(~term) + 
  scale_shape_manual(values=c(4,16)) + 
  labs(x = NULL, y = "Model Estimate (β ± SE)",
       shape = "p < 0.05?", color = "Department",
       title = "Model Estimates for Demographic Main Effects, controlling for Cum.Prior GPA") + 
  theme_classic() + 
  theme(axis.text.x =element_text(angle = 90, hjust = 1))

#######
#Model 2: using URM defined as NSF, also shows transfers

main_fx_urm %>%
  mutate(dept = str_sub(crs_name, 1,3),
         signif = ifelse(p.value <= 0.05,1,0)) %>%
  filter(term %in% c("urm","transfer",
                     "female","firstgen", "international",
                     "lowincomeflag")) %>%
  mutate(term = recode_factor(term, 
                              "urm" = "URM (ref: White/Asian)",
                              "transfer" = "Transfer",
                              "female" = "Female",
                              "firstgen" = "First Generation", 
                              "international" = "International",
                              "lowincomeflag" = "Low Income",
                              .ordered = TRUE)) %>% 
  ggplot(aes(x = crs_name, y = estimate, color = dept)) +
  geom_point(aes(shape = as.factor(signif)), size = 2)+ 
  #geom_text(aes(label = crs_name), hjust = 0) + 
  geom_errorbar(aes(ymin = estimate - std.error, 
                    ymax = estimate + std.error)) + 
  geom_hline(yintercept = 0) + 
  facet_wrap(~term) + 
  scale_shape_manual(values=c(4,16)) + 
  labs(x = NULL, y = "Model Estimate (β ± SE)",
       shape = "p < 0.05?", color = "Department",
       title = "Model Estimates for Demographic Main Effects, controlling for Cum.Prior GPA (Model 2)") + 
  theme_classic() + 
  theme(axis.text.x =element_text(angle = 90, hjust = 1))

