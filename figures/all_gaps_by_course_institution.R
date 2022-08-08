#Figure : URM Gaps by Course-Institution
source("~/Documents/GitHub/seismic_wg1p6/figures/seismic_figures_setup.R")

#import data ####
#source data from demographics_by_institution.R
all_dem <- read.csv("~/Google Drive/My Drive/WG1P6/Output files/all_demographic_gaps_by_term_includePurdue2022-07-18_.csv")
all_dem$demographic_var <- recode_factor(all_dem$demographic_var, lowincomflag = "lowincomeflag")

#create gaps variables for all demographic variables 
all_gaps <-
all_dem %>%
  select(institution, crs_topic,crs_name,crs_term, demographic_var,value,  mean_grade, mean_prior_gpa) %>%
  filter(crs_topic != "Physiology") %>%
  pivot_wider(names_from = value, values_from = c(mean_grade, mean_prior_gpa)) %>%
  #calculate differences
  mutate(grade_diff = mean_grade_0 - mean_grade_1,
         gpa_diff = mean_prior_gpa_0 - mean_prior_gpa_1)

gaps_summary <- 
  all_gaps %>%
  group_by(institution, crs_topic, demographic_var) %>%
  summarise(avg_grade_diff = mean(grade_diff, na.rm = T), 
            sem_grade_diff = std.error(grade_diff, na.rm = T),
            avg_gpa_diff = mean(gpa_diff, na.rm = T),
            sem_gpa_diff = std.error(gpa_diff, na.rm = T))

#Figure

fig_allgaps <- 
gaps_summary %>%
  mutate(demographic_var = recode_factor(demographic_var, 
                                         lowincomeflag = "LowIncome",
                                         female = "Women",
                                         firstgen = "FirstGen",
                                         transfer = "Transfer",
                                         urm = "URM")) %>%
  ggplot(aes(x = avg_gpa_diff, y = avg_grade_diff, color = institution, shape = crs_topic)) + 
  geom_point(size = 3, alpha = 0.6) + 
  geom_errorbar(aes(xmin = avg_gpa_diff-sem_gpa_diff, xmax = avg_gpa_diff+sem_gpa_diff)) + 
  geom_errorbar(aes(ymin = avg_grade_diff-sem_grade_diff, ymax = avg_grade_diff+sem_grade_diff)) + 
  geom_hline(yintercept = 0) + 
  geom_vline(xintercept = 0) + 
  scale_color_manual(values = school_colors2) + 
  labs(x = "Prior GPA Difference\n(students not in group - students in group)", 
       y = "Course Grade Difference\n(students not in group - students in group)",
       color = "Institution",
       shape = "Course Subject") + 
  facet_wrap(~demographic_var) + 
  theme_seismic + 
  theme(legend.position = "bottom")

#export plot 
ggsave(filename = paste0("~/Google Drive/My Drive/WG1P6/Figures Tables/SEISMIC-WG1P6_MS_FigX_all_gaps_",current_date,".png"),
       fig_allgaps, width =7 , height =5, units = "in")
