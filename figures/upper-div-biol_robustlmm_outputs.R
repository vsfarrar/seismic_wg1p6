library(tidyverse)
library(naniar)

#Data downloaded from Google Drive > Shared with Me > WG1P6 > Output files

setwd("~/Documents/projects/dber_seismic/data/seismic_robustlmm/")
#import data
umich <- read.csv("UMich_mixed_model_outputs_main_effects_robust_2022-01-10.csv") %>% select(-X) %>%
  mutate(institution = "UM")
iu <- read.csv("IUB mixed_model_outputs_main_effects_robust_2022-01-07.csv") %>% select(-X) %>%
  mutate(institution = "IU")
ucd_bis104 <- read.csv("UCD_BIS104_robustlmm_results_2022-02-04.csv") %>% mutate(crs_name = "BIS104") %>% 
  select(crs_name, effect, term:s.sig) %>% mutate(institution = "UCD")
ucd_bis101 <- read.csv("UCD_BIS101_robustlmm_results_2022-02-04.csv") %>% mutate(crs_name = "BIS101") %>% 
  select(crs_name, effect, term:s.sig) %>% mutate(institution = "UCD")

#stack data together
bio <- rbind(iu,ucd_bis101, ucd_bis104, umich)

bio <- replace_with_na(bio, replace = list(s.sig = "")) %>% #non-significant to NA
  mutate(term = as.factor(term))

bio_mainfx <- bio %>% filter(effect == "fixed" & term != "(Intercept)") 

#clean up factor levels, misspellings
levels(bio_mainfx$term) <- list(GPAO = "gpao",
                                     Female = c("female", "female1"),
                              FirstGen = c("firstgen", "firstgen1"),
                              LowIncome = c("lowincomeflag", "lowincomeflag1", "lowincomflag"),
                              Transfer = c("transfer", "transferICT", "transferTransfer"),
                              International = c("international"), 
                              EthnicityBIPOC = c("as.factor(ethnicode_cat)1", "as.factor(ethniccode_cat)1"),
                              EthnicityAsianAsianAmerican = c("as.factor(ethnicode_cat)2","as.factor(ethniccode_cat)2"),
                              EthnicityOther = c("as.factor(ethnicode_cat)3", "as.factor(ethniccode_cat)3"))

#create course variable 
bio_mainfx$crs_topic <- as.factor(bio_mainfx$crs_name)
levels(bio_mainfx$crs_topic) <- list(CellBio = c("BIOL-L312","MCDB 428","BIS104"), 
                                     Genetics = c("BIS101", "BIOLOGY 305", "BIOL-L311"),
                                     Physiology = c("BIOL-P451"))

                                           
#Plot of Main Effects
bio_mainfx %>% 
  filter(term != "GPAO" & crs_topic != "Physiology") %>% #exclude GPAO (large estimate skews axis)
  mutate(significant = ifelse(is.na(s.sig), "not significant", "significant")) %>%
ggplot(aes(x = crs_topic, y = estimate, color = institution)) + 
  geom_point(aes(group = institution, shape = significant), size = 3,
             position = position_dodge(0.5)) + 
  geom_errorbar(aes(group = institution, ymin = estimate - std.error, ymax = estimate + std.error),
                width = 0.5,position = position_dodge(0.5)) + 
  geom_hline(yintercept = 0) +
  scale_shape_manual(values = c(4,16)) + 
  labs(x = NULL, y = "Estimate ± SE", color = "Institution", shape = NULL, 
       title = "Upper-Division Biology equity gaps across institutions", 
       subtitle = "Robust mixed model estimates, controlling for GPAO") + 
  facet_wrap(~term) + 
  theme_bw(base_size = 14)
