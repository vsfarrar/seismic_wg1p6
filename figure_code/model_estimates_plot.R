#currently: international included, coded conservatively

#models with GPAO ####
#plot model estimates with GPAO controlled for
models_GPAO_plot <- 
betas %>% 
  filter(international_included == 1 & GPAO_included == 1) %>%
  mutate(variable = factor(variable, levels = c("GPAO","Female","EthnicityBIPOC","EthnicityAsianAsianAmerican","EthnicityOther",
                                                "FirstGen","LowIncome","Transfer"))) %>%
  filter(!(variable %in% c("GPAO","EthnicityAsianAsianAmerican", "EthnicityOther"))) %>% 
  mutate(significant = ifelse(is.na(s.sig), "not significant", "significant")) %>%
  ggplot(aes(x = crs_topic, y = estimate, color = university)) + 
  geom_point(aes(group = university, shape = significant), size = 3,
             position = position_dodge(0.5)) + 
  geom_errorbar(aes(group = university, ymin = estimate - std.error, ymax = estimate + std.error),
                width = 0.5,position = position_dodge(0.5)) + 
  geom_vline(xintercept = 1.5, alpha = 0.5) + 
  geom_hline(yintercept = 0) +
  scale_shape_manual(values = c(1,16)) + 
  scale_color_manual(values = deid_colors, labels = deid_labels) + 
  labs(x = NULL, y = "Model estimate ± SE", color = "Institution", shape = NULL, 
       #title = "Upper-Division Biology equity gaps across institutions", 
       #subtitle = "Robust mixed model estimates, controlling for GPAO"
  ) + 
  facet_wrap(~variable, ncol = 5) + 
  theme_bw(base_size = 14) +
  theme_seismic + 
  theme(  #mask horizontal gridlines
    panel.grid.major.x = element_blank(),
    panel.grid.minor.x = element_blank()
  )
