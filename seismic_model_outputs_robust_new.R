# Robust Multilevel Mixed Models #
# all models run robustly using robustlmm package


#NOTES:
#no longer using nesting and pipes to run models 
#rationale: 1) saves memory for large datasets to split up Genetics and Cell Bio, 
#2) allows us to do both tidy() (see all variables) and glance() (get model parameters) for all models

#newest update to "robustlmm" package v.3.2-0 appears to fold memory-saving `rlmerRcpp`function into `rlmer`
#changed function call back to `rlmer`

#split data by course ####
genetics <- filter(dat_new, crs_subject == "Genetics")
cellbio <- filter(dat_new, crs_subject == "CellBio")

#1. Main effects only ####
#run a mixed model with all main effects only, each offering as a random effect, for each course
#controlling for GPAO 
#race/ethnicity defined via the PEER variable (PEER: ethniccode_cat == 1)

main_fx_all_gen <- rlmer(numgrade ~ gpao + female + peer + firstgen + transfer + lowincomeflag + international +
                                (1|crs_offering), data = genetics, method = "DASvar") 

main_fx_all_cb <- rlmer(numgrade ~ gpao + female + peer + firstgen + transfer + lowincomeflag + international +
                                (1|crs_offering), data = cellbio, method = "DASvar") 

#2.Main fx, no GPAO ####
#robust mixed model with all main effects WITHOUT GPAO CONTROL

main_fx_noGPAO_gen <- rlmer(numgrade ~ female + peer + firstgen + transfer + lowincomeflag + international +
                                (1|crs_offering), data = genetics, method = "DASvar") #m2gen

main_fx_noGPAO_cb <- rlmer(numgrade ~ female + peer + firstgen + transfer + lowincomeflag + international +
                               (1|crs_offering), data = cellbio, method = "DASvar") #m2cb

#3.Grade Anomaly as dependent var ####
#robust mixed model with grade anomaly as dependent var instead of numgrade ~ GPAO 

#generate grade anomaly variable in both datasets
genetics$grade_anomaly <- genetics$numgrade - genetics$gpao
cellbio$grade_anomaly <- cellbio$numgrade - cellbio$gpao

#models
main_fx_gradeanom_gen <- rlmer(grade_anomaly ~ female + peer + firstgen + transfer + lowincomeflag + international +
                                  (1|crs_offering), data = genetics, method = "DASvar") #m3gen

main_fx_gradeanom_cb <- rlmer(grade_anomaly ~ female + peer + firstgen + transfer + lowincomeflag + international +
                                 (1|crs_offering), data = cellbio, method = "DASvar") #m3cb

# INTERACTIONS MODELS ####
#models with second-order interactions, revolving around GPAO

#4.All vars*GPAO ####
int_allvarsXgpao_gen <- rlmer(numgrade ~ female*gpao + peer*gpao + firstgen*gpao + transfer*gpao + lowincomeflag*gpao + international*gpao +
            (1|crs_offering), data = genetics, method = "DASvar") #m4gen

int_allvarsXgpao_cb <- rlmer(numgrade ~ female*gpao + peer*gpao + firstgen*gpao + transfer*gpao + lowincomeflag*gpao + international*gpao +
                                (1|crs_offering), data = cellbio, method = "DASvar") #m4cb


#5.Gender*GPAO only ####
int_genderXgpao_gen <- rlmer(numgrade ~ female*gpao + peer + firstgen + transfer + lowincomeflag + international +
                                (1|crs_offering), data = genetics, method = "DASvar") #m5gen

int_genderXgpao_cb <- rlmer(numgrade ~ female*gpao + peer + firstgen + transfer + lowincomeflag + international +
                                  (1|crs_offering), data = cellbio, method = "DASvar") #m5cb


#use `straighten` function to organize all into one output file
  #function from "nutterb" on https://github.com/tidymodels/broom/issues/2
straighten <- function(..., fn = tidy){
  fits <- list(...)
  if (is.null(names(fits))) names(fits) <- character(length(fits))
  
  # If a fit isn't named, use the object name
  dots <- match.call(expand.dots = FALSE)$...
  obj_nms <- vapply(dots, deparse, character(1))
  names(fits)[names(fits) == ""] <- obj_nms[names(fits) == ""]
  
  purrr::map2(.x = fits,
              .y = names(fits),
              .f = function(x, n){
                data.frame(model = n, 
                           fn(x),
                           stringsAsFactors = FALSE)
              }) %>%
    dplyr::bind_rows()
}

#use function:
model_outputs <- straighten(main_fx_all_cb, main_fx_all_gen, 
           main_fx_noGPAO_gen, main_fx_noGPAO_cb,
           main_fx_gradeanom_gen, main_fx_gradeanom_cb, 
           int_genderXgpao_gen, int_genderXgpao_cb,
           int_allvarsXgpao_gen, int_allvarsXgpao_cb) 

#add significance
model_outputs <- model_outputs %>%
  mutate(s.sig = case_when(statistic > 1.96 | statistic < -1.96 ~ "***",
                           statistic <= 1.96 & statistic >= -1.96 ~ "",))

# export outputs ####
write.csv(model_outputs, paste0(institution,"_all_robust_model_outputs_",current_date,".csv"))
