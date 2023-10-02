#MS Figure 2. SAI (Raw Grades) #

#setup ####
#load data ####
sai <- read.csv("~/Google Drive/My Drive/WG1P6/Processed Data/SAI_plot_data_2023-10-02.csv")
sai_offerings <- read.csv("~/Google Drive/My Drive/WG1P6/Processed Data/SAI_by_offering_2023-10-02.csv")

#source functions
source("~/Documents/GitHub/seismic_wg1p6/figure_code/seismic_figures_setup.R")

#SAI (raw grade) ####

#__summarise grades across SAI across all offerings ####

sai_grades <-
  sai_offerings %>%
  group_by(university, crs_topic, SAI) %>%
  summarise(n = sum(n),
            avg_grade = mean(mean_grade),
            se_grade = std.error(mean_grade)) %>%
  #add confidence intervals
  mutate(lowCI = avg_grade - se_grade*1.96,
         hiCI = avg_grade + se_grade*1.96)
  
#__plot ####

plot_sai_grades <-
sai_grades %>%
  ggplot(aes(x = SAI, y = avg_grade, fill = university)) + 
  geom_point(aes(size = n),
             position = position_dodge(0.2), 
             alpha = 0.8, color = "black", pch = 21) + 
  #geom_smooth(aes(fill= university, group = university), method = "lm", se = FALSE) + #correlation lines
  geom_hline(yintercept = 0) + 
  facet_wrap(~crs_topic) +
  theme_bw(base_size = 14) + 
  scale_size_continuous(trans = "log10", breaks = c(10,100,1000))+ #point size for readability
  scale_fill_manual(values = deid_colors, labels = deid_labels) + 
  scale_y_continuous(breaks = seq(0,4,by = 1), limits = c(0,4)) + 
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
f2 <- splitFacet(plot_sai_grades)

#cowplot for m.s. ####
fig2 <- cowplot::plot_grid(f2[[1]] + labs(subtitle = "CellBio"),
                           f2[[2]] + labs(subtitle = "Genetics"),
                           cowplot::get_legend(f2[[1]]+ theme(legend.position = "right") + 
                                                        guides(fill = guide_legend(override.aes = list(size=4)))), 
                           labels = c("A","B",""), nrow = 1, align = "v", axis = "b", 
                           rel_widths = c(1,1,0.5))

#shared x and y axis labels
x.grob2 <- textGrob("SAI", gp=gpar(fontsize=14))
y.grob2 <- textGrob("Final course grade", gp=gpar(fontsize=14), rot = 90)

#add labels to plot
fig2_final <- gridExtra::grid.arrange(arrangeGrob(fig2, bottom = x.grob2, left = y.grob2))

#export plot ####
setwd("~/Documents/GitHub/seismic_wg1p6/")

ggsave(filename = paste0("figII_sai_raw_grades_", current_date, ".png"), path = "figures/",
       fig2_final, height = 430/96, width = 800/96, units = "in", dpi = 300)

#export underlying data ####
write.csv(sai_grades, file = paste0("~/Google Drive/My Drive/WG1P6/Processed Data/figII_underlying-data_", current_date,".csv"))
