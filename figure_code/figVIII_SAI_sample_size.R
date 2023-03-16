#MS Figure: Sample Size by SAI by Institution #

#setup ####
#load data ####
sai <- read.csv("~/Google Drive/My Drive/WG1P6/Processed Data/SAI_plot_data_2022-10-04.csv")
sai_offerings <- read.csv("~/Google Drive/My Drive/WG1P6/Processed Data/SAI_by_offering_2022-10-11.csv")

#source functions
source("~/Documents/GitHub/seismic_wg1p6/figure_code/seismic_figures_setup.R")

# sample size and % by SAI ####
sai_sample_size <-
sai %>%
  filter(category == "all") %>% #select all groups
  select(university, crs_name, crs_topic, SAI, n) %>%
  group_by(university, crs_name) %>%
  mutate(n_total = sum(n),
         perc = n/n_total*100) 

#manually add a line to show n = 0 with SAI = 0 for UM ####

sai_sample_size[nrow(sai_sample_size) + 1,] <- list("UM","BIOLOGY 305","Genetics", 0, 0, 6478, 0)
sai_sample_size[nrow(sai_sample_size) + 1,] <- list("UM","MCDB 428","CellBio", 0, 0, 6478, 0)

#order universities for plot
sai_sample_size$university <- factor(sai_sample_size$university, levels = rev(c("ASU", "IU", "Purdue", "UCD","UM")))

#plot ####
sai_perc <-
ggplot(sai_sample_size,
       aes(x = SAI, y = perc, fill = university)) + 
  geom_col(position = position_dodge(0.9), color = "black") + 
  facet_wrap(~crs_topic, ncol= 2) +
  geom_text(aes(label = round(perc,0)), position = position_dodge(0.9), vjust = 0.5, hjust = -0.5) + 
  labs(x = "SAI", y = "Percent (%)", fill = "Institution") + 
  scale_fill_manual(values = deid_colors, labels = deid_labels) + 
  scale_y_continuous(limits = c(0,55), breaks = seq(0,55, by = 10)) +
  coord_flip() + 
  theme_seismic + 
  theme(axis.text = element_text(color = "black"), 
        strip.text = element_text(color = "black"))

#split facet ####
fig <- splitFacet(sai_perc)

#cowplot for m.s. ####
figX_graphs <- cowplot::plot_grid(fig[[2]] + labs(subtitle = "Genetics", y = NULL) + theme(legend.position = "none"),
                           fig[[1]] + labs(subtitle = "CellBio",x = NULL, y = NULL) + theme(legend.position = "none"), 
                           ncol = 2, align = "v", axis = "b",
                           labels = c("A", "B"),
                           rel_widths = c(1,1))

# add legend
figX <- cowplot::plot_grid(figX_graphs,
                           cowplot::get_legend(sai_perc),
                           ncol = 2, align = "v", axis = "b",
                           rel_widths = c(1, 0.15))

#shared x and y axis labels
x.grob <- textGrob("Percent of all students (%)", gp=gpar(fontsize=14))

#add labels to plot
figX_final <- gridExtra::grid.arrange(arrangeGrob(figX, bottom = x.grob))

#export plot ####
ggsave(filename = paste0("figX_SAI_sample_size_", current_date, ".png"), path = "figures/",
       figX_final, height = 620/96, width = 690/96, units = "in", dpi = 300, bg = "white")
  