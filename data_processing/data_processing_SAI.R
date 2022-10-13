#Data Processing: SAI 
source(file = "~/Documents/GitHub/seismic_wg1p6/figure_code/seismic_figures_setup.R")

#load data ####
setwd("~/Google Drive/My Drive/WG1P6/Output files/")

#sai (raw)
asusai <- read.csv("ASUsai_plot_2022-09-27.csv")
iusai <- read.csv("IUBsai_plot_2022-09-08.csv")
purduesai <-read.csv("Purdue_sai_plot_2022-09-26.csv")
umsai <- read.csv("UMich_sai_plot_2022-09-19.csv")
ucdsai<- read.csv("UCD_sai_plot_2022-09-27.csv")

sai1 <- rbind(asusai, iusai, purduesai, umsai, ucdsai)
sai1$category <- "all"
sai1$female <- NA
sai1$transfer <-NA

#sai by gender
  #1=ASU, 2=IU, 3=Purdue, 4=UCD, 5=UM

sai1.2 <- read.csv("ASUsai_plot_by_gender_2022-09-27.csv")
sai2.2 <- read.csv("IUBsai_plot_by_gender_2022-09-08.csv")
sai3.2 <- read.csv("Purdue_sai_plot_by_gender_2022-09-26.csv")
sai5.2 <- read.csv("UMichsai_plot_by_gender_2022-09-19.csv")
sai4.2 <- read.csv("UCD_sai_plot_by_gender_2022-09-27.csv")

sai2 <- rbind(sai1.2, sai2.2, sai3.2, sai4.2, sai5.2)
sai2$category <- "gender"
sai2$transfer <- NA

#sai by transfer
#1=ASU, 2=IU, 3=Purdue, 4=UCD, 5=UM

sai1.3 <- read.csv("ASUsai_plot_by_transfer_2022-09-27.csv")
sai2.3 <- read.csv("IUBsai_plot_by_transfer_2022-09-08.csv")
sai3.3 <- read.csv("Purdue_sai_plot_by_transfer_2022-09-26.csv")
sai5.3 <- read.csv("UMichsai_plot_by_transfer_2022-09-19.csv")
sai4.3 <- read.csv("UCD_sai_plot_by_transfer_2022-09-27.csv")

sai3 <- rbind(sai1.3, sai2.3, sai3.3, sai4.3, sai5.3)
sai3$category <- "transfer"
sai3$female <- NA

#all SAI 
sai <- rbind(sai1, sai2, sai3)

#create course topic shared variable 
sai$crs_topic <- as.factor(sai$crs_name)
levels(sai$crs_topic) <- list(CellBio = c("BIOL-L312","MCDB 428","BIS104","Biology III: Cell Structure And Function", "BIO 353"), 
                                     Genetics = c("BIS101", "BIOLOGY 305", "BIOL-L311","Biology IV: Genetics And Molecular Biology", "BIO 340"),
                                     Physiology = c("BIOL-P451"))

#recode universities
sai$university = recode_factor(sai$university, 
                                  "IUB" = "IU", "UMich" = "UM")


#SAI by offering ####

sai1.4 <- read.csv("ASUsai_by_offering_2022-09-27.csv")
sai2.4 <- read.csv("IUBsai_by_offering_2022-09-08.csv")
sai3.4 <- read.csv("Purdue_sai_by_offering_2022-09-26.csv")
sai5.4 <- read.csv("UMich_sai_by_offering_2022-09-19.csv")
sai4.4 <- read.csv("UCD_sai_by_offering_2022-09-27.csv")

sai_offerings <- dplyr::bind_rows(sai1.4, sai2.4, sai3.4, sai4.4, sai5.4)


#create course topic shared variable 
sai_offerings$crs_topic <- as.factor(sai_offerings$crs_name)
levels(sai_offerings$crs_topic) <- list(CellBio = c("BIOL-L312","MCDB 428","BIS104","Biology III: Cell Structure And Function", "BIO 353"), 
                              Genetics = c("BIS101", "BIOLOGY 305", "BIOL-L311","Biology IV: Genetics And Molecular Biology", "BIO 340"),
                              Physiology = c("BIOL-P451"))

#recode universities
sai_offerings$university = recode_factor(sai_offerings$university, 
                               "IUB" = "IU", "UMich" = "UM")


#export processed data ####
write.csv(sai, file = paste0("~/Google Drive/My Drive/WG1P6/Processed Data/SAI_plot_data", current_date,".csv"))
write.csv(sai_offerings, file = paste0("~/Google Drive/My Drive/WG1P6/Processed Data/SAI_by_offering_", current_date,".csv"))
