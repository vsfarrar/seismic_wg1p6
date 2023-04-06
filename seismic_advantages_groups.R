#Courses Overall: Data by "Advantages" Groups / Systemic Advantage Index 

#populate "advantage" variable
  #"URM" now defined as ethniccode_cat == 1 (all others considered non URM for the purposes of SAI)

dat_new <-
  dat_new %>% mutate(advantage = case_when(
    female == "0" & ethniccode_cat != "1" & firstgen == "0" & lowincomeflag == "0"  ~ "0",
    female == "1" & ethniccode_cat != "1" & firstgen == "0" & lowincomeflag == "0"  ~ "1A",
    female == "0" & ethniccode_cat == "1" & firstgen == "0" & lowincomeflag == "0"  ~ "1B", 
    female == "0" & ethniccode_cat != "1" & firstgen == "0" & lowincomeflag == "1"  ~ "1C", 
    female == "0" & ethniccode_cat != "1" & firstgen == "1" & lowincomeflag == "0"  ~ "1D", 
    female == "0" & ethniccode_cat == "1" & firstgen == "1" & lowincomeflag == "0"  ~ "2A", 
    female == "0" & ethniccode_cat == "1" & firstgen == "0" & lowincomeflag == "1"  ~ "2B", 
    female == "1" & ethniccode_cat == "1" & firstgen == "0" & lowincomeflag == "0"  ~ "2C", 
    female == "0" & ethniccode_cat != "1" & firstgen == "1" & lowincomeflag == "1"  ~ "2D", 
    female == "1" & ethniccode_cat != "1" & firstgen == "1" & lowincomeflag == "0"  ~ "2E", 
    female == "1" & ethniccode_cat != "1" & firstgen == "0" & lowincomeflag == "1"  ~ "2F", 
    female == "1" & ethniccode_cat != "1" & firstgen == "1" & lowincomeflag == "1"  ~ "3A", 
    female == "1" & ethniccode_cat == "1" & firstgen == "1" & lowincomeflag == "0"  ~ "3B",
    female == "1" & ethniccode_cat == "1" & firstgen == "0" & lowincomeflag == "1"  ~ "3C", 
    female == "0" & ethniccode_cat == "1" & firstgen == "1" & lowincomeflag == "1"  ~ "3D",
    female == "1" & ethniccode_cat == "1" & firstgen == "1" & lowincomeflag == "1"  ~ "4",
    TRUE ~ "NA")) %>%
  #extract "disadvantage" numbers and get the Systemic Advantage Index (SAI)
  mutate(disadv_no = str_extract(advantage, "[[:digit:]]+")) %>% 
  mutate(SAI = 4-as.numeric(disadv_no)) %>%
  #calculate grade and gpao difference for each student
  mutate(grade_gpao_diff = numgrade - gpao) 
  

#Advantage Groups across all offerings ####
advantages_by_offering <- 
  dat_new %>%
  group_by(university, crs_name, crs_offering, advantage) %>%
  summarise(n = n(), 
            mean_grade = mean(numgrade, na.rm = T), 
            se_grade = std.error(numgrade, na.rm = T),
            mean_gpao = mean(gpao, na.rm = T),
            se_gpao = std.error(gpao, na.rm = T),
            mean_grade_anomaly = mean(grade_gpao_diff, na.rm = T), 
            se_grade_anomaly = std.error(grade_gpao_diff, na.rm = T)) %>%
  mutate(group_label = recode(advantage,
                              "0" ="non-URM,non-LI,non-FG man",
                              "1A" = "+W",
                              "3D" = "+URM+FG+LI",
                              "4" = "+URM+FG+LI+W",
                              "1B" = "+URM",
                              "2C" ="+URM+W",
                              "1D" ="+FG",
                              "2E" = "+FG+W",
                              "1C" = "+LI",
                              "2F" = "+LI+W",
                              "2A"="+URM+FG",
                              "3B"="+URM+FG+W",
                              "2B"="+URM+LI",
                              "3C"= "+URM+LI+W",
                              "2D" = "+FG+LI",
                              "3A" = "+FG+LI+W"))

