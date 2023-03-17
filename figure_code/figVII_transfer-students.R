#Figure 6. Transfer Students ##

#load data ####
all_diff <- read.csv("~/Google Drive/My Drive/WG1P6/Processed Data/all_raw_grades_GPA_gaps2022-10-11.csv")
betas <- read.csv("~/Google Drive/My Drive/WG1P6/Processed Data/all_model_estimates_2022-09-30.csv")

#source functions
source("~/Documents/GitHub/seismic_wg1p6/figure_code/seismic_figures_setup.R")

#A-B.diffGPAO by diffGrades ####

transfdiff <- 
all_diff %>%
  filter(demographic_var == "transfer") %>%
  ggplot(aes(x = -gpao_diff_01, y= -grade_diff_01, fill = university)) + 
  #annotate "bonuses and mismatches" 
  geom_rect(aes(xmin = 0, xmax = Inf, ymin = -Inf, ymax = 0), fill = "#D5D5D5", alpha = 0.1) +
  geom_rect(aes(xmin = -Inf, xmax = 0, ymin = 0, ymax = Inf), fill = "#D5D5D5", alpha = 0.1) +
  geom_point(size = 3, alpha = 0.6, color = "black", pch = 21) +
  geom_hline(yintercept = 0) + 
  geom_vline(xintercept = 0) + 
  geom_abline(slope = 1, intercept = 0, linetype = "dashed") + #1-1 line
  labs(x = NULL, y =  NULL, color = "Institution") + 
  scale_fill_manual (values = deid_colors, labels = deid_labels) + #de-identify institutions
  facet_wrap(~crs_topic) +
  theme_seismic + 
  theme(legend.position = "none")

#__percentages labels####
all_diff %>%
  filter(demographic_var == "transfer" & !is.na(grade_diff_01)) %>%
  mutate(grade_penalty_mismatch = ifelse(sign(-gpao_diff_01) == 1 & sign(-grade_diff_01) == -1, 1, 0),
         grade_bonus_mismatch = ifelse(sign(-gpao_diff_01) == -1 & sign(-grade_diff_01) == 1, 1, 0)) %>%
  group_by(crs_topic, demographic_var) %>%
  summarise(n = n(),
            n_gpm = sum(grade_penalty_mismatch),
            n_gbm = sum(grade_bonus_mismatch),
            perc_penalty_mismatch = n_gpm/n*100,
            perc_bonus_mismatch = n_gbm/n*100
  ) 

#__split facets####
fvii <- splitFacet(transfdiff)

#C.model estimates ####
figViiC <- 
betas %>% 
  filter(international_included == 1 & variable == "Transfer") %>%
  mutate(crs_topic = factor(crs_topic, levels = c("Genetics", "CellBio"))) %>%
  mutate(significant = ifelse(is.na(s.sig), 0,1)) %>%
  mutate(uni_topic = paste(crs_topic, university, sep = "_"), #crs_topic 1st allows  x axis to be split by course
         sig_topic = paste(crs_topic, significant, sep = "_")) %>%
  #create an x-axis placeholder 1-10 , by course within each variable and model
  group_by(variable, GPAO_included) %>%
  arrange(crs_topic) %>%
  mutate(x_placeholder = row_number()) %>%
  ggplot(aes(x = x_placeholder, y = estimate, 
             color = as.factor(GPAO_included), shape = sig_topic)) + 
  geom_point(size = 3) + 
  geom_errorbar(aes(ymin = estimate - std.error, 
                    ymax = estimate + std.error), 
                width = 0.1) + 
  geom_hline(yintercept = 0) +
  geom_vline(xintercept = 5.5, color = "black", alpha = 0.9) + 
  scale_shape_manual(values = c("CellBio_0" = 1,"CellBio_1" = 16,
                                "Genetics_0" = 2,"Genetics_1" = 17),
                     #proper order in legend
                     limits = c("Genetics_0", "Genetics_1", "CellBio_0", "CellBio_1"),
                     labels = c("CellBio_0" = "CellBio: n.s.","CellBio_1" = "CellBio: p<0.05",
                                "Genetics_0" = "Genetics: n.s.","Genetics_1" = "Genetics: p<0.05")) + 
  scale_color_discrete(labels = c("no", "yes")) + 
  scale_x_continuous(minor_breaks = seq(1,10,by =1),
                     breaks = seq(1,10, by = 1),
                     labels = rep(deid_labels,2)) +
  #annotate courses
  annotate(geom = "text", x = 3, y = -0.7, label = "Genetics") + 
  annotate(geom = "text", x = 8, y = -0.7, label = "CellBio") + 
  labs(x = NULL, y = NULL, shape = NULL, color = "GPAO in model?") + 
  theme_minimal(base_size = 14) + 
  theme(axis.text = element_text(color = "black"), 
        strip.text = element_text(color = "black"), 
        panel.border = element_rect(color = "black", fill = NA, size = 1), 
        strip.background = element_rect(color = "black", size = 1),
        panel.grid.major.y = element_blank(),  #mask vertical gridlines
        panel.grid.minor.y = element_blank(), 
        legend.position =  "right")

#cowplot ####
figVII <- cowplot::plot_grid(fvii[[2]] + labs(subtitle = "Genetics", y = "Course Grade Difference",
                                            x = "GPAO Difference") + sharedx + sharedy + 
                             annotate(geom = "text", x=Inf, y = -Inf, label = "7.30%",
                                      vjust = -2, hjust = 1.5),
                           fvii[[1]] + labs(subtitle = "CellBio", y = NULL, x = "GPAO Difference") + sharedx + sharedy + 
                             annotate(geom = "text", x=Inf, y = -Inf, label = "2.30%",
                                      vjust = -2, hjust = 1.5),
                           figViiC + labs(y = "Estimate ± SE", x = "Institution"),
                           labels = "AUTO", nrow = 1, ncol = 3, align = "h", axis = "bt", 
                           rel_widths = c(1.2,1,2))
#get legend for bottom 
figVIIlegend <- cowplot::get_legend(fvii[[2]] + labs(fill = "Institution") + theme(legend.position = "bottom"))

#export plot ####
ggsave(filename = paste0("figVII_transfer_students_", current_date, ".png"), path = "figures/",
       figVII, height = 490/96, width = 1110/96, units = "in", dpi = 300, bg= "white")

