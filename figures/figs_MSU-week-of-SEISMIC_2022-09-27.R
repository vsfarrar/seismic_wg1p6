source(file = "~/Documents/GitHub/seismic_wg1p6/figures/seismic_figures_setup.R")

#Data downloaded from Google Drive > Shared with Me > WG1P6 > Output files

setwd("~/Google Drive/My Drive/WG1P6/Output files/Archived output files/")
#import data
umich <- read.csv("UMich_mixed_model_outputs_main_effects_robust_2022-06-15.csv") %>% select(-X) %>%
  mutate(institution = "UM")
iu <- read.csv("IUB__mixed_model_outputs_main_effects_robust_2022-03-01.csv") %>% select(-X) %>%
  mutate(institution = "IU")
ucd_bis104 <- read.csv("UCD_BIS104_robustlmm_results_2022-02-04.csv") %>% mutate(crs_name = "BIS104") %>% 
  select(crs_name, effect, term:s.sig) %>% mutate(institution = "UCD")
ucd_bis101 <- read.csv("UCD_BIS101_robustlmm_results_2022-02-04.csv") %>% mutate(crs_name = "BIS101") %>% 
  select(crs_name, effect, term:s.sig) %>% mutate(institution = "UCD")
purdue <- read.csv("Purdue_mixed_model_outputs_main_effects_robust_2022-07-11.csv") %>% select(-X) %>% mutate(institution = "Purdue")

#stack data together
bio <- rbind(iu,ucd_bis101, ucd_bis104, umich, purdue)

bio <- replace_with_na(bio, replace = list(s.sig = "")) %>% #non-significant to NA
  mutate(term = as.factor(term))

bio_mainfx <- bio %>% filter(effect == "fixed" & term != "(Intercept)") 

#clean up factor levels, misspellings
bio_mainfx$variable <- bio_mainfx$term
levels(bio_mainfx$variable) <- list(GPAO = "gpao",
                              Female = c("female", "female1"),
                              FirstGen = c("firstgen", "firstgen1"),
                              LowIncome = c("lowincomeflag", "lowincomeflag1", "lowincomflag"),
                              Transfer = c("transfer", "transferTransfer", "transfer1"),
                              International = c("international", "international1"), 
                              EthnicityBIPOC = c("as.factor(ethnicode_cat)1", "as.factor(ethniccode_cat)1"),
                              EthnicityAsianAsianAmerican = c("as.factor(ethnicode_cat)2","as.factor(ethniccode_cat)2"),
                              EthnicityOther = c("as.factor(ethnicode_cat)3", "as.factor(ethniccode_cat)3"))

#create course variable 
bio_mainfx$crs_topic <- as.factor(bio_mainfx$crs_name)
levels(bio_mainfx$crs_topic) <- list(CellBio = c("BIOL-L312","MCDB 428","BIS104","Biology III: Cell Structure And Function"), 
                                     Genetics = c("BIS101", "BIOLOGY 305", "BIOL-L311","Biology IV: Genetics And Molecular Biology"),
                                     Physiology = c("BIOL-P451"))

                                           
# Model Estimates Plot ####

fig2 <-
bio_mainfx %>% 
  filter(variable != "GPAO" & crs_topic != "Physiology") %>% #exclude GPAO (large estimate skews axis)
  filter(!is.na(variable)) %>% #exclude ICT from IU (I think these are freshmen?)
  mutate(significant = ifelse(is.na(s.sig), "not significant", "significant")) %>%
ggplot(aes(x = crs_topic, y = estimate, color = institution)) + 
  geom_point(aes(group = institution, shape = significant), size = 3,
             position = position_dodge(0.5)) + 
  geom_errorbar(aes(group = institution, ymin = estimate - std.error, ymax = estimate + std.error),
                width = 0.5,position = position_dodge(0.5)) + 
  geom_hline(yintercept = 0) +
  geom_vline(xintercept = 1.5) + 
  scale_shape_manual(values = c(1,16)) + 
  scale_color_manual(values = deid_colors, labels = c("A", "B", "C", "D")) + #de-identify institutions
  labs(x = NULL, y = "Model estimate ± SE", color = "Institution", shape = NULL, 
       #title = "Upper-Division Biology equity gaps across institutions", 
       #subtitle = "Robust mixed model estimates, controlling for GPAO"
       ) + 
  facet_wrap(~variable) + 
  theme_bw(base_size = 14) +
  theme(axis.text = element_text(color = "black"), 
        strip.text = element_text(color = "black"))

