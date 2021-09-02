# GRADE vs GPA GAPS 

setwd("/Users/vsfarrar/Documents/GitHub/seismic_wg1p6")
source("seismic_setup.R")

#functionized plots: gaps by course 
gaps_by_course <- function(df) {
  df %>% 
  ggplot(aes_string(x = "gpa_diff_01", y= "grade_diff_01", color = "crs_name")) + 
    geom_point(size = 2) + 
    geom_hline(yintercept = 0) + 
    geom_vline(xintercept = 0) + 
    facet_wrap(~ crs_name) +
    theme_classic(base_size = 14) + theme(legend.position = "none")
}


grade_gpa_diff %>%
  mutate(dept = str_sub(crs_name, 1,3)) %>%
  filter(dept == "BIS") %>%
  filter(demographic_var == "female") %>%
  gaps_by_course(.) +
  labs(x = "Prior GPA Difference (M-W)", y = "Course Grade Difference (M-W)")
