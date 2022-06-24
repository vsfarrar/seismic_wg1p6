#Figure : URM Gaps by Course-Institution
source("~/Documents/GitHub/seismic_wg1p6/figures/seismic_figures_setup.R")

#import data ####
#source data from demographics_by_institution.R
all_dem <- read.csv("~/Google Drive/My Drive/WG1P6/Output files/all_demographic_gaps_by_term_2022-06-09.csv")


#urm gaps 
#ISSUE: is this prior gpa or GPAO?
urmgap <-
all_dem %>%
  select(institution, crs_topic,crs_name,crs_term, demographic_var,value,  mean_grade, mean_prior_gpa) %>%
  filter(demographic_var == "urm") %>%
  filter(crs_topic != "Physiology") %>%
  pivot_wider(names_from = value, values_from = c(mean_grade, mean_prior_gpa)) %>%
  #calculate differences
  mutate(grade_diff = mean_grade_0 - mean_grade_1,
         gpa_diff = mean_prior_gpa_0 - mean_prior_gpa_1)

# Figure ####
fig_urmgap <-
urmgap %>%
  ggplot(aes(x = gpa_diff, y= grade_diff, color = institution)) + 
  geom_point(size = 3, alpha = 0.6) + 
  geom_hline(yintercept = 0) + 
  geom_vline(xintercept = 0) + 
  labs(x = "Prior GPA Difference (nonURM-URM)", y = "Course Grade Difference \n(nonURM-URM)",
       color = "Institution") + 
  scale_color_manual(values = school_colors2) +
  facet_grid(rows = vars(crs_topic), cols = vars(institution)) + 
  theme_seismic + 
  theme(legend.position = "bottom") 

#Annotations for Mismatch Quadrant ####
#get percent of terms in quadrant mismatch 
#ISSUE: if using facet_grid, will need to manually annotate in Powerpoint or other software.

  urmgap %>%
  #calculate differences
  mutate(urm_mismatch = ifelse(sign(gpa_diff) == -1 & sign(grade_diff) == 1, 1,0),
         urm_penalty = ifelse(sign(grade_diff) == 1, 1,0)) %>% #label term in mismatch (upperleft)
  group_by(institution, crs_topic) %>%
  summarise(n_pen = sum(urm_penalty),
            n_mismatch = sum(urm_mismatch), #no. terms in quadrant
            n_crsterm = n()) %>% #total no. terms
  mutate(perc_URMmismatch = round(n_mismatch/n_crsterm, digits =3)*100,
         perc_URMpenalty = round(n_pen/n_crsterm, digits =3)*100)


#export plot 
ggsave(filename = paste0("~/Google Drive/My Drive/WG1P6/Figures Tables/SEISMIC-WG1P6_MS_FigX_urm-gaps_",current_date,".png"),
       fig_urmgap, width =7 , height =5, units = "in")
