#plot showing estimates with and without controlling for GPAO 
#inspired by Harris et al (2020) Science Advances, Figure 1. 
#https://www.science.org/doi/10.1126/sciadv.aaz5687

source(file = "~/Documents/GitHub/seismic_wg1p6/figures/seismic_figures_setup.R")

#import data
all_models <- c("~/Google Drive/My Drive/WG1P6/Processed Data/all_model_estimates_2022-09-30.csv")

harris_plot <- 
all_models %>%
  filter(international_included == 1) %>%
  filter(!(variable %in% c("GPAO", "EthnicityOther", "EthnicityAsianAsianAmerican"))) %>%
  #recode and reorder demographic groups
  mutate(variable = fct_recode(variable, PEER = "EthnicityBIPOC")) %>%
  mutate(variable = factor(variable, levels = c("Female","PEER","FirstGen","LowIncome","Transfer"))) %>%
  #PLOT 
  ggplot(aes(x = as.factor(GPAO_included), y = estimate)) + 
  geom_hline(yintercept = 0) + 
  geom_point(aes(color = university, shape = crs_topic), size = 2, 
             position = position_jitter(0.05)) + 
  geom_boxplot(aes(fill = as.factor(GPAO_included)), alpha = 0.5, outlier.shape = NA) + 
  labs(x = NULL, y = "Model Estimate (beta)", 
       fill = "GPAO included in model?", color = "Institution", 
       shape = NULL) +
  scale_color_manual(values = deid_colors, labels = deid_labels) + 
  scale_fill_discrete(labels = c("no", "yes")) +
  scale_x_discrete(labels = c("raw", "with GPAO")) + 
  facet_wrap(~variable, ncol = 5) + 
  theme_seismic

#export plot ####
ggsave(harris_plot, 
       file = paste0("~/Documents/GitHub/seismic_wg1p6/figures/model_estimates_by_GPAO_",
                     current_date, ".png"),
       width = 9, height = 5, units = "in")
