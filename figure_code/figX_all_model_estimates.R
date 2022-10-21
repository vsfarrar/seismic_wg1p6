#MS Figure 1. Model Outputs #

#setup ####
#load data
#currently: international included, coded conservatively

betas <- read.csv("~/Google Drive/My Drive/WG1P6/Processed Data/all_model_estimates_2022-09-30.csv")

#source functions
source("~/Documents/GitHub/seismic_wg1p6/figure_code/seismic_figures_setup.R")

#plot ####
#plot model estimates with GPAO controlled for

all_models_plot <- 
  betas %>% 
  filter(international_included == 1) %>%
  mutate(significant = ifelse(is.na(s.sig), 0,1)) %>%
  filter(!(variable %in% c("GPAO","EthnicityAsianAsianAmerican", "EthnicityOther"))) %>% 
  mutate(uni_topic = paste(crs_topic, university, sep = "_"), #crs_topic 1st allows  x axis to be split by course
         sig_topic = paste(crs_topic, significant, sep = "_")) %>%
  mutate(num_uni_topic = as.integer(as.factor(uni_topic))) %>% #convert to numeric for x breks
  ggplot(aes(x = num_uni_topic, y = estimate, 
             color = as.factor(GPAO_included), shape = sig_topic)) + 
  geom_point(size = 3) + 
  geom_errorbar(aes(ymin = estimate - std.error, 
                    ymax = estimate + std.error), 
                width = 0.1) + 
  geom_hline(yintercept = 0) +
  geom_vline(xintercept = 5.5, color = "black", alpha = 0.9) + 
  scale_shape_manual(values = c(1,16,2,17),
                     labels = c("CellBio: n.s.", "CellBio: p < 0.05",
                                "Genetics: n.s.", "Genetics: p < 0.05")) + 
  scale_color_discrete(labels = c("no", "yes")) + 
  scale_x_continuous(minor_breaks = seq(1,10,by =1),
                     breaks = seq(1,10, by = 1),
                     labels = rep(deid_labels,2)) +
  facet_wrap(~variable, ncol = 5) + 
  labs(x = NULL, y = NULL, shape = NULL, color = "GPAO in model?") + 
  theme_minimal(base_size = 14) + 
  theme(axis.text = element_text(color = "black"), 
        strip.text = element_text(color = "black"), 
        panel.border = element_rect(color = "black", fill = NA, size = 1), 
        strip.background = element_rect(color = "black", size = 1),
        panel.grid.major.y = element_blank(),  #mask vertical gridlines
        panel.grid.minor.y = element_blank(), 
        legend.position =  "none")

#improved legends ####
  #improved legend for above plot (to be used in cowplots)

#shape: course 
shape_legend <- cowplot::get_legend(
  data.frame(x = c(1:2), y = c(1:2), shape = c("CellBio", "Genetics")) %>%
    ggplot(aes(x, y, shape = shape)) + 
    geom_point(size = 4, fill = "white") + 
    scale_shape_manual(values = c(21,24), name = "Subject") + 
    theme_minimal(base_size = 14)+
    theme(plot.margin = unit(c(0, 0, 0, 0), "cm"))
)

#shape: circle white or black for significance
fill_legend <- cowplot::get_legend(
  data.frame(x = c(1:2), y = c(1:2), fill = c("n.s.", "p < 0.05")) %>%
    ggplot(aes(x, y, fill = fill)) + 
    geom_point(size = 4, pch = 21, color = "black") + 
    scale_fill_manual(values = c("white", "black"), name = NULL) + 
    theme_minimal(base_size = 14) + 
    theme(plot.margin = unit(c(0, 0, 0, 0), "cm"))
)

#color: GPAO in model or not
color_legend <- cowplot::get_legend(
  data.frame(x = c(1:2), y = c(1:2), color = c("GPAO in model", "no GPAO")) %>%
    ggplot(aes(x, y, color = color)) + 
    geom_point(size = 3) + geom_smooth(aes(group = color), se = FALSE) +
    labs(color = NULL) + 
    theme_minimal(base_size = 14) + 
    theme(plot.margin = unit(c(0, 0, 0, 0), "cm"))
)

better_legend <- 
  cowplot::plot_grid(shape_legend, fill_legend, color_legend, 
                     nrow = 3, align = "h", rel_heights = c(0.5,0.5,0.5))

#split facets ####
f1 <- splitFacet(all_models_plot)

#cowplot for m.s. ####
fig1 <- cowplot::plot_grid(f1[[2]] + ylim(-0.7,0.4) + annotate(geom = "text", x = 3, y = -0.7, label = "CellBio") + 
                     annotate(geom = "text", x = 8, y = -0.7, label = "Genetics") +
                     labs(subtitle = "Women"),
                   f1[[3]] + labs(subtitle = "PEER") + ylim(-0.7,0.4), 
                   f1[[5]] + labs(subtitle = "FirstGen") + ylim(-0.7,0.4),
                   f1[[7]] + labs(subtitle = "LowSES") + ylim(-0.7,0.4),
                   cowplot::get_legend(f1[[7]]+ theme(legend.position = "right")), 
                   labels = c("A","B","C","D",""), nrow = 1, align = "v", axis = "b", 
                   rel_widths = c(1,1,1,1,0.7))

#shared x and y axis labels
x.grob <- textGrob("Institution", gp=gpar(fontsize=14))
y.grob <- textGrob("Estimate ± SE ", gp=gpar(fontsize=14), rot = 90)

#add labels to plot
fig1_final <- gridExtra::grid.arrange(arrangeGrob(fig1, bottom = x.grob, left = y.grob))

#export plot ####

ggsave(filename = paste0("figX_all_model_estimates_", current_date, ".png"), path = "figures/",
       fig1_final, height = 410/96, width = 1060/96, units = "in", dpi = 300)