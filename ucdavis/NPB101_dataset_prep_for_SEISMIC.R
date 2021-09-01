#ISSUES: Overall Prior GPA may be calculated incorrectly (do join after pivots)
#ISSUES: Class standing may not be accurate, need to calculate quarters since admitted, too. 

source("npb_new_dataset_processing_updatedGPA.R")

npb101 <-npb_new_gpajoin

npb101_seismic <-
npb101 %>%
  #Pivots create a row for the first time a class was taken and the last time it was taken
  mutate(across(c(NPB_101_FIRST_TERM, NPB_101_FIRST_GRADE,NPB_101_LAST_TERM, NPB_101_LAST_GRADE,
                  NPB_101_FIRST_SECTN, NPB_101_LAST_SECTN), as.character)) %>%
  pivot_longer(cols = c(NPB_101_FIRST_TERM, NPB_101_FIRST_GRADE,NPB_101_LAST_TERM, NPB_101_LAST_GRADE, NPB_101_FIRST_SECTN,NPB_101_LAST_SECTN),
               names_to = c("TIME_TAKEN","name"),
               names_pattern = "NPB_101_(.*)_(.*)",
               values_to = "value") %>%
  pivot_wider(names_from = "name", values_from = "value") %>%
  #populate values based on SEISMIC DataDescriptions
  mutate(crs_term = TERM, 
         numgrade = convert_grades(GRADE), #numeric grades
         crs_retake = ifelse(NPB_101_REPEATED == 1 & TIME_TAKEN == "LAST",1,0), #is the course a retake?
         class_number = SECTN) %>% #course component is section
  #REFORMAT VARS to match SEISMIC DataDescription 
  mutate(female = recode(GENDER, "M" = 0, "F" = 1, "N" = 2),
         #ethnicity codes match IPEDS listed in SEISMIC DataDescription
         ethnicode = recode(ETHN_CODE, 
                            "LA" = 1, "MX" = 1, "AI" = 2, "CH" = 3, "EI" = 3, "FP" = 3, "JA" = 3, "KO" = 3, 
                            "OA" = 3, "VT" = 3,  "AF" = 4, "PI" = 5, "WH" = 6),
         #race/ethnicity codes match SEISMIC definitions (1 = URM)
         ethnicode_cat = recode(ethnicode, 
                                "1" = 1, "2" = 1,"3" = 2, "4" = 1, "5" = 1, "6" = 0),
         transfer = recode(ADMIT_LEVEL, "H" = 0, "A" = 1),
         crs_name = "NPB101",
         is_stem = 1,
         crs_component = "Lecture") %>%
  #rename variables remaining
  rename(st_id = PIDM,
         firstgen = FIRST_GENERATION,
         lowincomeflag = LOW_INCOME,
         international = STARTED_INTERNATIONAL,
         cohort = ADMIT_TERM,
         lettergrade = GRADE, 
         current_major = NPB_101_PRIOR_MAJOR,
         incoming_gpa = ADMIT_GPA,
         cum_prior_gpa = OVERALL_GPA_PRIOR_TO_NPB101, #may be calculated incorrectly, may need to do join after pivots.
         class_standing = NPB_101_PRIOR_CLASS_LEVEL) %>% #may be calculated incorrectly 
select(st_id,female, firstgen, ETHN_DESC,ethnicode, ethnicode_cat,lowincomeflag, transfer, international, cohort,
       crs_name, crs_term, is_stem, lettergrade,numgrade,crs_retake,crs_component,class_number,current_major, cum_prior_gpa,
       incoming_gpa, class_standing)

         

