# Robust Multilevel Mixed Models #
# all models run robustly using robustlmm package

#NOTES:
#no longer using nesting and pipes to run models 
#rationale: 1) saves memory for large datasets to split up Genetics and Cell Bio, 
#2) allows us to do both tidy() (see all variables) and glance() (get model parameters) for all models

#split data by course ####
genetics <- filter(dat_new, crs_subject == "Genetics")
cellbio <- filter(dat_new, crs_subject == "CellBio")

#1. Main effects only ####
#run a mixed model with all main effects only, each offering as a random effect, for each course
#controlling for GPAO 
#race/ethnicity defined via the PEER variable (PEER: ethniccode_cat == 1)

main_fx_all_gen <- rlmerRcpp(numgrade ~ gpao + female + peer + firstgen + transfer + lowincomeflag + international +
                                (1|crs_offering), data = genetics, method = "DASvar")

main_fx_all_cb <- rlmerRcpp(numgrade ~ gpao + female + peer + firstgen + transfer + lowincomeflag + international +
                                (1|crs_offering), data = cellbio, method = "DASvar")

#2.Main fx, no GPAO ####
#robust mixed model with all main effects WITHOUT GPAO CONTROL

main_fx_noGPAO_gen <- rlmerRcpp(numgrade ~ female + peer + firstgen + transfer + lowincomeflag + international +
                                (1|crs_offering), data = genetics, method = "DASvar")

main_fx_noGPAO_cb <- rlmerRcpp(numgrade ~ female + peer + firstgen + transfer + lowincomeflag + international +
                               (1|crs_offering), data = cellbio, method = "DASvar")

#3.Grade Anomaly as dependent var ####
#robust mixed model with grade anomaly as dependent var instead of numgrade ~ GPAO 

#generate grade anomaly variable in both datasets
genetics$grade_anomaly <- genetics$numgrade - genetics$GPAO
cellbio$grade_anomaly <- cellbio$numgrade - cellbio$GPAO

#models
grade_anom_mod_gen <- rlmerRcpp(grade_anomaly ~ female + peer + firstgen + transfer + lowincomeflag + international +
                                  (1|crs_offering), data = genetics, method = "DASvar")

grade_anom_mod_cb <- rlmerRcpp(grade_anomaly ~ female + peer + firstgen + transfer + lowincomeflag + international +
                                 (1|crs_offering), data = cellbio, method = "DASvar")

# INTERACTIONS MODELS ####
#models with second-order interactions, revolving around GPAO

#4.All vars*GPAO ####
all_GPAO_int_gen <- rlmerRcpp(numgrade ~ female*gpao + peer*gpao + firstgen*gpao + transfer*gpao + lowincomeflag*gpao + international*gpao +
            (1|crs_offering), data = genetics, method = "DASvar")

all_GPAO_int_cb <- rlmerRcpp(numgrade ~ female*gpao + peer*gpao + firstgen*gpao + transfer*gpao + lowincomeflag*gpao + international*gpao +
                                (1|crs_offering), data = cellbio, method = "DASvar")


#5.Gender*GPAO only ####
gender_GPAO_int_gen <- rlmerRcpp(numgrade ~ female*gpao + peer + firstgen + transfer + lowincomeflag + international +
                                (1|crs_offering), data = genetics, method = "DASvar")

gender_GPAO_int_cb <- rlmerRcpp(numgrade ~ female*gpao + peer + firstgen + transfer + lowincomeflag + international +
                                  (1|crs_offering), data = cellbio, method = "DASvar")

#tidy model outputs
tidy(all_GPAO_int_gen)

#provides model overview (including AIC, BIC, loglik, R2)
#can also use bbmle tables for comparisons 
broom.mixed::glance(all_GPAO_int_gen)

#look into texreg package??
#https://stackoverflow.com/questions/52027811/formatted-latex-regression-tables-with-multiple-models-from-broom-output
#https://stackoverflow.com/questions/32074118/texreg-with-lmer-and-lme-objects-variances-differ


