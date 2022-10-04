#Data Processing
  #currently using data that includes international students, coded conservatively
source(file = "~/Documents/GitHub/seismic_wg1p6/figure_code/seismic_figures_setup.R")

#Model Estimates #### 
setwd("~/Google Drive/My Drive/WG1P6/Output files/")

#import data
  #models with GPAO
umich <- read.csv("UMich_mixed_model_outputs_main_effects_robust_2022-09-19.csv") %>% select(-X) %>%
  mutate(university = "UM", model = "with_GPAO") 
iu <- read.csv("IUB_mixed_model_outputs_main_effects_robust_2022-09-08.csv") %>% select(-X) %>%
  mutate(university = "IU",model = "with_GPAO")
ucd_bis104 <- read.csv("UCD_BIS104_robust_outputs_interntl-conserv2022-09-27.csv") %>% mutate(crs_name = "BIS104") %>% 
  select(crs_name, effect, term:s.sig) %>% mutate(university = "UCD",model = "with_GPAO")
ucd_bis101 <- read.csv("UCD_BIS101_robust_outputs_interntl-conserv_2022-09-27.csv") %>% mutate(crs_name = "BIS101") %>% 
  select(crs_name, effect, term:s.sig) %>% mutate(university = "UCD",model = "with_GPAO")
purdue <- read.csv("Purdue_mixed_model_outputs_main_effects_robust_2022-09-26.csv") %>% select(-X) %>%  mutate(university = "Purdue",model = "with_GPAO")
asu <- read.csv("ASU_mixed_model_outputs_main_effects_robust_2022-09-27.csv") %>% select(-X) %>%  mutate(university = "ASU",model = "with_GPAO")

  #models without GPAO 
um2 <- read.csv("UMich_mixed_model_outputs_noGPAO_robust_2022-09-19.csv") %>% select(-X) %>%
  mutate(model = "noGPAO") 
iu2 <- read.csv("IUB_mixed_model_outputs_noGPAO_robust_2022-09-08.csv") %>% select(-X) %>%
  mutate(model = "noGPAO")
ucd_bis1042 <- read.csv("UCD_BIS104_robust_outputs_noGPAO_interntl-conserv2022-09-27.csv") %>% mutate(crs_name = "BIS104") %>% 
  select(crs_name, effect, term:s.sig) %>% mutate(university = "UCD", model = "noGPAO")
ucd_bis1012 <- read.csv("UCD_BIS101_robust_outputs_noGPAO_interntl-conserv2022-09-27.csv") %>% mutate(crs_name = "BIS101") %>% 
  select(crs_name, effect, term:s.sig) %>% mutate(university = "UCD", model = "noGPAO")
purdue2 <- read.csv("Purdue_mixed_model_outputs_noGPAO_robust_2022-09-26.csv") %>% select(-X) %>%  mutate(model = "noGPAO")
asu2 <- read.csv("ASU_mixed_model_outputs_noGPAO_robust_2022-09-27.csv") %>% select(-X) %>%  mutate(model = "noGPAO")

#stack data together
mod_intntl <- rbind(asu,iu,purdue, ucd_bis101, ucd_bis104, umich,
                    asu2,iu2, purdue2, ucd_bis1012, ucd_bis1042, um2)

mod_intntl$international_included <- 1

#international students excluded ####
#import data 
setwd("International students excluded/")
#models with GPAO
um3 <- read.csv("UMich_mixed_model_outputs_main_effects_robust_2022-09-19_no-international.csv") %>% select(-X) %>%
  mutate(university = "UM", model = "with_GPAO") 
iu3 <- read.csv("IUB_mixed_model_outputs_main_effects_robust_2022-09-08_no-international.csv") %>% select(-X) %>%
  mutate(university = "IU",model = "with_GPAO")
ucd_bis1043 <- read.csv("UCD_BIS104_robust_outputs_no-interntl2022-09-27.csv") %>% mutate(crs_name = "BIS104") %>% 
  select(crs_name, effect, term:s.sig) %>% mutate(university = "UCD",model = "with_GPAO")
ucd_bis1013 <- read.csv("UCD_BIS101_robust_outputs_no-interntl_2022-09-27.csv") %>% mutate(crs_name = "BIS101") %>% 
  select(crs_name, effect, term:s.sig) %>% mutate(university = "UCD",model = "with_GPAO")
