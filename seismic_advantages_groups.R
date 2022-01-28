#Courses Overall: Data by "Advantages" Groups 

#Course Level Advantages across all terms 

advantages_by_course <- 
dat_new %>%
  mutate(advantage = case_when(
    female == "0" & urm == "0" & firstgen == "0" & lowincomeflag == "0"  ~ "0",
    female == "1" & urm == "0" & firstgen == "0" & lowincomeflag == "0"  ~ "1A",
    female == "0" & urm == "1" & firstgen == "0" & lowincomeflag == "0"  ~ "1B", 
    female == "0" & urm == "0" & firstgen == "0" & lowincomeflag == "1"  ~ "1C", 
    female == "0" & urm == "0" & firstgen == "1" & lowincomeflag == "0"  ~ "1D", 
    female == "0" & urm == "1" & firstgen == "1" & lowincomeflag == "0"  ~ "2A", 
    female == "0" & urm == "1" & firstgen == "0" & lowincomeflag == "1"  ~ "2B", 
    female == "1" & urm == "1" & firstgen == "0" & lowincomeflag == "0"  ~ "2C", 
    female == "0" & urm == "0" & firstgen == "1" & lowincomeflag == "1"  ~ "2D", 
    female == "1" & urm == "0" & firstgen == "1" & lowincomeflag == "0"  ~ "2E", 
    female == "1" & urm == "0" & firstgen == "0" & lowincomeflag == "1"  ~ "2F", 
    female == "1" & urm == "0" & firstgen == "1" & lowincomeflag == "1"  ~ "3A", 
    female == "1" & urm == "1" & firstgen == "1" & lowincomeflag == "0"  ~ "3B",
    female == "1" & urm == "1" & firstgen == "0" & lowincomeflag == "1"  ~ "3C", 
    female == "0" & urm == "1" & firstgen == "1" & lowincomeflag == "1"  ~ "3D",
    female == "1" & urm == "1" & firstgen == "1" & lowincomeflag == "1"  ~ "4",
    TRUE ~ "NA")) %>%
  mutate(grade_gpao_diff = numgrade - gpao) %>% 
  group_by(crs_name, advantage) %>%
  summarise(n = n(), 
            mean_grade = mean(numgrade, na.rm = T), 
            se_grade = std.error(numgrade, na.rm = T),
            mean_gpao = mean(gpao, na.rm = T),
            se_gpao = std.error(gpao, na.rm = T),
            mean_diff_grade_gpao = mean(grade_gpao_diff, na.rm = T), 
            se_diff_grade_gpao = std.error(grade_gpao_diff, na.rm = T)) %>%
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

#Department Level Averages across Entire Dataset 
  #ISSUE: uses UC Davis Course Catalog format to define school/department

# advantages_dept <- 
#   dat_new %>%
#   mutate(advantage = case_when(
#     female == "0" & urm == "0" & firstgen == "0" & lowincomeflag == "0"  ~ "0",
#     female == "1" & urm == "0" & firstgen == "0" & lowincomeflag == "0"  ~ "1A",
#     female == "0" & urm == "1" & firstgen == "0" & lowincomeflag == "0"  ~ "1B", 
#     female == "0" & urm == "0" & firstgen == "0" & lowincomeflag == "1"  ~ "1C", 
#     female == "0" & urm == "0" & firstgen == "1" & lowincomeflag == "0"  ~ "1D", 
#     female == "0" & urm == "1" & firstgen == "1" & lowincomeflag == "0"  ~ "2A", 
#     female == "0" & urm == "1" & firstgen == "0" & lowincomeflag == "1"  ~ "2B", 
#     female == "1" & urm == "1" & firstgen == "0" & lowincomeflag == "0"  ~ "2C", 
#     female == "0" & urm == "0" & firstgen == "1" & lowincomeflag == "1"  ~ "2D", 
#     female == "1" & urm == "0" & firstgen == "1" & lowincomeflag == "0"  ~ "2E", 
#     female == "1" & urm == "0" & firstgen == "0" & lowincomeflag == "1"  ~ "2F", 
#     female == "1" & urm == "0" & firstgen == "1" & lowincomeflag == "1"  ~ "3A", 
#     female == "1" & urm == "1" & firstgen == "1" & lowincomeflag == "0"  ~ "3B",
#     female == "1" & urm == "1" & firstgen == "0" & lowincomeflag == "1"  ~ "3C", 
#     female == "0" & urm == "1" & firstgen == "1" & lowincomeflag == "1"  ~ "3D",
#     female == "1" & urm == "1" & firstgen == "1" & lowincomeflag == "1"  ~ "4",
#     TRUE ~ "NA")) %>%
#   mutate(grade_gpa_diff = numgrade - cum_prior_gpa,
#          dept = str_sub(crs_name, 1,3),
#          disadv_no = str_extract(advantage, "[[:digit:]]+")) %>% 
#   group_by(dept, disadv_no) %>%
#   summarise(n = n(), 
#             mean_grade = mean(numgrade, na.rm = T), 
#             se_grade = std.error(numgrade, na.rm = T),
#             mean_gpa = mean(cum_prior_gpa, na.rm = T),
#             se_gpa = std.error(cum_prior_gpa, na.rm = T),
#             mean_diff_grade_gpa = mean(grade_gpa_diff, na.rm = T), 
#             se_diff_grade_gpa = std.error(grade_gpa_diff, na.rm = T)) %>%
#   mutate(group_label = recode(advantage, 
#                               "0" ="non-URM,non-LI,non-FG man",
#                               "1A" = "+W",
#                               "3D" = "+URM+FG+LI",
#                               "4" = "+URM+FG+LI+W",
#                               "1B" = "+URM",
#                               "2C" ="+URM+W",
#                               "1D" ="+FG", 
#                               "2E" = "+FG+W",
#                               "1C" = "+LI",
#                               "2F" = "+LI+W",
#                               "2A"="+URM+FG",
#                               "3B"="+URM+FG+W",
#                               "2B"="+URM+LI",
#                               "3C"= "+URM+LI+W",
#                               "2D" = "+FG+LI",
#                               "3A" = "+FG+LI+W"))

#export data to csv
write.csv(advantages_by_course, paste0(institution,"_summary_stats_by_advantages_",current_date, ".csv"))