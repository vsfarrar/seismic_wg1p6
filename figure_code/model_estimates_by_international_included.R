#setup ####
source(file = "~/Documents/GitHub/seismic_wg1p6/figure_code/seismic_figures_setup.R")

#__load data ####
betas <- read.csv("~/Google Drive/My Drive/WG1P6/Processed Data/all_model_estimates_2022-09-30.csv")

#compare betas with and without international ####
  #points are pretty aligned
betas %>%
  select(-X, -t.value) %>%
  filter(variable %in% c("EthnicityBIPOC","Female","FirstGen","LowIncome", "Transfer")) %>%
  mutate(variable = recode_factor(variable, EthnicityBIPOC = "PEER", Female = "Gender")) %>%
  pivot_wider(names_from = international_included, values_from = c(estimate,std.error,s.sig)) %>% 
  mutate(both_sig = ifelse(s.sig_0 == "***", 1, 0)) %>%
  ggplot(aes(x = estimate_0, y = estimate_1, color = university, shape = variable)) +
  geom_point(size = 3) + 
  geom_abline(intercept = 0, slope = 1, linetype = "dashed") + 
  scale_color_manual(values = deid_colors, labels = deid_labels) +
  labs(x = "Model estimate: NO International students", y = "Model Estimate: International Students",
       color = "Institution", shape = "Variable") + 
  theme_bw()