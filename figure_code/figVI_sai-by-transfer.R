#MS Figure 5. 
#SAI by Transfer Status #
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
figVI <-
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

fvi <- splitFacet(fig5) 

#cowplot for m.s. ####
figVIpanels <- cowplot::plot_grid(fvi[[2]] + labs(subtitle = "Genetics", y = NULL, x = NULL) + 
                                    theme(legend.position = "none"),
                           fvi[[1]] + labs(subtitle = "CellBio", y = NULL, x= NULL) + theme(legend.position = "none" ),
                           cowplot::get_legend(fvi[[1]]+ theme(legend.position = "right") + 
                                                 guides(fill = guide_legend(override.aes = list(size=4)))),
                           nrow = 1, align = "v", axis = "bt",
                           rel_widths = c(1,1,0.25), labels = c("A", "B", ""))

#shared x and y axis labels
x.grobvi <- textGrob("SAI", gp=gpar(fontsize=14))
y.grobvi <- textGrob("Difference in Mean Grade Anomaly \n(Transfer-nonTransfer)", gp=gpar(fontsize=14), rot = 90)

#add labels to plot
figVI_final <- gridExtra::grid.arrange(arrangeGrob(figVIpanels, bottom = x.grobvi, left = y.grobvi))

# #export plot ####
ggsave(filename = paste0("figVI_sai_by_transfer_", current_date, ".png"), path = "figures/",
     figVI_final, height = 430/96, width = 800/96, units = "in", dpi = 300)

