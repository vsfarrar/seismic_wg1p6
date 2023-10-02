#MS Figure #. diffGPAO vs diffGrade Plots #

#setup ####
#load data ####
all_diff <- read.csv("~/Google Drive/My Drive/WG1P6/Processed Data/all_raw_grades_GPA_gaps_2023-10-02.csv")

#source functions
source("~/Documents/GitHub/seismic_wg1p6/figure_code/seismic_figures_setup.R")

#plots ####

diff_cellbio <- 
all_diff %>%
  filter(demographic_var != "transfer" & crs_subject == "CellBio") %>%
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
  facet_wrap(~demographic_var) +
  theme_seismic + 
  theme(legend.position = "none") 

diff_genetics <- 
  all_diff %>%
  filter(demographic_var != "transfer" & crs_subject == "Genetics") %>%
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
  facet_wrap(~demographic_var) +
  theme_seismic + 
  theme(legend.position = "none") 

#calculate percentages for "mismatches" ####
  #note: grade penalties and bonuses are not in the plots, but in this table 
diff_tab <- 
  all_diff %>%
  filter(demographic_var != "transfer" & !is.na(grade_diff_01)) %>%
  mutate(grade_penalty1 = ifelse(mean_grade_1 < mean_gpao_1, 1, 0),
         grade_bonus1 = ifelse(mean_grade_1 > mean_gpao_1, 1,0),
         grade_penalty_mismatch = ifelse(sign(-gpao_diff_01) == 1 & sign(-grade_diff_01) == -1, 1, 0),
         grade_bonus_mismatch = ifelse(sign(-gpao_diff_01) == -1 & sign(-grade_diff_01) == 1, 1, 0)) %>%
  group_by(crs_subject, demographic_var) %>%
  summarise(n = n(),
            avg_grade_anomaly0 = mean(mean_grade_0 - mean_gpao_0),
            avg_grade_anomaly1 = mean(mean_grade_1 - mean_gpao_1),
            n_grade_penalty1 = sum(grade_penalty1),
            n_grade_bonus1 = sum(grade_bonus1),
            n_gpm = sum(grade_penalty_mismatch),
            n_gbm = sum(grade_bonus_mismatch),
            perc_grade_penalty = n_grade_penalty1/n*100,
            perc_grade_bonus = n_grade_bonus1/n*100,
            perc_penalty_mismatch = n_gpm/n*100,
            perc_bonus_mismatch = n_gbm/n*100
  ) 

#send percent columns to vectors
  #1 = PEER, 2 = female, 3 = FG, 4 = LowSES
  #1-4 = CellBio, 5-8 = Genetics

penaltyperc <- scales::percent(round(diff_tab$perc_penalty_mismatch/100, digits = 3))
bonusperc <- scales::percent(round(diff_tab$perc_bonus_mismatch/100, digits = 3))

#split facets ####
cb <- splitFacet(diff_cellbio)
g <- splitFacet(diff_genetics)


#cowplot for MS ####
#shared edits 
sharedx <- xlim(-1,1) 
  #note: balanced x axis following Nick's suggestion. Excludes 5 points from plots though. 
sharedy <- ylim(-2,2)

figIVmain <- cowplot::plot_grid(g[[2]] + labs(subtitle = "Genetics", y = "Women") + sharedx + sharedy + 
                                 annotate(geom = "text", x=Inf, y = -Inf, label = penaltyperc[6],
                                          vjust = -2, hjust = 1.5), 
                           cb[[2]] + labs(subtitle = "CellBio")+ sharedx + sharedy +
                             annotate(geom = "text", x=Inf, y = -Inf, label = penaltyperc[2],
                                      vjust = -2, hjust = 1.5),
                           g[[1]] + labs(y = "PEER")+ sharedx + sharedy +
                             annotate(geom = "text", x=Inf, y = -Inf, label = penaltyperc[5],
                                      vjust = -2, hjust = 1.5), 
                           cb[[1]]+ sharedx + sharedy + 
                             annotate(geom = "text", x=Inf, y = -Inf, label = penaltyperc[1],
                                      vjust = -2, hjust = 1.5), 
                           g[[3]] + labs(y = "FirstGen")+ sharedx + sharedy + 
                             annotate(geom = "text", x=Inf, y = -Inf, label = penaltyperc[7],
                                      vjust = -2, hjust = 1.5), 
                           cb[[3]]+ sharedx + sharedy + 
                             annotate(geom = "text", x=Inf, y = -Inf, label = penaltyperc[3],
                                      vjust = -2, hjust = 1.5),
                           g[[4]] + labs(y = "LowSES")+ sharedx + sharedy + 
                             annotate(geom = "text", x=Inf, y = -Inf, label = penaltyperc[8],
                                      vjust = -2, hjust = 1.5), 
                           cb[[4]]+ sharedx + sharedy + 
                             annotate(geom = "text", x=Inf, y = -Inf, label = penaltyperc[4],
                                      vjust = -2, hjust = 1.5),
                           labels = "AUTO", nrow = 4, ncol = 2, align = "v", axis = "b")

#get legend for bottom 
figIVlegend <- cowplot::get_legend(g[[4]] + labs(fill = "Institution") + theme(legend.position = "bottom"))

#shared x and y axis labels
x.grobIV <- textGrob("GPAO Difference (1-0)", gp=gpar(fontsize=14, fontface = "bold"))
y.grobIV <- textGrob("Course Grade Difference (1-0)", gp=gpar(fontsize=14, fontface = "bold"), rot = 90)

#add labels to plot
figIV <- gridExtra::grid.arrange(arrangeGrob(figIVmain, bottom = x.grobIV, left = y.grobIV))

#cowplot the grob and the legend together
figIV_final <- cowplot::plot_grid(figIV, 
                           figIVlegend, 
                           nrow = 2, align = "h", axis = "l",
                           rel_heights = c(1,0.1))

#export plot ####
ggsave(filename = paste0("figIV_diffGPAO_diffGrade_", current_date, ".png"), path = "figures/",
       figIV_final, height = 960/96, width = 735/96, units = "in", dpi = 300, bg= "white")


#export data underlying plot ####
write.csv(diff_tab, file = paste0("~/Google Drive/My Drive/WG1P6/Processed Data/figIV_underlying-data_", current_date,".csv"))
