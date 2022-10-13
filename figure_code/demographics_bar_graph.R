#load data
all_dem <- read.csv("~/Google Drive/My Drive/WG1P6/Processed Data/all_demographic_gaps_2022-10-13.csv")

#summarise data in one table 
dem_percent <- all_dem %>% group_by(crs_topic,university,demographic_var, value) %>% 
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

#plot
dem_percent %>%
filter(value == "1") %>%
  ggplot(aes(x = demographic_var, y = perc, fill = university)) +   
  geom_col(position = position_dodge(0.9), color = "black") +
  geom_text(aes(label = round(perc,0)), position = position_dodge(0.9), hjust = -0.25) + 
  labs(x = NULL, y = "Percent of all students (%)", fill = "Institution") + 
  ylim(0,80) + 
  scale_fill_manual(values = deid_colors, labels = deid_labels) + 
  scale_x_discrete(labels = demog_labels) + 
  facet_grid(~crs_topic) + 
  coord_flip() + 
  theme_seismic + 
  theme(axis.text = element_text(color = "black"), 
        strip.text = element_text(color = "black"))
