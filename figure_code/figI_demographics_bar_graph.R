#MS Figure 1. Demographics #

#setup ####
#load data
#currently: international included, coded conservatively

all_dem <- read.csv("~/Google Drive/My Drive/WG1P6/Processed Data/all_demographic_gaps2023-03-08.csv")

#source functions
source("~/Documents/GitHub/seismic_wg1p6/figure_code/seismic_figures_setup.R")

#summarise data in one table ####
dem_percent <- all_dem %>% 
  filter(international_included == 1) %>%
  group_by(crs_topic,university,demographic_var, value) %>% 
  summarise(n_total = sum(n_group),
            n_course = mean(n_course)) %>% 
  mutate(perc = n_total/n_course *100) #percent for each level

#clean up for plot
dem_percent$university <- factor(dem_percent$university, levels = rev(c("ASU", "IU", "Purdue", "UCD","UM")))
demog_labels <- c("lowincomeflag" = "LowSES", 
                             "female" = "Women", 
                             "firstgen" = "FirstGen", 
                             "transfer" = "Transfer",
                             "ethniccode_cat" = "PEER")

#plot ####
dem_bars <- 
dem_percent %>%
  filter(value == "1") %>%
  ggplot(aes(x = demographic_var, y = perc, fill = university)) +   
  geom_col(position = position_dodge(0.9), color = "black") +
  geom_text(aes(label = round(perc,0)), position = position_dodge(0.9), hjust = -0.25) + 
  labs(x = NULL, y = NULL, fill = "Institution") + 
  ylim(0,80) + 
  scale_fill_manual(values = deid_colors, labels = deid_labels) + 
  scale_x_discrete(labels = demog_labels) + 
  facet_wrap(~crs_topic) + 
  coord_flip() + 
  theme_seismic + 
  theme(axis.text = element_text(color = "black"), 
        strip.text = element_text(color = "black"),
        legend.position = "none")

#split facet ####
f1 <- splitFacet(dem_bars)

#cowplot for m.s. ####
fig1 <- cowplot::plot_grid(f1[[2]] + labs(subtitle = "Genetics"),
                           f1[[1]] + labs(subtitle = "CellBio"),
                           cowplot::get_legend(f1[[1]]+ theme(legend.position = "right")), 
                           labels = c("A","B",""), nrow = 1, align = "v", axis = "b", 
                           rel_widths = c(1,1,0.5))

#shared x and y axis labels
x.grob <- textGrob("Percent of all students (%)", gp=gpar(fontsize=14))

#add labels to plot
fig1_final <- gridExtra::grid.arrange(arrangeGrob(fig1, bottom = x.grob))

#export plot ####
ggsave(filename = paste0("fig1_demographic_barpot_", current_date, ".png"), path = "figures/",
       fig1_final, height = 500/96, width = 770/96, units = "in", dpi = 300)