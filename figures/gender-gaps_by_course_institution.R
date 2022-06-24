#Figure : URM Gaps by Course-Institution
source("~/Documents/GitHub/seismic_wg1p6/figures/seismic_figures_setup.R")

#import data ####
#source data from demographics_by_institution.R
all_dem <- read.csv("~/Google Drive/My Drive/WG1P6/Output files/all_demographic_gaps_by_term_2022-06-07.csv")


#gender gaps 
#ISSUE: is this prior gpa or GPAO?
gendergap <-
all_dem %>%
  select(institution, crs_topic,crs_name,crs_term, demographic_var,value,  mean_grade, mean_prior_gpa) %>%
  filter(demographic_var == "female") %>%
  filter(crs_topic != "Physiology") %>%
  pivot_wider(names_from = value, values_from = c(mean_grade, mean_prior_gpa)) %>%
  #calculate differences
  mutate(grade_diff = mean_grade_0 - mean_grade_1,
         gpa_diff = mean_prior_gpa_0 - mean_prior_gpa_1)

# Figure ####
fig_gendergap <-
gendergap %>%
  ggplot(aes(x = gpa_diff, y= grade_diff, color = institution)) + 
  geom_point(size = 3, alpha = 0.6) + 
  geom_hline(yintercept = 0) + 
  geom_vline(xintercept = 0) + 
  labs(x = "Prior GPA Difference (Men-Women)", y = "Course Grade Difference \n(Men-Women)",
       color = "Institution") + 
  scale_color_manual(values = school_colors2) +
  facet_grid(rows = vars(crs_topic), cols = vars(institution)) + 
  theme_seismic + 
  theme(legend.position = "bottom") 

#Annotations for Mismatch Quadrant ####
#get percent of terms in quadrant mismatch 
#ISSUE: if using facet_grid, will need to manually annotate in Powerpoint or other software.

  gendergap %>%
  #calculate differences
  mutate(upperleft = ifelse(sign(gpa_diff) == -1 & sign(grade_diff) == 1, 1,0),
         gender_penalty = ifelse(sign(grade_diff) == 1, 1,0)) %>% #label term in mismatch (upperleft)
  group_by(institution, crs_topic) %>%
  summarise(n_genderpen = sum(gender_penalty), #no. terms in quadrant
            n_crsterm = n()) %>% #total no. terms
  mutate(perc = round(n_genderpen/n_crsterm, digits =3))


#export plot 
ggsave(filename = paste0("~/Google Drive/My Drive/WG1P6/Figures Tables/SEISMIC-WG1P6_MS_FigX_gender-gaps_",current_date,".png"),
       fig_gendergap, width =7 , height =5, units = "in")
