#load data
dat <- read.csv("~/Documents/projects/dber_seismic/UCD_CBS_upper_division_2021-07.csv", na.strings=c("","NA"))

#load packages
library(tidyverse)

#grab current date using Sys.Date()
current_date <- as.Date(Sys.Date(), format = "%m/%d/%Y")

# FORMAT DATA TO SEISMIC ####

dat_seismic <- 
dat %>%
  #looks like the repeated column is not accurate in this dataset - recreated manually: 
  #count the number of times a student took the same course
  add_count(CEEID,subjcrs, name = "times_crs_taken") %>%
  group_by(CEEID,subjcrs) %>%
  #add an id for the row of times taken (default sorted by term)
  #populates the time_taken variable that is null in this dataset 
  mutate(time_taken = row_number()) %>%
  #rename the "times_crs_taken" to crs_retake, code as binary (0=not retake, 1 = retake)
  mutate(crs_retake = ifelse(times_crs_taken >= 2 & time_taken != 1, 1, 0)) %>%
  #create withdrawl and dfw variables 
  #uses UC Davis registrar definitions (see Ref.)
  mutate(dfw = case_when(
    grade %in% c("RD", "XR", "WPD") ~ "d",
    str_starts(grade, "W0") ~ "d",
    grade %in% c("WX","DS","RW","WH","WI","WN","WP", "WP0","WP1","WP2","WP3","WP4","WP5","WP6","WP7","WP8","WP9",
                 "W10", "WA", "WC", "WD0", "WD1", "WD2", "WD3", "WD4", "WD5", "WD6", "WD7", "WD8", "WD9", "WD10", "WPC", "WE") ~ "w",
    str_starts(grade, "F") ~ "f",
    grade %in% c("NP*","U","NS","D-","D-^") ~ "f",
    TRUE ~ "NA"
  )) %>%
  mutate(is_dfw = ifelse(dfw == "NA", 0,1),
         numgrade_w = ifelse(dfw == "w",1,0)) %>% 
  #is the course a summer course?
  mutate(summer_crs = ifelse(str_sub(term,start =5, end =6) %in% c("05","06", "07"), 1,0)) %>%
  #all courses are STEM courses 
  mutate(is_stem = 1) %>%
  #recode ethnicity (IPEDS Race/Ethnicity categories)
  mutate(ethnicode = recode(ethn_desc, 
                   "African-American/Black" = 4,
                   "American Indian/Alaska Native" = 2,
                   "Chinese-American/Chinese" = 3, 
                   "Decline to State" = 99,
                   "East Indian/Pakistani" = 3,
                   "Filipino/Filipino-American"  = 3, 
                   "Japanese American/Japanese" = 3, 
                   "Korean-American/Korean"=3,
                   "Latino/Other Spanish"=1,
                   "Mexican-Am/Mexican/Chicano"=1,
                   "No Record"=99,
                   "Other"=0,
                   "Other Asian"=3,                 
                   "Pacific Islander. other"=5, 
                   "Unknown"= 99,                      
                   "Vietnamese"=3,                    
                   "White/Caucasian"=6)) %>%
        mutate(ethnicode = na_if(ethnicode, 99)) %>% #recode missing vars to NA
  #recode categorical ethnicode variables (SEISMIC Data Description definitions)
  mutate(ethnicode_cat = recode(ethnicode, 
                                "0"=3,
                                "1"=1,
                                "2"=1,
                                "3"=2,
                                "4"=1,
                                "5"=1,
                                "6"=0)) %>% 
  #create a "traditional" URM variable (Asian and White considered non-URM)
  mutate(urm = ifelse(ethnicode_cat == 1, 1,0)) %>%
  #recode gender and transfer to numeric
  mutate(female = recode(gender, "M" = 0, "F" = 1, "N" = 2),
         transfer = recode(admit_level, "Transfer" = 1, "Freshman" = 0)) %>% 
  mutate(grad_major = ifelse(is.na(major_2_bfr_first_degree), major_1_bfr_first_degree, 
                             paste(major_1_bfr_first_degree, major_2_bfr_first_degree, sep = "/"))) %>%
rename(st_id = CEEID,
       firstgen = first_generation,
       lowincomeflag = low_income,
       international = started_international,
       cohort = admit_term, 
       crs_name = subjcrs, 
       crs_term = term, 
       gpao = gpao, 
       crs_credits = units, 
       prior_units = priortermunits,
       cum_prior_gpa = priortermgpa,
       grad_gpa = gpa_bfr_first_degree,
       grad_term = first_degree_term,
       time_to_grad = num_terms_bfr_degree,
       lettergrade = grade,
       begin_term_cum_gpa = unweighted_gpa,
       numgrade = grade_pt)
       
# create bare minimum SEISMIC dataset
  #selects minimum variables needed for model running and demographics
dat_seismic_minimum <- 
  dat_seismic %>%
  select(#student variables 
    st_id, female, firstgen, ethnicode, ethnicode_cat, urm, lowincomeflag,transfer,international,cohort,
    begin_term_cum_gpa, grad_gpa, grad_major, grad_term, time_to_grad, 
    #course variables
    crs_name, is_stem, crs_term,crs_retake, lettergrade, numgrade, is_dfw,gpao, cum_prior_gpa, prior_units)
         
#save dataset 
write.csv(dat_seismic_minimum, file =paste0("~/Documents/projects/dber_seismic/UCD_CBS_upper_division_SEISMIC-format_", current_date,".csv"))

# REFERENCES ####
#UC Davis Grade Notation 
#https://registrar.ucdavis.edu/records/grades/notations

#SEISMIC Data Definitions
#https://docs.google.com/spreadsheets/d/1SzU4PcIEUsAGnKKyAcugHO2O2aZW29sf9a_cC-FAElk/edit#gid=1679989021

       