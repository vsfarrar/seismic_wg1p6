#SET UP for MS Figures 

#Packages ####
library(tidyverse)
library(scales) #for `percent` function
library(naniar) #`replace_with_na` function
library(plotrix)#`std.error`
library(grid) #textGrobs
library(gridExtra)
#library(sjPlot) #tables to word. #issue loading sjPlot currently 

#Working Directory ####

#Plotting ####
theme_seismic <- 
  theme_classic(base_size = 14) + 
  theme(axis.text = element_text(color = "black"), 
        strip.text = element_text(color = "black"), 
        panel.border = element_rect(color = "black", fill = NA, size = 1), 
        strip.background = element_rect(color = "black", size = 1))

#school colors for plots
school_colors <- c("IU" = "#990000" , "UCD" = "#002855", "UM" = "#FFCB05", "Purdue" = "#CEB888") #for bars
school_colors2 <- c("IU" = "#990000" , "UCD" = "#002855", "UM" = "#A28204", "Purdue" = "#373A36") #for points
#got official color codes from: teamcolorcodes.com :)

#deidentified colors: colorblind qualitative pallette (ColorBrewer)
deid_colors <- c("ASU" = '#66c2a5',
                 "IU" = '#fc8d62',
                 "Purdue" = '#8da0cb',
                 "UCD" = '#e78ac3',
                 "UM" = '#a6d854')
deid_labels <- c("ASU" = "A",
                 "IU" = "B",
                 "Purdue" = 'C',
                 "UCD" = 'D',
                 "UM" = 'E')
#Functions ####

#grab current date using Sys.Date()
current_date <- as.Date(Sys.Date(), format = "%m/%d/%Y")

#function that can split up a facet grid 
#https://stackoverflow.com/questions/30510898/split-facet-plot-into-list-of-plots

splitFacet <- function(x){
  facet_vars <- names(x$facet$params$facets)         # 1
  x$facet    <- ggplot2::ggplot()$facet              # 2
  datasets   <- split(x$data, x$data[facet_vars])    # 3
  new_plots  <- lapply(datasets,function(new_data) { # 4
    x$data <- new_data
    x})
}    