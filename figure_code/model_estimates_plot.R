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

#cleveland dot plot #### 
  #all info in one plot
  #H/T to Nick for the idea!

all_models_plot <- 
betas %>% 
filter(international_included == 1) %>%
  mutate(variable = factor(variable, levels = c("GPAO","Female","EthnicityBIPOC","EthnicityAsianAsianAmerican","EthnicityOther",
                                                "FirstGen","LowIncome","Transfer")),
         significant = ifelse(is.na(s.sig), 0,1)) %>%
  filter(!(variable %in% c("GPAO","EthnicityAsianAsianAmerican", "EthnicityOther"))) %>% 
  mutate(uni_topic = paste(university, crs_topic, sep = "_"), 
         sig_topic = paste(crs_topic, significant, sep = "_")) %>%
  mutate(num_uni_topic = as.integer(as.factor(uni_topic))) %>% #convert to numeric for x breks
  ggplot(aes(x = num_uni_topic, y = estimate, 
             color = as.factor(GPAO_included), shape = sig_topic)) + 
  geom_point(size = 3) + 
  geom_errorbar(aes(ymin = estimate - std.error, 
                    ymax = estimate + std.error), 
                width = 0.1) + 
  geom_hline(yintercept = 0) +
  geom_vline(xintercept = c(2.5, 4.5, 6.5, 8.5), color = "black", alpha = 0.2) + 
  scale_shape_manual(values = c(1,16,2,17),
                     labels = c("CellBio: n.s.", "CellBio: p < 0.05",
                                "Genetics: n.s.", "Genetics: p < 0.05")) + 
  scale_color_discrete(labels = c("no", "yes")) + 
  scale_x_continuous(breaks = c(1.5, 3.5, 5.5, 7.5, 9.5), 
                     labels = deid_labels) +
  facet_wrap(~variable, ncol = 5) + 
  labs(x = "Institution", y = "Estimate ± SE", 
       shape = NULL, color = "GPAO in model?") + 
  theme_classic(base_size = 14) + 
  theme(axis.text = element_text(color = "black"), 
        strip.text = element_text(color = "black"), 
        panel.border = element_rect(color = "black", fill = NA, size = 1), 
        strip.background = element_rect(color = "black", size = 1), 
        panel.grid.major.x = element_blank(),  #mask horizontal gridlines
        panel.grid.minor.x = element_blank())
 