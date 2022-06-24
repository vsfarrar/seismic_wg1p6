#SET UP for MS Figures 

#Packages ####
library(tidyverse)
library(sjPlot) #tables to word
library(naniar) #replace_with_na function
library(plotrix)#std.error

#Working Directory ####

#Plotting ####
theme_seismic <- 
  theme_classic(base_size = 14) + 
  theme(axis.text = element_text(color = "black"), 
        strip.text = element_text(color = "black"), 
        panel.border = element_rect(color = "black", fill = NA, size = 1), 
        strip.background = element_rect(color = "black", size = 1))

#school colors for plots
school_colors <- c("IU" = "#990000" , "UCD" = "#002855", "UM" = "#FFCB05") #for bars
school_colors2 <- c("IU" = "#990000" , "UCD" = "#002855", "UM" = "#A28204") #for points
#got official color codes from: teamcolorcodes.com :)

#Functions ####

#grab current date using Sys.Date()
current_date <- as.Date(Sys.Date(), format = "%m/%d/%Y")