#split facets (starts on facet 2)
p<- splitFacet(fig2)
splits <-  theme(legend.position = "none", title = element_text(size = 10))
fig2A <- p[[2]] + ggtitle("Women") + ylim(-0.4,0.3) +  splits 
fig2B <- p[[3]] + ggtitle("First Generation") + ylim(-0.4,0.3) + splits + labs(y = NULL)
fig2C <- p[[4]] + ggtitle("Low Income")+ ylim(-0.4,0.3) + splits + labs(y = NULL)
fig2D <- p[[5]] + ggtitle("Transfer")+ ylim(-0.4,0.3) + splits + labs(y = NULL)
fig2E <- p[[7]] + ggtitle("PEER")+ ylim(-0.4,0.3) + splits + labs(y = NULL)
fig2F <- p[[8]] + ggtitle("Ethnicity: Asian")+ ylim(-0.4,0.3) + splits + labs(y = NULL)

#combine all together with cowplot
fig2_panels <- cowplot::plot_grid(fig2A, fig2B, fig2C, fig2E, fig2D, nrow = 1, ncol = 5)
fig2_panels


#All Gaps Overview ####

  
fig_allgaps <- 
  gaps_summary %>%
  mutate(demographic_var = factor(demographic_var, levels = c("female","firstgen","lowincomeflag","urm","transfer"))) %>%
  mutate(demographic_var = recode_factor(demographic_var, 
                                         female = "Women",
                                         firstgen = "FirstGeneration",
                                         lowincomeflag = "LowIncome",
                                         urm = "PEER",
                                         transfer = "Transfer")) %>%
  ggplot(aes(x = avg_gpa_diff, y = avg_grade_diff, color = institution, shape = crs_topic)) + 
  geom_point(size = 4, alpha = 0.6) + 
  geom_abline(intercept = 0, slope = 1, linetype = "dashed") + #1-1 line
  geom_errorbar(aes(xmin = avg_gpa_diff-sem_gpa_diff, xmax = avg_gpa_diff+sem_gpa_diff)) + 
  geom_errorbar(aes(ymin = avg_grade_diff-sem_grade_diff, ymax = avg_grade_diff+sem_grade_diff)) + 
  geom_hline(yintercept = 0) + 
  geom_vline(xintercept = 0) + 
  scale_color_manual(values = deid_colors, labels = c("A", "B", "C", "D")) + #de-identify institutions
  labs(x = "Prior GPA Difference\n(1-0)", 
       y = "Course Grade Difference\n(1-0)",
       color = "Institution",
       shape = "Course Subject") + 
  facet_grid(cols = vars(demographic_var), rows = vars(crs_topic)) + 
  theme_seismic + 
  theme(legend.position = "bottom")

fig_allgaps

#URM gaps ####
urmgap <-
  all_dem %>%
  select(institution, crs_topic,crs_name,crs_term, demographic_var,value,  mean_grade, mean_prior_gpa) %>%
  filter(demographic_var == "urm") %>%
  filter(crs_topic != "Physiology") %>%
  pivot_wider(names_from = value, values_from = c(mean_grade, mean_prior_gpa)) %>%
  #calculate differences
  mutate(grade_diff = mean_grade_1 - mean_grade_0,
         gpa_diff = mean_prior_gpa_1 - mean_prior_gpa_0) %>%
  mutate(mismatch = ifelse(sign(gpa_diff) == 1 & sign(grade_diff) == -1, 1,0), #higher GPA but lower grade mismatches
         gender_penalty = ifelse(sign(grade_diff) == 1, 1,0)) #general gender penalty (all bottom half of plot)

# figure
fig_urmgap <-
  urmgap %>%
  mutate(institution2 = recode_factor(institution, "IU"="A", "Purdue" = "B", "UCD"= "C","UM" = "D")) %>% #de-identify
  ggplot(aes(x = gpa_diff, y= grade_diff, color = institution2)) + 
  #geom_point(size = 3, alpha = 0.8) +
  geom_point(aes(alpha = mismatch), size = 3) + #toggle: alpha as aes to highlight mismatches
  geom_hline(yintercept = 0) + 
  geom_vline(xintercept = 0) + 
  labs(x = "Prior GPA Difference \n(PEER-nonPEER)", y = "Course Grade Difference \n(PEER-nonPEER)",
       color = "Institution") + 
  scale_color_manual(values = deid_colors, labels = c("A", "B", "C", "D")) + #de-identify institutions
  scale_alpha(range = c(0.15, 0.9)) +
  facet_grid(~crs_topic) +
  #facet_grid(rows = vars(crs_topic), cols = vars(institution2)) + #toggle: by institutions and topic 
  theme_seismic + 
  theme(legend.position = "none") 