#advantages broken down by transfer
#Advantage Groups across all offerings ####
advantages_by_offering_by_transfer <- 
  dat_new %>%
  group_by(university, crs_name, crs_offering, advantage, transfer) %>%
  summarise(n = n(), 
            mean_grade = mean(numgrade, na.rm = T), 
            se_grade = std.error(numgrade, na.rm = T),
            mean_gpao = mean(gpao, na.rm = T),
            se_gpao = std.error(gpao, na.rm = T),
            mean_grade_anomaly = mean(grade_gpao_diff, na.rm = T), 
            se_grade_anomaly = std.error(grade_gpao_diff, na.rm = T)) %>%
  mutate(group_label = recode(advantage,
                              "0" ="non-URM,non-LI,non-FG man",
                              "1A" = "+W",
                              "3D" = "+URM+FG+LI",
                              "4" = "+URM+FG+LI+W",
                              "1B" = "+URM",
                              "2C" ="+URM+W",
                              "1D" ="+FG",
                              "2E" = "+FG+W",
                              "1C" = "+LI",
                              "2F" = "+LI+W",
                              "2A"="+URM+FG",
                              "3B"="+URM+FG+W",
                              "2B"="+URM+LI",
                              "3C"= "+URM+LI+W",
                              "2D" = "+FG+LI",
                              "3A" = "+FG+LI+W"))

#SAI groups across all offerings ####
sai_by_offering <- dat_new %>%
  group_by(university, crs_name, crs_offering, SAI) %>%
  summarise(n = n(), 
            mean_grade = mean(numgrade, na.rm = T), 
            se_grade = std.error(numgrade, na.rm = T),
            mean_gpao = mean(gpao, na.rm = T),
            se_gpao = std.error(gpao, na.rm = T),
            mean_grade_anomaly = mean(grade_gpao_diff, na.rm = T), 
            se_grade_anomaly = std.error(grade_gpao_diff, na.rm = T))

#SAI averages for plot ####
sai_avg_plot <-
dat_new %>%
  group_by(university, crs_name, SAI) %>%
  summarise(n = n(), 
            mean_grade = mean(numgrade, na.rm = T),
            se_grade = std.error(numgrade, na.rm = T),
            mean_gpao = mean(gpao, na.rm = T),
            se_grade = std.error(gpao, na.rm = T),
            mean_grade_anomaly = mean(grade_gpao_diff, na.rm = T), 
            se_grade_anomaly = std.error(grade_gpao_diff, na.rm = T))

#Advantage Groups by Gender ####
sai_avg_by_gender <-
  dat_new %>%
  group_by(university, crs_name, female, SAI) %>%
  summarise(n = n(), 
            mean_grade = mean(numgrade, na.rm = T),
            se_grade = std.error(numgrade, na.rm = T),
            mean_gpao = mean(gpao, na.rm = T),
            se_grade = std.error(gpao, na.rm = T),
            mean_grade_anomaly = mean(grade_gpao_diff, na.rm = T), 
            se_grade_anomaly = std.error(grade_gpao_diff, na.rm = T))

#Advantage Groups/SAI by Transfer Status ####
sai_avg_by_transfer <-
  dat_new %>%
  group_by(university, crs_name, transfer, SAI) %>%
  summarise(n = n(), 
            mean_grade = mean(numgrade, na.rm = T),
            se_grade = std.error(numgrade, na.rm = T),
            mean_gpao = mean(gpao, na.rm = T),
            se_grade = std.error(gpao, na.rm = T),
            mean_grade_anomaly = mean(grade_gpao_diff, na.rm = T), 
            se_grade_anomaly = std.error(grade_gpao_diff, na.rm = T)) 

#export data to csv
write.csv(advantages_by_offering, paste0(institution,"_advantages_by_offering_",current_date, ".csv"))
write.csv(advantages_by_offering_by_transfer, paste0(institution,"_advantages_by_offering_by_transfer_",current_date, ".csv"))
write.csv(sai_by_offering, paste0(institution,"_sai_by_offering_",current_date, ".csv"))
write.csv(sai_avg_plot, paste0(institution,"_sai_plot_",current_date, ".csv"))
write.csv(sai_avg_by_gender, paste0(institution,"_sai_plot_by_gender_",current_date, ".csv"))
write.csv(sai_avg_by_transfer, paste0(institution,"_sai_plot_by_transfer_",current_date, ".csv"))