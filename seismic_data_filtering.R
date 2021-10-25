
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
  filter(summer_crs == 0)

#Create a summary report of students that were filtered out ####

filtered_out <- 
  #antijoin returns all entries filtered out 
anti_join(dat,dat_new) %>%
  #group by filter that removed them
  count(retaking_course = crs_retake == 1, 
        missing_numgrade = is.na(numgrade), 
        missing_cum_prior_gpa = is.na(cum_prior_gpa), 
        missing_gpao = is.na(gpao),
        missing_or_nonbinary_gender = (female==2 | is.na(female)))

#export the filtered out data report
write.csv(filtered_out, paste0("n_excluded_by_filters",current_date,".csv"))

#####################
#Demographic Conversion ####

#create report of missing demographic information 
  #these missing variables will be coded as 0 conservatively, rather than being excluded

missing_demog <- 
dat_new %>%
 summarise(other_ethnicode_cat = sum(ethnicode_cat==3, na.rm = T),
   missing_ethnicode_cat = sum(is.na(ethnicode_cat)),
        missing_firstgen = sum(is.na(firstgen)),
        missing_international = sum(is.na(international)),
        missing_transfer = sum(is.na(transfer)),
        missing_lowincome = sum(is.na(lowincomeflag))) %>%
  t() %>% as.data.frame() %>% rownames_to_column()

colnames(missing_demog) <- c("","n") #edit column names 

#export the report
write.csv(missing_demog, paste0("n_missing_demographics_",current_date,".csv"))

#Convert Demographics to 0 (conservative, instead of excluding)
dat_new <- 
dat_new %>% 
tidyr::replace_na(list(ethnicode_cat = 0, firstgen = 0, international = 0,
                       transfer = 0, lowincomeflag = 0, urm = 0))