#Demographics ####

#summarise data in one table 
dem_summary <- all_dem %>% group_by(crs_topic,institution, crs_name, demographic_var, value) %>% summarise(n_total = sum(n)) %>% 
  ungroup() %>% group_by(crs_name, demographic_var) %>% mutate(n_course = sum(n_total), #course total
                                                               perc = n_total/n_course *100) #percent for each level
#clean up data 
demo_plot <- 
  dem_summary %>%
  filter(value == "1" & crs_topic != "Physiology") %>%
  ggplot(aes(x = demographic_var, y = perc, fill = institution)) + 
  geom_col(position = position_dodge(0.9), color = "black") +
  geom_text(aes(label = round(perc,0)), position = position_dodge(0.9), hjust = -0.25) + 
  labs(x = NULL, y = "Percent of all students (%)", fill = "Institution") + 
  ylim(0,80) + 
  scale_x_discrete(labels = c("Low Income", "Women", "First Gen", "Transfer","URM")) + 
  scale_fill_manual(values = deid_colors, labels = c("A", "B", "C", "D")) + #de-identify institutions
  facet_wrap(~crs_topic) + 
  coord_flip() + 
  theme_seismic + 
  theme(axis.text = element_text(color = "black"), 
        strip.text = element_text(color = "black"))

# Transfer Gaps ####
transfgap <-
  all_dem %>%
  select(institution, crs_topic,crs_name,crs_term, demographic_var,value,  mean_grade, mean_prior_gpa) %>%
  filter(demographic_var == "transfer") %>%
  filter(crs_topic != "Physiology") %>%
  pivot_wider(names_from = value, values_from = c(mean_grade, mean_prior_gpa)) %>%
  #calculate differences
  mutate(grade_diff = mean_grade_1 - mean_grade_0,
         gpa_diff = mean_prior_gpa_1 - mean_prior_gpa_0) %>%
  mutate(mismatch = ifelse(sign(gpa_diff) == 1 & sign(grade_diff) == -1, 1,0), #higher GPA but lower grade mismatches
         gender_penalty = ifelse(sign(grade_diff) == 1, 1,0)) #general gender penalty (all bottom half of plot)

# figure
fig_transfgap <-
  transfgap %>%
  mutate(institution2 = recode_factor(institution, "IU"="A", "Purdue" = "B", "UCD"= "C","UM" = "D")) %>% #de-identify
  ggplot(aes(x = gpa_diff, y= grade_diff, color = institution2)) + 
  #geom_point(size = 3, alpha = 0.8) +
  geom_point(aes(alpha = mismatch), size = 3) + #toggle: alpha as aes to highlight mismatches
  geom_hline(yintercept = 0) + 
  geom_vline(xintercept = 0) + 
  labs(x = "Prior GPA Difference \n(Transfer-FirstYear)", y = "Course Grade Difference \n(Transfer-FirstYear)",
       color = "Institution") + 
  scale_color_manual(values = deid_colors, labels = c("A", "B", "C", "D")) + #de-identify institutions
  scale_alpha(range = c(0.15, 0.9)) +
  facet_grid(~crs_topic) +
  #facet_grid(rows = vars(crs_topic), cols = vars(institution2)) + #toggle: by institutions and topic 
  theme_seismic + 
  theme(legend.position = "none") 


transfgap %>%
  #calculate differences%>% #label term in mismatch (upperleft)
  group_by(crs_topic) %>%
  summarise(n_mismatch = sum(mismatch, na.rm = T), #no. terms in quadrant
            n_crsterm = n()) %>% #total no. terms
  mutate(perc = round(n_mismatch/n_crsterm, digits =3))

# SAI by Transfer ####

#load data
setwd("~/Google Drive/My Drive/WG1P6/Output files/")
um_sbt <- read.csv("UMichsai_plot_by_transfer_2022-09-19.csv") 
iu_sbt <- read.csv("IUBsai_plot_by_transfer_2022-09-08.csv") 
ucd_sbt <- read.csv("UCD_sai_plot_by_transfer_2022-09-27.csv") 
purdue_sbt <- read.csv("Purdue_sai_plot_by_transfer_2022-09-26.csv") 

