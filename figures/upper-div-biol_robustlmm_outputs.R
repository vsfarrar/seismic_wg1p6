source(file = "~/Documents/GitHub/seismic_wg1p6/figures/seismic_figures_setup.R")

#Data downloaded from Google Drive > Shared with Me > WG1P6 > Output files

setwd("~/Google Drive/My Drive/WG1P6/Output files/")
#import data
umich <- read.csv("UMich_mixed_model_outputs_main_effects_robust_2022-06-15.csv") %>% select(-X) %>%
  mutate(institution = "UM")
iu <- read.csv("IUB__mixed_model_outputs_main_effects_robust_2022-03-01.csv") %>% select(-X) %>%
  mutate(institution = "IU")
ucd_bis104 <- read.csv("UCD_BIS104_robustlmm_results_2022-02-04.csv") %>% mutate(crs_name = "BIS104") %>% 
  select(crs_name, effect, term:s.sig) %>% mutate(institution = "UCD")
ucd_bis101 <- read.csv("UCD_BIS101_robustlmm_results_2022-02-04.csv") %>% mutate(crs_name = "BIS101") %>% 
  select(crs_name, effect, term:s.sig) %>% mutate(institution = "UCD")
purdue <- read.csv("Purdue_mixed_model_outputs_main_effects_robust_2022-07-11.csv") %>% select(-X) %>% mutate(institution = "Purdue")

#stack data together
bio <- rbind(iu,ucd_bis101, ucd_bis104, umich, purdue)

bio <- replace_with_na(bio, replace = list(s.sig = "")) %>% #non-significant to NA
  mutate(term = as.factor(term))

bio_mainfx <- bio %>% filter(effect == "fixed" & term != "(Intercept)") 

#clean up factor levels, misspellings
bio_mainfx$variable <- bio_mainfx$term
levels(bio_mainfx$variable) <- list(GPAO = "gpao",
                              Female = c("female", "female1"),
                              FirstGen = c("firstgen", "firstgen1"),
                              LowIncome = c("lowincomeflag", "lowincomeflag1", "lowincomflag"),
                              Transfer = c("transfer", "transferTransfer", "transfer1"),
                              International = c("international", "international1"), 
                              EthnicityBIPOC = c("as.factor(ethnicode_cat)1", "as.factor(ethniccode_cat)1"),
                              EthnicityAsianAsianAmerican = c("as.factor(ethnicode_cat)2","as.factor(ethniccode_cat)2"),
                              EthnicityOther = c("as.factor(ethnicode_cat)3", "as.factor(ethniccode_cat)3"))

#create course variable 
bio_mainfx$crs_topic <- as.factor(bio_mainfx$crs_name)
levels(bio_mainfx$crs_topic) <- list(CellBio = c("BIOL-L312","MCDB 428","BIS104","Biology III: Cell Structure And Function"), 
                                     Genetics = c("BIS101", "BIOLOGY 305", "BIOL-L311","Biology IV: Genetics And Molecular Biology"),
                                     Physiology = c("BIOL-P451"))

                                           
#MS Figure 2 ####
#Plot of Main Effects

fig2 <-
bio_mainfx %>% 
  filter(variable != "GPAO" & crs_topic != "Physiology") %>% #exclude GPAO (large estimate skews axis)
  filter(!is.na(variable)) %>% #exclude ICT from IU (I think these are freshmen?)
  mutate(significant = ifelse(is.na(s.sig), "not significant", "significant")) %>%
ggplot(aes(x = crs_topic, y = estimate, color = institution)) + 
  geom_point(aes(group = institution, shape = significant), size = 3,
             position = position_dodge(0.5)) + 
  geom_errorbar(aes(group = institution, ymin = estimate - std.error, ymax = estimate + std.error),
                width = 0.5,position = position_dodge(0.5)) + 
  geom_hline(yintercept = 0) +
  scale_shape_manual(values = c(1,16)) + 
  scale_color_manual(values = school_colors2) + 
  labs(x = NULL, y = "Model estimate ± SE", color = "Institution", shape = NULL, 
       #title = "Upper-Division Biology equity gaps across institutions", 
       #subtitle = "Robust mixed model estimates, controlling for GPAO"
       ) + 
  facet_wrap(~variable) + 
  theme_bw(base_size = 14) +
  theme(axis.text = element_text(color = "black"), 
        strip.text = element_text(color = "black"))

#split facets (starts on facet 2)
p<- splitFacet(fig2)
splits <-  theme(legend.position = "none", title = element_text(size = 10))
fig2A <- p[[2]] + ggtitle("Women") + ylim(-0.4,0.3) +  splits
fig2B <- p[[3]] + ggtitle("First Generation") + ylim(-0.4,0.3) + splits
fig2C <- p[[4]] + ggtitle("Low Income")+ ylim(-0.4,0.3) + splits
fig2D <- p[[5]] + ggtitle("Transfer")+ ylim(-0.4,0.3) + splits
fig2E <- p[[7]] + ggtitle("Ethnicity: BIPOC")+ ylim(-0.4,0.3) + splits
fig2F <- p[[8]] + ggtitle("Ethnicity: Asian")+ ylim(-0.4,0.3) + splits

#combine all together with cowplot
fig2_panels <- plot_grid(fig2A, fig2B, fig2C, fig2D, fig2E, fig2F, labels = "AUTO", nrow = 2)

fig2_legend <- get_legend(fig2)

fig2_final <- plot_grid(fig2_panels, fig2_legend, rel_widths = c(1,0.2), labels = NULL, ncol = 2)

ggsave(paste0("~/Google Drive/My Drive/WG1P6/Figures Tables/SEISMIC-WG1P6_MS_Fig2_model_mainfx_",current_date,".png"),
       fig2_final, width =7 , height =5, units = "in")