purdue3 <- read.csv("Purdue_mixed_model_outputs_main_effects_robust_2022-09-26_no-international.csv") %>% select(-X) %>%  mutate(university = "Purdue",model = "with_GPAO")
asu3 <- read.csv("ASU_mixed_model_outputs_main_effects_robust_2022-09-27_no-international.csv") %>% select(-X) %>%  mutate(university = "ASU",model = "with_GPAO")

#models without GPAO 
um4 <- read.csv("UMich_mixed_model_outputs_noGPAO_robust_2022-09-19_no-international.csv") %>% select(-X) %>%
  mutate(model = "noGPAO") 
iu4 <- read.csv("IUB_mixed_model_outputs_noGPAO_robust_2022-09-08_no-international.csv") %>% select(-X) %>%
  mutate(model = "noGPAO")
ucd_bis1044 <- read.csv("UCD_BIS104_robust_outputs_noGPAO_no-interntl2022-09-27.csv") %>% mutate(crs_name = "BIS104") %>% 
  select(crs_name, effect, term:s.sig) %>% mutate(university = "UCD", model = "noGPAO")
ucd_bis1014 <- read.csv("UCD_BIS101_robust_outputs_noGPAO_no-interntl2022-09-27.csv") %>% mutate(crs_name = "BIS101") %>% 
  select(crs_name, effect, term:s.sig) %>% mutate(university = "UCD", model = "noGPAO")
purdue4 <- read.csv("Purdue_mixed_model_outputs_noGPAO_robust_2022-09-26_no-international.csv") %>% select(-X) %>%  mutate(model = "noGPAO")
asu4 <- read.csv("ASU_mixed_model_outputs_noGPAO_robust_2022-09-27_no-international.csv") %>% select(-X) %>%  mutate(model = "noGPAO")

#stack data together
mod_noInt <- rbind(asu3,iu3,purdue3, ucd_bis1013, ucd_bis1043, um3,
                    asu4,iu4, purdue4, ucd_bis1014, ucd_bis1044, um4)

mod_noInt$international_included <- 0 

#stack international and no international together into all_models
all_models <- rbind(mod_intntl, mod_noInt)


#clean up 
all_models <-  all_models %>%
  filter(effect == "fixed" & term!= "(Intercept)") %>% #remove Intercepts and Random effects for now 
  mutate(term = as.factor(term)) 
  
#clean up factor levels, misspellings
all_models$variable <- all_models$term
levels(all_models$variable) <- list(GPAO = "gpao",
                                    Female = c("female", "female1"),
                                    FirstGen = c("firstgen", "firstgen1"),
                                    LowIncome = c("lowincomeflag", "lowincomeflag1", "lowincomflag"),
                                    Transfer = c("transfer", "transferTransfer", "transfer1"),
                                    International = c("international", "international1"), 
                                    EthnicityBIPOC = c("as.factor(ethnicode_cat)1", "as.factor(ethniccode_cat)1"),
                                    EthnicityAsianAsianAmerican = c("as.factor(ethnicode_cat)2","as.factor(ethniccode_cat)2"),
                                    EthnicityOther = c("as.factor(ethnicode_cat)3", "as.factor(ethniccode_cat)3"))

#create a simple binary for GPAO included in model
all_models$GPAO_included <- ifelse(all_models$model == "noGPAO", 0, 1)

#create course topic shared variable 
all_models$crs_topic <- as.factor(all_models$crs_name)
levels(all_models$crs_topic) <- list(CellBio = c("BIOL-L312","MCDB 428","BIS104","Biology III: Cell Structure And Function", "BIO 353"), 
                                     Genetics = c("BIS101", "BIOLOGY 305", "BIOL-L311","Biology IV: Genetics And Molecular Biology", "BIO 340"),
                                     Physiology = c("BIOL-P451"))

#set blank significance to NA
all_models <- replace_with_na(all_models, replace = list(s.sig = "")) %>%  #non-significant to NA
  select(university, crs_topic, crs_name, variable, term, GPAO_included, international_included, estimate, std.error, 
         t.value=statistic, s.sig)

#recode universities 
all_models <- all_models %>%
  mutate(university = recode_factor(university, 
                "IUB" = "IU", "UMich" = "UM"))


#__save data ####
write.csv(all_models, file = paste0("~/Google Drive/My Drive/WG1P6/Processed Data/all_model_estimates_", current_date,".csv"))

