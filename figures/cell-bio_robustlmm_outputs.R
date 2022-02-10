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

#begin with Cell Biology 
#UM:MCDB 428, IU: BIOL-L312 , UCD: BIS104
mcdb428 <- umich %>% filter(crs_name == "MCDB 428")
bioll312 <- iu %>% filter(crs_name == "BIOL-L312")

#stack data together
cell_bio <- rbind(mcdb428,bioll312,ucd_bis104) 

cell_bio <- replace_with_na(cell_bio, replace = list(s.sig = "")) %>% #non-significant to NA
  mutate(term = as.factor(term))

cell_bio_mainfx <- cell_bio %>% filter(effect == "fixed" & term != "(Intercept)") 

#clean up factor levels, misspellings
levels(cell_bio_mainfx$term) <- list(GPAO = "gpao",
                                     Female = c("female", "female1"),
                              FirstGen = c("firstgen", "firstgen1"),
                              LowIncome = c("lowincomeflag", "lowincomeflag1", "lowincomflag"),
                              Transfer = c("transfer", "transferICT", "transferTransfer"),
                              International = c("international"), 
                              EthnicityBIPOC = c("as.factor(ethnicode_cat)1", "as.factor(ethniccode_cat)1"),
                              EthnicityAsianAsianAmerican = c("as.factor(ethnicode_cat)2","as.factor(ethniccode_cat)2"),
                              EthnicityOther = c("as.factor(ethnicode_cat)3", "as.factor(ethniccode_cat)3"))
                                           
#Plot of Main Effects
cell_bio_mainfx %>% 
  filter(term != "GPAO") %>% #exclude GPAO (large estimate skews axis)
  mutate(significant = ifelse(is.na(s.sig), "not significant", "significant")) %>%
ggplot(aes(x = crs_name, y = estimate, color = institution)) + 
  geom_point(aes(shape = significant), size = 3) + 
  geom_errorbar(aes(ymin = estimate - std.error, ymax = estimate + std.error),
                width = 0.25) + 
  geom_hline(yintercept = 0) +
  scale_shape_manual(values = c(4,16)) + 
  labs(x = NULL, y = "Estimate ± SE", color = "Institution", shape = NULL, 
       title = "Upper-Division Cell Biology equity gaps across institutions", 
       subtitle = "Robust mixed model estimates, controlling for GPAO") + 
  facet_wrap(~term) + 
  theme_bw(base_size = 14) + 
  theme(axis.text.x = element_text(angle = 90, hjust = 1))
