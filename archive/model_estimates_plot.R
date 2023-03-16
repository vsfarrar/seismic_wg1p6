#currently: international included, coded conservatively

#setup 
  #load data
betas <- read.csv("~/Google Drive/My Drive/WG1P6/Processed Data/all_model_estimates_2022-09-30.csv")
  #source functions
source("~/Documents/GitHub/seismic_wg1p6/figure_code/seismic_figures_setup.R")

#cleanup variable levels before plots
betas$variable <- fct_recode(betas$variable, PEER = "EthnicityBIPOC", LowSES = "LowIncome", Woman = "Female")
betas$variable <- fct_relevel(betas$variable, "Woman", after = 1)

#models with GPAO ####
#plot model estimates with GPAO controlled for
models_GPAO_plot <- 
betas %>% 
  filter(international_included == 1 & GPAO_included == 1) %>%
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
  mutate(significant = ifelse(is.na(s.sig), 0,1)) %>%
  filter(!(variable %in% c("GPAO","EthnicityAsianAsianAmerican", "EthnicityOther"))) %>% 
  mutate(uni_topic = paste(crs_topic, university, sep = "_"), #crs_topic 1st allows  x axis to be split by course
         sig_topic = paste(crs_topic, significant, sep = "_")) %>%
  mutate(num_uni_topic = as.integer(as.factor(uni_topic))) %>% #convert to numeric for x breks
  ggplot(aes(x = num_uni_topic, y = estimate, 
             color = as.factor(GPAO_included), shape = sig_topic)) + 
  geom_point(size = 3) + 
  geom_errorbar(aes(ymin = estimate - std.error, 
                    ymax = estimate + std.error), 
                width = 0.1) + 
  geom_hline(yintercept = 0) +
  geom_vline(xintercept = 5.5, color = "black", alpha = 0.9) + 
  # annotate(geom = "text", x = 3, y = -0.7, label = "CellBio") + #label course topics
  # annotate(geom = "text", x = 8, y = -0.7, label = "Genetics") + 
  scale_shape_manual(values = c(1,16,2,17),
                     labels = c("CellBio: n.s.", "CellBio: p < 0.05",
                                "Genetics: n.s.", "Genetics: p < 0.05")) + 
  scale_color_discrete(labels = c("no", "yes")) + 
  scale_x_continuous(minor_breaks = seq(1,10,by =1),
                     breaks = seq(1,10, by = 1),
                     labels = rep(deid_labels,2)) +
  facet_wrap(~variable, ncol = 5) + 
  labs(x = "Institution", y = "Estimate ± SE", 
       shape = NULL, color = "GPAO in model?") + 
  theme_minimal(base_size = 14) + 
  theme(axis.text = element_text(color = "black"), 
        strip.text = element_text(color = "black"), 
        panel.border = element_rect(color = "black", fill = NA, size = 1), 
        strip.background = element_rect(color = "black", size = 1),
        panel.grid.major.y = element_blank(),  #mask vertical gridlines
        panel.grid.minor.y = element_blank()) 


#delta betas overview ####
  #goal: show an overview of how betas change when GPAO is and is not added,
  #aggregated across universities and courses

delta_betas <-
betas %>% 
  filter(international_included == 1) %>%
  mutate(variable = factor(variable, levels = c("GPAO","Female","EthnicityBIPOC","EthnicityAsianAsianAmerican","EthnicityOther",
                                                "FirstGen","LowIncome","Transfer"))) %>%
  select(university, crs_topic, variable, GPAO_included, estimate, s.sig)%>%
  pivot_wider(names_from = GPAO_included,
              values_from = c(estimate, s.sig)) %>%
  mutate(diff_beta = estimate_1 - estimate_0, 
         sig_changed = ifelse(s.sig_1==s.sig_0, 0, 1))

#plot
delta_betas %>%
  filter(!(variable %in% c("GPAO","EthnicityAsianAsianAmerican", "EthnicityOther"))) %>% 
  ggplot(aes(x = variable, y = -diff_beta)) +
    geom_point(aes(color = university, shape = crs_topic, group = crs_topic), 
              size = 3) + 
    geom_boxplot(#aes(fill = crs_topic), 
                 alpha = 0.2, position = position_dodge(0.9)) + 
    geom_hline(yintercept = 0) + 
    #facet_wrap(~crs_topic) + 
  labs(x = NULL, y = "β(No GPAO in model) - β(GPAO)", 
       color = "Institution", fill = NULL, shape = NULL) + 
  scale_color_manual(labels = deid_labels, values = deid_colors) + 
  scale_fill_manual(values = c("white","black")) +
  theme_minimal(base_size = 14) + 
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  theme(axis.text = element_text(color = "black"), 
        strip.text = element_text(color = "black"), 
        panel.border = element_rect(color = "black", fill = NA, size = 1), 
        strip.background = element_rect(color = "black", size = 1), 
        panel.grid.major.x = element_blank(),  #mask horizontal gridlines
        panel.grid.minor.x = element_blank())

