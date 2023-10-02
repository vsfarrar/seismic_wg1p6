#Data Processing
  #currently using data that includes international students, coded conservatively
source(file = "~/Documents/GitHub/seismic_wg1p6/figure_code/seismic_figures_setup.R")

#Model Estimates #### 
setwd("~/Google Drive/My Drive/WG1P6/Output files/")

#import data
asu <- read.csv("ASU_all_robust_model_outputs_2023-04-24.csv") %>% mutate(university = "ASU")
iu <- read.csv("IUB_all_robust_model_outputs_2023-04-25.csv") %>% mutate(university = "IU")
um <- read.csv("UMich_all_robust_model_outputs_2023-04-12.csv") %>% mutate(university = "UM")
purdue <- read.csv("Purdue_all_robust_model_outputs_2023-04-26.csv") %>% mutate(university = "Purdue")
ucd <- read.csv("UCD_all_robust_model_outputs_2023-05-14.csv") %>% mutate(university = "UCD")

#stack together all model outputs
all_models <- rbind(asu, iu, um, purdue, ucd)

#clean up 
all_models <-  all_models %>%
  filter(effect == "fixed" & term!= "(Intercept)") %>% #remove Intercepts and Random effects for now 
  mutate(term = as.factor(term)) 
  
#clean up factor levels, misspellings
all_models$variable <- all_models$term

all_models$variable = recode_factor(all_models$variable, 
                                    "gpao" = "GPAO",
                                    "female1" = "Female",
                                    "firstgen1" = "FirstGen",
                                    "lowincomeflag1" = "LowIncome",
                                    "transfer1" = "Transfer",
                                    "peer1" = "PEER",
                                    "international1" = "International")
#note: this recode_factor list does not currently contain interaction terms
                                      
#set blank significance to NA
all_models <- replace_with_na(all_models, replace = list(s.sig = "")) #non-significant to NA
#create binary significance variable
all_models$significant <- ifelse(is.na(all_models$s.sig), 0,1) 

#create a "GPAO_included" variable
all_models$GPAO_included <- ifelse(all_models$model %in% c("main_fx_noGPAO_gen", "main_fx_noGPAO_cb"), 0, 1) 

#grab course subject from last 3 characters
#"_cb = CellBio", "gen" = "Genetics"
all_models$crs_subject <- ifelse(str_sub(all_models$model, start = -3, end = -1) == "_cb", "CellBio", "Genetics")

#denote interaction models by first 3 characters
all_models$interaction_mod <- ifelse(str_sub(all_models$model, start = 1, end = 3) == "int", 1, 0)

#__save data ####
write.csv(all_models, file = paste0("~/Google Drive/My Drive/WG1P6/Processed Data/all_model_estimates_", current_date,".csv"))

