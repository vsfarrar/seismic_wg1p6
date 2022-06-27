# Advantages Analysis
source("~/Documents/GitHub/seismic_wg1p6/figures/seismic_figures_setup.R")

#import and process data
iuadv <- read.csv("~/Google Drive/My Drive/WG1P6/Output files/IUB_summary_stats_by_advantages_2022-03-01.csv") %>% mutate(institution = "IU")
umadv <- read.csv("~/Google Drive/My Drive/WG1P6/Output files/UMich_summary_stats_by_advantages_2022-06-15.csv") %>% select(-university) %>% mutate(institution = "UM")
bis101adv <- read.csv("~/Google Drive/My Drive/WG1P6/Output files/UCD_BIS101_summary_stats_by_advantages_2022-06-05.csv") %>% select(-university) %>% mutate(institution = "UCD")
bis104adv <- read.csv("~/Google Drive/My Drive/WG1P6/Output files/UCD_BIS104_summary_stats_by_advantages_2022-06-05.csv") %>% select(-university) %>% mutate(institution = "UCD")

all_adv <- rbind(iuadv,umadv,bis101adv,bis104adv)

all_adv <-
all_adv %>%
  #extract disadvantage numbers and get the Systemic Advantage Index
  mutate(disadv_no = str_extract(advantage, "[[:digit:]]+")) %>%
  mutate(SAI = 4-as.numeric(disadv_no))

#create course topic variable
all_adv$crs_topic <- as.factor(all_adv$crs_name)
levels(all_adv$crs_topic) <- list(CellBio = c("BIOL-L312","MCDB 428","BIS104"),
                                  Genetics = c("BIS101", "BIOLOGY 305", "BIOL-L311"),
                                  Physiology = c("BIOL-P451"))

#plot
sai_plot <- 
all_adv %>%
  filter(crs_topic != "Physiology") %>%
  group_by(institution, crs_topic, SAI) %>%
  summarise(mean_grade_anomaly = mean(mean_diff_grade_gpao),
            n = sum(n)) %>%
ggplot(aes(x = SAI, y = mean_grade_anomaly, color = institution)) + 
  geom_point(aes(size = n)) + 
  facet_wrap(~crs_topic) +
  theme_bw(base_size = 14) + 
  scale_color_manual(values = school_colors2)

#ISSUE: If we want to recreate Sarah Castle's SAI graph, 
#we will need to rerun code rather than doing averages of averages. 