#MS Figure 2
#Grade Anomaly by SAI 

#setup ####
#load data ####
sai <- read.csv("~/Google Drive/My Drive/WG1P6/Processed Data/SAI_plot_data_2022-10-04.csv")
sai_offerings <- read.csv("~/Google Drive/My Drive/WG1P6/Processed Data/SAI_by_offering_2022-10-11.csv")

#source functions
source("~/Documents/GitHub/seismic_wg1p6/figure_code/seismic_figures_setup.R")

#SAI (raw grade) ####

#__summarise grades across SAI across all offerings ####

sai_aga <-
  sai_offerings %>%
  group_by(university, crs_topic, SAI) %>%
  summarise(n = sum(n),
            mean_aga = mean(mean_grade - mean_gpao),
            se_aga = std.error(mean_grade - mean_gpao))

#__overall aga per course ####
aga_cellbio <- mean(sai_offerings$mean_grade[sai_offerings$crs_topic == "CellBio"] - 
                    sai_offerings$mean_gpao[sai_offerings$crs_topic == "CellBio"])

aga_gen <- mean(sai_offerings$mean_grade[sai_offerings$crs_topic == "Genetics"] - 
                      sai_offerings$mean_gpao[sai_offerings$crs_topic == "Genetics"])

#__plot ####

plot_sai_aga <-
sai_aga %>%
  ggplot(aes(x = SAI, y = mean_aga, fill = university)) + 
  geom_point(aes(size = n),
             position = position_dodge(0.2), 
             alpha = 0.8, color = "black", pch = 21) + 
  #geom_smooth(aes(fill= university, group = university), method = "lm", se = FALSE) + #correlation lines
  geom_hline(yintercept = 0) + 
  facet_wrap(~crs_topic) +
  theme_bw(base_size = 14) + 
  scale_size_continuous(trans = "log10", breaks = c(10,100,1000))+ #point size for readability
  scale_fill_manual(values = deid_colors, labels = deid_labels) + 
  #scale_y_continuous(breaks = seq(0,4,by = 1), limits = c(0,4)) + 
  labs(x = NULL, y = NULL, color = "Institution", fill = "Institution", size = "N") +
  theme_minimal(base_size = 14) + 
  theme(axis.text = element_text(color = "black"), 
        strip.text = element_text(color = "black"), 
        panel.border = element_rect(color = "black", fill = NA, size = 1), 
        strip.background = element_rect(color = "black", size = 1), 
        panel.grid.major.x = element_blank(),  #mask horizontal gridlines
        panel.grid.minor.x = element_blank(),
        legend.position = "none") 

#split facet ####
fiii <- splitFacet(plot_sai_aga)

#cowplot for m.s. ####
figIII <- cowplot::plot_grid(fiii[[2]] + labs(subtitle = "Genetics") + 
                               geom_hline(yintercept = aga_gen, linetype = "dashed"),
                           fiii[[1]] + labs(subtitle = "CellBio") +
                             geom_hline(yintercept = aga_cellbio, linetype = "dashed"),
                           cowplot::get_legend(fiii[[1]]+ theme(legend.position = "right") + 
                                                        guides(fill = guide_legend(override.aes = list(size=4)))), 
                           labels = c("A","B",""), nrow = 1, align = "v", axis = "b", 
                           rel_widths = c(1,1,0.5))

#shared x and y axis labels
x.grob2 <- textGrob("SAI", gp=gpar(fontsize=14))
y.grob2 <- textGrob("Average grade anomaly", gp=gpar(fontsize=14), rot = 90)

#add labels to plot
figIII_final <- gridExtra::grid.arrange(arrangeGrob(figIII, bottom = x.grob2, left = y.grob2))

#export plot ####
ggsave(filename = paste0("figIII_sai_grade_anomaly_", current_date, ".png"), path = "figures/",
       figIII_final, height = 430/96, width = 800/96, units = "in", dpi = 300)


#export data underlying plot ####
write.csv(sai_aga, file = paste0("~/Google Drive/My Drive/WG1P6/Processed Data/figIII_underlying-data_", current_date,".csv"))

