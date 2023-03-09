#Supplemental Table 2. Sample Size by International Included 

#setup 
all_dem <- read.csv("~/Google Drive/My Drive/WG1P6/Processed Data/all_demographic_gaps2023-03-08.csv")

#source functions
source("~/Documents/GitHub/seismic_wg1p6/figure_code/seismic_figures_setup.R")

#summarise data in one table ####
  all_dem %>% 
  group_by(international_included, crs_topic,university,demographic_var, value) %>% 
  summarise(n_total = sum(n_group),
            n_course = mean(n_course)) %>% 
  filter(value == 1) %>%
  mutate(perc = n_total/n_course *100) %>%
  select(-n_course) |>
  #report rows of institutions, columns by course and international excluded
  pivot_wider(names_from = c(crs_topic, international_included),
              values_from = c(n_total, perc)) %>%   #reporting both n and % 
  tab_df()

#changes in n and % women only ####
all_dem %>% 
  group_by(international_included, crs_topic,university,demographic_var, value) %>% 
  summarise(n_total = sum(n_group),
            n_course = mean(n_course)) %>% 
  filter(demographic_var == "female" & value == 1) %>%
  mutate(perc = n_total/n_course *100) %>%
  select(-n_course) %>%
  #report rows of institutions, columns by course and international excluded
  pivot_wider(names_from = c(crs_topic, international_included),
              values_from = c(n_total, perc)) %>%   #reporting both n and % 
  tab_df()

#overall totals, international included vs excluded ####
all_dem %>% 
  group_by(international_included) %>% 
  filter(demographic_var == "female") %>%
  summarise(n_total = sum(n_group))