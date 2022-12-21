#Figures for SABER West 2023 presentation#
all_dem <- read.csv("~/Google Drive/My Drive/WG1P6/Processed Data/all_demographic_gaps2022-10-13.csv")
betas <- read.csv("~/Google Drive/My Drive/WG1P6/Processed Data/all_model_estimates_2022-09-30.csv")

sai <- read.csv("~/Google Drive/My Drive/WG1P6/Processed Data/SAI_plot_data_2022-10-04.csv")
sai_offerings <- read.csv("~/Google Drive/My Drive/WG1P6/Processed Data/SAI_by_offering_2022-10-11.csv")

source("~/Documents/GitHub/seismic_wg1p6/figure_code/seismic_figures_setup.R")

#Demographics ####
#__table percents ####
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

#reorder the universities 
dem_percent$uni_label <- recode_factor(dem_percent$university,
                                       "ASU" = "A", "UCD" = "B",
                                       "IU" = "C", "Purdue" = "D", 
                                       "UM" = "E")
levels(dem_percent$uni_label) <- c("A", "B", "C","D","E")

#reorder other factors
dem_percent$demographic_var <- factor(dem_percent$demographic_var, 
                                      labels = demog_labels)
dem_percent$crs_topic <- factor(dem_percent$crs_topic, 
                                levels = c("Genetics", "CellBio"))

#alphabetical colors
alpha_colors <- c("A" = "#66c2a5",
                  "B" = "#e78ac3",
                  "C" = "#fc8d62",
                  "D" = "#8da0cb",
                  "E" = "#a6d854")
#__plot####
  dem_percent %>%
  filter(value == "1") %>%
  ggplot(aes(x = forcats::fct_rev(demographic_var), y = perc, fill = forcats::fct_rev(uni_label))) +   
  geom_col(position = position_dodge(0.9), color = "black") +
  geom_text(aes(label = round(perc,0)), position = position_dodge(0.9), 
            hjust = -0.25, size = 5) + 
  labs(x = NULL, y = "Percent of students (%)", fill = "Institution") + 
  ylim(0,80) + 
  scale_fill_manual(values = alpha_colors) + 
  facet_wrap(~crs_topic) + 
  coord_flip() + 
  theme_classic(base_size = 18) + 
  theme(text = element_text(size = 20),
        axis.text = element_text(color = "black", size = 20), 
          strip.text = element_text(color = "black", size = 25), 
          panel.border = element_rect(color = "black", fill = NA, size = 1), 
          strip.background = element_rect(color = "black", size = 1)) 


#Model Estimates ####
#new labels
var_labels <- c("Female" = "Woman",
                "FirstGen" = "FirstGen",
                "LowIncome"= "LowSES",
                "Transfer" = "Transfer",
                "EthnicityBIPOC" = "PEER")
betas$variable <- relevel(as.factor(betas$variable), ref = "Female")
betas$crs_topic <- relevel(as.factor(betas$crs_topic), ref = "Genetics")

#__table ####
estims <-
  betas %>% 
  filter(international_included == 1) %>%
  mutate(significant = ifelse(is.na(s.sig), 0,1)) %>%
  filter(!(variable %in% c("GPAO","EthnicityAsianAsianAmerican", "EthnicityOther"))) %>% 
  mutate(uni_topic = paste(crs_topic, university, sep = "_"), #crs_topic 1st allows  x axis to be split by course
         sig_topic = paste(crs_topic, significant, sep = "_")) %>%
  mutate(uni_topic = factor(uni_topic, 
                            levels = c("Genetics_ASU", "Genetics_UCD",
                                       "Genetics_IU", "Genetics_Purdue",
                                       "Genetics_UM", "CellBio_ASU",
                                       "CellBio_UCD", "CellBio_IU",
                                       "CellBio_Purdue", "CellBio_UM"))) %>%
  mutate(num_uni_topic = as.integer(as.factor(uni_topic)))  #convert to numeric for x breks

#__plot####
ggplot(estims, aes(x = num_uni_topic, y = estimate, 
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
  facet_wrap(~variable, labeller = as_labeller(var_labels),
             ncol = 5) + 
  labs(x = NULL, y = "Estimate ± SE", shape = NULL, color = "GPAO in model?") + 
  theme_minimal(base_size = 20) + 
  theme(text = element_text(size = 20), 
        axis.text = element_text(color = "black", size = 18), 
        strip.text = element_text(color = "black", size = 24), 
        panel.border = element_rect(color = "black", fill = NA, size = 1), 
        strip.background = element_rect(color = "black", size = 1),
        panel.grid.major.y = element_blank(),  #mask vertical gridlines
        panel.grid.minor.y = element_blank())

#SAI (raw grade) ####

#__summarise grades across SAI across all offerings ####

sai_grades <-
  sai_offerings %>%
  group_by(university, crs_topic, SAI) %>%
  summarise(n = sum(n),
            avg_grade = mean(mean_grade),
            se_grade = std.error(mean_grade))

#reorder course topics
sai_grades$crs_topic <- factor(sai_grades$crs_topic, 
                                levels = c("Genetics", "CellBio"))
#relabel order of institutions
sai_grades$uni_label <- recode_factor(sai_grades$university,
                                       "ASU" = "A", "UCD" = "B",
                                       "IU" = "C", "Purdue" = "D", 
                                       "UM" = "E")
levels(sai_grades$uni_label) <- c("A", "B", "C","D","E")

#__plot (raw grades) ####
  sai_grades %>%
  ggplot(aes(x = SAI, y = avg_grade, fill = uni_label)) + 
  geom_point(aes(size = n),
             position = position_dodge(0.2), 
             alpha = 0.8, color = "black", pch = 21) + 
  #geom_smooth(aes(fill= university, group = university), method = "lm", se = FALSE) + #correlation lines
  geom_hline(yintercept = 0) + 
  facet_wrap(~crs_topic) +
  theme_bw(base_size = 14) + 
  scale_size_continuous(trans = "log10", breaks = c(10,100,1000))+ #point size for readability
  scale_fill_manual(values = alpha_colors) + 
  scale_y_continuous(breaks = seq(0,4,by = 1), limits = c(1,3.5)) + 
  labs(x = "No. of Systemic Advantages", y = "Course Grade", color = "Institution", fill = "Institution", size = "N") +
  theme_minimal(base_size = 20) + 
  theme(axis.text = element_text(color = "black", size = 20), 
        strip.text = element_text(color = "black", size = 24), 
        panel.border = element_rect(color = "black", fill = NA, size = 1), 
        strip.background = element_rect(color = "black", size = 1), 
        panel.grid.major.x = element_blank(),  #mask horizontal gridlines
        panel.grid.minor.x = element_blank()) +
  guides(fill = guide_legend(override.aes = list(size=4)))

#__plot (grade anomaly) ####
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

#__average numbers
sai_grades %>%
  group_by(crs_topic, SAI) %>%
  summarise(mean(avg_grade))

