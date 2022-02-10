setwd("~/Documents/projects/dber_seismic/data/")

#import data
umdem <- read.csv("UMich_demographic_gaps_by_term_2022-01-10.csv") %>% mutate(institution = "UM")
iudem <- read.csv("IUB demographic_gaps_by_term_2021-12-13.csv") %>% mutate(institution = "IU")
ucddem <- read.csv("UCD_demographic_gaps_by_term_2022-02-07.csv") %>% mutate(institution = "UCD")

#stack dataframes
all_dem <- rbind(umdem, iudem, ucddem)

#summarise data in one table 
dem_summary <- all_dem %>% group_by(institution, crs_name, demographic_var, value) %>% summarise(n_total = sum(n)) %>% 
  ungroup() %>% group_by(crs_name, demographic_var) %>% mutate(n_course = sum(n_total), #course total
                                                               perc = n_total/n_course *100) #percent for each level

#clean up data ####

#clean up a few variable levels

#issues in IU levels of Transfer and URM - discuss with Montse
dem_summary$value <- recode(dem_summary$value, 
                            Transfer = "1", URM = "1", Other = "1")
dem_summary$demographic_var <- recode_factor(dem_summary$demographic_var, lowincomflag = "lowincomeflag")

#create course variable 
dem_summary$crs_topic <- as.factor(dem_summary$crs_name)
levels(dem_summary$crs_topic) <- list(CellBio = c("BIOL-L312","MCDB 428","BIS104"), 
                                     Genetics = c("BIS101", "BIOLOGY 305", "BIOL-L311"),
                                     Physiology = c("BIOL-P451"))

#plot demographics ####
demo_plot <- 
dem_summary %>%
  filter(value == "1" & crs_topic != "Physiology") %>%
ggplot(aes(x = demographic_var, y = perc, fill = institution)) + 
  geom_col(stat = "identity", position = position_dodge(0.9), color = "black") +
  geom_text(aes(label = round(perc,1)), position = position_dodge(0.9), hjust = -0.25) + 
  labs(x = NULL, y = "Percent of all students (%)", color = "Institution", 
       title = "Demographic makeup of upper-division biology courses") + 
  scale_x_discrete(labels = c("LowIncome", "Female", "FirstGen", "Transfer","URM")) + 
  facet_wrap(~crs_topic) + 
  coord_flip() + 
  theme_classic()