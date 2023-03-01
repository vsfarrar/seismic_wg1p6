#MS Figure 5. SAI by Transfer Status #
#issue: code only produces grade anomaly, not raw grades for this

#setup ####
#load data ####
sai <- read.csv("~/Google Drive/My Drive/WG1P6/Processed Data/SAI_plot_data_2022-10-04.csv")

#source functions
source("~/Documents/GitHub/seismic_wg1p6/figure_code/seismic_figures_setup.R")

#SAI by transfer ####
#issue: some very small sample sizes for transfer students - include?
#this data is means across all offerings only

sai_by_transfer <-
  sai %>%
  filter(category == "transfer") %>%
  select(-X.1, -X, -se_grade_anomaly,-female) |>
  pivot_wider(names_from = transfer,
              values_from = c(mean_grade_anomaly, n)) %>%
  mutate(diff_grade_anom = mean_grade_anomaly_1 - mean_grade_anomaly_0,
         n_total = n_0 + n_1)
  
#__plot####  
fig5 <-
  ggplot(sai_by_transfer, aes(x = SAI, y = diff_grade_anom, 
             fill = university)) + 
  geom_point(aes(size = n_total),
             position = position_dodge(0.2), 
             alpha = 0.8, pch = 21) + 
  geom_hline(yintercept = 0) + 
  facet_wrap(~crs_topic) +
  ylim(-0.6,0.3)+ #excludes an outlier from Purdue at -2
  theme_bw(base_size = 14) + 
  scale_size_continuous(trans = "log10", breaks = c(10,100,1000))+ #point size for readability
  scale_fill_manual(values = deid_colors, labels = deid_labels) + 
  labs(y = "Difference in Mean Grade Anomaly \n(Transfer- non-Transfer)", 
       fill = "Institution",
       size  = "N") +
  theme_minimal(base_size = 14) + 
  theme(axis.text = element_text(color = "black"), 
        strip.text = element_text(color = "black"), 
        panel.border = element_rect(color = "black", fill = NA, size = 1), 
        strip.background = element_rect(color = "black", size = 1), 
        panel.grid.major.x = element_blank(),  #mask horizontal gridlines
        panel.grid.minor.x = element_blank())

##split facet ####
#issue: splitFacet does not work for facet_grid objects

f5 <- splitFacet(fig5) 

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

