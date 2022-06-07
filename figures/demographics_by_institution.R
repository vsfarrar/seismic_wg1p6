library(tidyverse)
library(sjPlot)

setwd("~/Documents/projects/dber_seismic/data/")

#import data
umdem <- read.csv("UMich_demographic_gaps_by_term_2022-01-10.csv") %>% mutate(institution = "UM")
iudem <- read.csv("~/Google Drive/My Drive/WG1P6/Output files/IUB demographic_gaps_by_term_2021-12-13.csv") %>% mutate(institution = "IU")
#ucddem <- read.csv("UCD_demographic_gaps_by_term_2022-02-07.csv") %>% mutate(institution = "UCD") #not up-to-date

#UCD: combine BIS101 and BIS104
bis101 <- read.csv("~/Google Drive/My Drive/WG1P6/Output files/UCD_BIS101_demographic_gaps_by_term_2022-06-05.csv") %>% rename(institution = university)
bis104 <- read.csv("~/Google Drive/My Drive/WG1P6/Output files/UCD_BIS104_demographic_gaps_by_term_2022-06-05.csv") %>% rename(institution = university)
#stack UCD
ucddem <- rbind(bis101,bis104)

#stack dataframes
all_dem <- rbind(umdem, iudem, ucddem)

#create course topic variable
all_dem$crs_topic <- as.factor(all_dem$crs_name)
levels(all_dem$crs_topic) <- list(CellBio = c("BIOL-L312","MCDB 428","BIS104"),
                                  Genetics = c("BIS101", "BIOLOGY 305", "BIOL-L311"),
                                  Physiology = c("BIOL-P451"))

#MS TABLE 1 ####
#Course Sample Size

table1 <- 
  all_dem %>% 
  filter(demographic_var == "female") %>%
  group_by(crs_topic,institution, crs_name, crs_term) %>%
  mutate(n_crsterm = sum(n)) %>% #add up 0 and 1 values to get total number of students in course term
  ungroup() %>%
  group_by(crs_topic,institution, crs_name) %>%
  summarise(n_total = sum(n), #get total students per course
            n_offerings = length(unique(crs_term)), #total number of unique terms
            mean_n_crsterm = round(mean(n_crsterm),0), #average number of students per term, nearest integer
            sd_n_crsterm = round(sd(n_crsterm),0)) #sd, nearest integer

tab_df(table1)

#summarise data in one table 
dem_summary <- all_dem %>% group_by(crs_topic,institution, crs_name, demographic_var, value) %>% summarise(n_total = sum(n)) %>% 
  ungroup() %>% group_by(crs_name, demographic_var) %>% mutate(n_course = sum(n_total), #course total
                                                               perc = n_total/n_course *100) #percent for each level
#clean up data ####

#clean up a few variable levels

#issues in IU levels of Transfer and URM - discuss with Montse
dem_summary$value <- recode(dem_summary$value, 
                            Transfer = "1", URM = "1")
dem_summary$demographic_var <- recode_factor(dem_summary$demographic_var, lowincomflag = "lowincomeflag")

# Table 2 MS ####
table2 <-
dem_summary %>% 
  filter(value == "1" & crs_topic != "Physiology") %>% 
  ungroup() %>% 
  select(-n_total, -n_course, -crs_name) %>%
  #clean up variables
  pivot_wider(names_from = institution, values_from = perc)

tab_df(table2, digits = 1)

#plot demographics ####

school_colors <- c("IU" = "#990000" , "UCD" = "#002855", "UM" = "#FFCB05")
#got official color codes from: teamcolorcodes.com :)

demo_plot <- 
dem_summary %>%
  filter(value == "1" & crs_topic != "Physiology") %>%
ggplot(aes(x = demographic_var, y = perc, fill = institution)) + 
  geom_col(stat = "identity", position = position_dodge(0.9), color = "black") +
  geom_text(aes(label = round(perc,1)), position = position_dodge(0.9), hjust = -0.25) + 
  labs(x = NULL, y = "Percent of all students (%)", fill = "Institution", 
       title = "Demographic makeup of upper-division biology courses") + 
  ylim(0,80) + 
  scale_x_discrete(labels = c("Low Income", "Women", "First Gen", "Transfer","URM")) + 
  scale_fill_manual(values = school_colors) + 
  facet_wrap(~crs_topic) + 
  coord_flip() + 
  theme_classic(base_size = 14) + 
  theme(axis.text = element_text(color = "black"), 
        strip.text = element_text(color = "black"))

#export plot (currently to Google Drive, change to github?)
ggsave("~/Google Drive/My Drive/WG1P6/Figures Tables/SEISMIC-WG1P6_MS_Fig1_demographics.png",
       demo_plot, width =7 , height =5, units = "in")