#load data ####
sai <- read.csv("~/Google Drive/My Drive/WG1P6/Processed Data/SAI_plot_data_2022-10-04.csv")
sai_offerings <- read.csv("~/Google Drive/My Drive/WG1P6/Processed Data/SAI_by_offering_2022-10-11.csv")

#overall SAI (grade anomaly) ####
sai_plot <- 
  sai %>%
  filter(category == "all") %>%
  ggplot(aes(x = SAI, y = mean_grade_anomaly, color = university)) + 
  geom_point(aes(size = n),
             position = position_dodge(0.2)) + 
  # geom_errorbar(aes(ymin = mean_grade_anomaly-se_grade_anomaly,
  #                   ymax = mean_grade_anomaly+se_grade_anomaly),
  #               width = 0,
  #               position = position_dodge(0.2)) +
  #geom_smooth(aes(fill= university, group = university), method = "lm", se = FALSE) + #correlation lines
  geom_hline(yintercept = 0) + 
  facet_wrap(~crs_topic) +
  theme_bw(base_size = 14) + 
  scale_size_continuous(trans = "log10", breaks = c(10,100,1000))+ #point size for readability
  scale_color_manual(values = deid_colors, labels = deid_labels) + 
  scale_fill_manual(values = deid_colors, labels = deid_labels) + 
  labs(y = "Mean Grade Anomaly", color = "Institution", fill = "Institution", size = "N") +
  theme_minimal(base_size = 14) + 
  theme(axis.text = element_text(color = "black"), 
        strip.text = element_text(color = "black"), 
        panel.border = element_rect(color = "black", fill = NA, size = 1), 
        strip.background = element_rect(color = "black", size = 1), 
        panel.grid.major.x = element_blank(),  #mask horizontal gridlines
        panel.grid.minor.x = element_blank())

#SAI (raw grade) ####

#__summarise grades across SAI across all offerings ###

sai_grades <-
  sai_offerings %>%
  group_by(university, crs_topic, SAI) %>%
  summarise(n = sum(n),
            avg_grade = mean(mean_grade),
            se_grade = std.error(mean_grade))

#__plot ####

sai_grades %>%
  ggplot(aes(x = SAI, y = avg_grade, color = university)) + 
  geom_point(aes(size = n),
             position = position_dodge(0.2), 
             alpha = 0.8) + 
  #geom_smooth(aes(fill= university, group = university), method = "lm", se = FALSE) + #correlation lines
  geom_hline(yintercept = 0) + 
  facet_wrap(~crs_topic) +
  theme_bw(base_size = 14) + 
  scale_size_continuous(trans = "log10", breaks = c(10,100,1000))+ #point size for readability
  scale_color_manual(values = deid_colors, labels = deid_labels) + 
  scale_fill_manual(values = deid_colors, labels = deid_labels) + 
  scale_y_continuous(breaks = seq(0,4,by = 1), limits = c(0,4)) + 
  labs(y = "Grade", color = "Institution", fill = "Institution", size = "N") +
  theme_minimal(base_size = 14) + 
  theme(axis.text = element_text(color = "black"), 
        strip.text = element_text(color = "black"), 
        panel.border = element_rect(color = "black", fill = NA, size = 1), 
        strip.background = element_rect(color = "black", size = 1), 
        panel.grid.major.x = element_blank(),  #mask horizontal gridlines
        panel.grid.minor.x = element_blank())


#SAI by gender ####
  #note: UM did not have any 0f or 1m students for some of their classes, sample size was very small 
  #can comment out highlight4, alpha aes and scale_alpha_manual to not highlight the end of the spectrum

sai_by_gender <- 
sai %>%
  filter(category == "gender") %>%
  mutate(SAI_gender = paste(SAI, female, sep = "_")) %>%
  ggplot(aes(x = SAI_gender, y = mean_grade_anomaly, 
             color = university)) + 
  geom_point(aes(shape = as.factor(female)), 
                 size = 3,
             position = position_dodge(0.2)) + 
  #geom_line(aes(group = university)) + 
  geom_hline(yintercept = 0) + 
  facet_wrap(~crs_topic) +
  theme_bw(base_size = 14) + 
  scale_color_manual(values = deid_colors, labels = deid_labels) + 
  scale_alpha_manual(values = c(0.2,0.9)) + 
  scale_x_discrete(labels = c("0","1m","1f","2m","2f","3m","3f","4")) + 
  labs(y = "Mean Grade Anomaly", color = "Institution",
       shape = "Gender", x = "SAI by Gender") 

#SAI by transfer ####
  #issue: some very small sample sizes for transfer students - include?

sai_by_transfer <- 
  sai %>%
  filter(category == "transfer") %>%
  mutate(SAI_transf = paste(SAI, transfer, sep = "_")) %>%
  ggplot(aes(x = SAI_transf, y = mean_grade_anomaly, 
             color = university)) + 
  geom_point(aes(shape = as.factor(transfer), size = n),
             position = position_dodge(0.2)) + 
  geom_hline(yintercept = 0) + 
  facet_grid(cols = vars(crs_topic), rows = vars(transfer)) +
  theme_bw(base_size = 14) + 
  scale_color_manual(values = deid_colors, labels = deid_labels) + 
  scale_alpha_manual(values = c(0.2,0.9)) + 
  labs(y = "Mean Grade Anomaly", color = "Institution") 

#export plots ####
setwd("~/Documents/Github/seismic_wg1p6/figures")
ggsave(filename = paste0("sai_all_",current_date,".png"), plot = sai_plot,
       width = 890/96, height = 590/96 , units = "in", dpi = 300)
       
