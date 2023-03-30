
#Apply Filters
dat_new <- 
  dat %>%
#exclude students with no numeric grade (excludes dfw's)
  filter(!is.na(numgrade)) %>%
#exclude students who retook the course
  filter(crs_retake == 0) %>%
#exclude students who have no cum_prior_gpa or gpao
  filter(!is.na(cum_prior_gpa) & !is.na(gpao)) %>%
#exclude students whose gender is not "M" or "F", or is missing 
  filter(female != 2 & !is.na(female)) %>%
#exclude summer terms 
  filter(summer_crs == 0) %>%
#add university to dataframe
  mutate(university = institution,
#create an offering variable (concatenate term + section)
         crs_offering = paste(crs_year, crs_semq, crs_section, sep = "_"),
#create a "PEER" variable (manually) (ethniccode_cat == 1)
         peer = ifelse(ethniccode_cat == "1", "1", "0"))

#Create a summary report of students that were filtered out ####

filtered_out <- 
  #antijoin returns all entries filtered out 
anti_join(dat,dat_new) %>%
  #group by filter that removed them
  count(summer_course = (summer_crs == 1), 
        retaking_course = (crs_retake == 1), 
        missing_numgrade = is.na(numgrade), 
        missing_cum_prior_gpa = is.na(cum_prior_gpa), 
        missing_gpao = is.na(gpao),
        missing_or_nonbinary_gender = (female==2 | is.na(female)))

#confirm that all filtered out cases are listed in the filtered_out dataframe
ifelse(nrow(anti_join(dat,dat_new)) == sum(filtered_out$n),
       print("All filtered cases are accounted for"),
       print("ISSUE: Some filtered cases are not accounted for."))

#export the filtered out data report
write.csv(filtered_out, paste0(institution,"_n_excluded_by_filters",current_date,".csv"))

#####################
#Demographic Conversion ####

#create report of missing demographic information 
  #these missing variables will be coded as 0 conservatively, rather than being excluded

missing_demog <- 
dat_new %>%
 summarise(ethniccode_cat3 = sum(ethniccode_cat==3, na.rm = T),
           ethniccode_cat4 = sum(ethniccode_cat == 4, na.rm = T),
           international = sum(international == 1, na.rm = T),
   missing_ethniccode_cat = sum(is.na(ethniccode_cat)),
        missing_firstgen = sum(is.na(firstgen)),
        missing_international = sum(is.na(international)),
        missing_transfer = sum(is.na(transfer)),
        missing_lowincome = sum(is.na(lowincomeflag))) %>%
  t() %>% as.data.frame() %>% rownames_to_column()

colnames(missing_demog) <- c("","n") #edit column names 

#export the report
write.csv(missing_demog, paste0(institution,"_n_missing_demographics_",current_date,".csv"))

#Convert Demographics to 0 (conservative, instead of excluding)
dat_new <-
  dat_new %>%
  tidyr::replace_na(list(ethniccode_cat = "0", firstgen = "0", international = "0",
                         transfer = "0", lowincomeflag = "0", peer = "0"))

#International Student Processing ####

#1)International students coded conservatively 
#for all other demographic variables of interest EXCEPT gender and transfer
#e.g. ethniccode_cat becomes 0 (white) for all international students
dat_int <- 
  dat_new %>%
  mutate(across(c(ethniccode_cat, firstgen, lowincomeflag, peer), 
            ~ifelse(international == 1, 0, .)))

#2)International students excluded completely from analysis 
#removed from sample size (n excluded can be found in the missing_demog file)
dat_noInt <- 
  dat_new %>%
  filter(international != 1)

