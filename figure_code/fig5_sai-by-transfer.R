#MS Figure 5. SAI by Transfer Status #
#issue: code only produces grade anomaly, not raw grades for this

#setup ####
#load data ####
sai <- read.csv("~/Google Drive/My Drive/WG1P6/Processed Data/SAI_plot_data_2022-10-04.csv")

#source functions
source("~/Documents/GitHub/seismic_wg1p6/figure_code/seismic_figures_setup.R")

#SAI by transfer ####
#issue: some very small sample sizes for transfer students - include?

sai_by_transfer <- 
  sai %>%
  filter(category == "transfer") %>%
  mutate(SAI_transf = paste(SAI, transfer, sep = "_")) %>%
  ggplot(aes(x = SAI, y = mean_grade_anomaly, 
             fill = university, shape = as.factor(transfer))) + 
  geom_point(aes(size = n),
             position = position_dodge(0.2), 
             alpha = 0.8, color = "black") + 
  geom_hline(yintercept = 0) + 
  #facet_wrap(~crs_topic) +
  ylim(-1.5,0)+ #excludes an outlier from Purdue at -2
  facet_grid(rows = vars(crs_topic), cols = vars(transfer)) +
  theme_bw(base_size = 14) + 
  scale_shape_manual(values = c(21,22)) + 
  scale_size_continuous(trans = "log10", breaks = c(10,100,1000))+ #point size for readability
  scale_fill_manual(values = deid_colors, labels = deid_labels) + 
  #scale_x_discrete(labels = c("0","0","1","1","2","2","3","3","4","4")) + 
  labs(y = "Mean Grade Anomaly", color = "Institution") 

##split facet ####
#issue: splitFacet does not work for facet_grid objects

f5 <- splitFacet(sai_by_transfer) 

#cowplot for m.s. ####
fig5panels <- cowplot::plot_grid(f5[[1]] + labs(subtitle = "CellBio"),
                           f5[[2]],
                           f5[[2]],
                           f5[[2]],
                           labels = "AUTO", nrow = 2, ncol = 2, align = "hv", axis = "bt")


#shared x and y axis labels
x.grob2 <- textGrob("SAI", gp=gpar(fontsize=14))
y.grob2 <- textGrob("Final course grade", gp=gpar(fontsize=14), rot = 90)

#add labels to plot
fig2_final <- gridExtra::grid.arrange(arrangeGrob(fig2, bottom = x.grob2, left = y.grob2))

# #export plot ####
# ggsave(filename = paste0("fig2_sai_raw_grades_", current_date, ".png"), path = "figures/",
#        fig2_final, height = 430/96, width = 800/96, units = "in", dpi = 300)

