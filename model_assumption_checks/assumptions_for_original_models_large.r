###############################################
# Assessing assumptions 
# By: Montserrat Valdivia
# Date: Nov 29 2021
###############################################

#get path
path = getwd()

#use pacman to call libraries (installs them if not already installed)
pacman::p_load(xlsx, nlme) 

# call the following libraries
library(xlsx)
library(nlme)

model_1 = numgrade ~ gpao + female + as.factor(ethniccode_cat) + firstgen + transfer + lowincomflag + international + (1|crs_term)
model_2 = numgrade ~ gpao + female + urm + firstgen + transfer + lowincomflag + international + (1|crs_term)

# function to compute all assumptions
assumptions = function(clean_data = dat_new, model){
  
  #nest the cleaned data by course name
  nested_data = clean_data %>%
    nest(-crs_name) 
  # define the name of the course
  crs_nm = nested_data$crs_name
  #=============================================================================================
  # Extracting residuals and random effects from the model
  #=============================================================================================
  # Create a directory to save all the assumptions data
  if (model == model_1){
    sub_directory = paste0("/Assumptions_model1_", Sys.Date())
  } else if (model == model_2){
    sub_directory = paste0("/Assumptions_model2_", Sys.Date())
  } else {
    sub_directory = paste0("/Assumptions_model3_", Sys.Date())
  }
  
  
  # check if the directory exists, 
  if (file.exists(sub_directory)) {
    #if it exists set the working directory
    setwd(file.path(path, sub_directory))
  } else {
    #otherwise create the new file and set it as a working directory
    dir.create(file.path(path, sub_directory))
    setwd(file.path(path, sub_directory))
  }
  
  # level 1 residuals
  res <- map(nested_data$data, ~ residuals(lmer(model, data = .))) 
  # level 1 standardized residuals
  st.res <- map(res, function(x) x/sd(x, na.rm = TRUE))
  # level 2
  ran <- map(nested_data$data, ~ random.effects(lmer(model, data = .)) )
  # level 2 standardized residuals
  ## create an empty list for the random effects
  st.ran = vector(mode = "list", length = length(ran))
  for (i in 1:length(ran)){
    st.ran[[i]] <- ran[[i]][["crs_term"]][["(Intercept)"]]/sd(ran[[i]][["crs_term"]][["(Intercept)"]], na.rm = TRUE)
  }
  # fitted values
  fit_mod = map(nested_data$data, ~ fitted(lmer(model, data = .)))
  
  # save in the global environment 
  all_residuals <<- list(res_level1 = res, 
                         st.res_level1 = st.res, 
                         random_effects = ran, 
                         st.random_effects = st.ran)
  
  # save residuals in an RData file
  save(all_residuals, file = file.path(path, sub_directory,"/ResidualsL1&L2.RData"))
  # # Nick add to figure out the shapiro.test issues
  # save(st.res, file = file.path(path, sub_directory,"/st.res.RData"))
  
  #===========================================================================================
  # Normality assumption
  #===========================================================================================
  ## Level 1 residuals
  #===================
  # Plot residuals
  for (i in 1:length(st.res)){
    ggplot(as.data.frame(st.res[[i]]), aes(sample = st.res[[i]]))+stat_qq()+ stat_qq_line() +
      labs(y = "Level 1 Residuals", x = "Theoretical quantiles") 
    ggsave(filename = paste0(path, sub_directory, "/Level1_Residuals_", crs_nm[i],".png"))
  }
  
  
  ## Testing for level 1 residuals if p>.05 then the assumption is tenable
  # Nick edited
  names(st.res)<-crs_nm
  col_to_keep<-ifelse(sapply(st.res,length)>5000,FALSE,TRUE)
  shapiro_1 = sapply(st.res[col_to_keep], shapiro.test)
  

  
  ## Level 2 random effects
  #========================
  for (i in 1:length(st.ran)){
    ggplot(as.data.frame(st.ran[[i]]), aes(sample = st.ran[[i]]))+stat_qq()+ stat_qq_line() +
      labs(y = "Level 2 Residuals", x = "Theoretical quantiles") 
    ggsave(filename = paste0(path, sub_directory, "/Level2_Residuals_", crs_nm[i],".png"))
  }
  
  ## Testing for level 1 residuals if p>.05 then the assumption is tenable
  #Nick edit
  names(st.ran)<-crs_nm
  col_to_keep_2<-ifelse(sapply(st.ran,length)>5000,FALSE,TRUE)
  shapiro_2 = sapply(st.ran[col_to_keep_2], shapiro.test)
  
  #save results in an excel file
  write.xlsx(shapiro_1, file = paste0(path, sub_directory,"/Assumptions.xlsx"), sheetName = "Level 1 Residuals-Shapiro", row.names = TRUE)
  write.xlsx(shapiro_2, file = paste0(path, sub_directory,"/Assumptions.xlsx"), sheetName = "Level 2 Residuals-Shapiro", append = TRUE, row.names = TRUE)
  
  #===========================================================================================
  # Linearity and Homoscedasticity assumption
  #===========================================================================================
  # define the variables in the model
  if (model == model_1){
    mod_vars = c("crs_term","gpao", "female", "ethniccode_cat", "firstgen", "transfer", "lowincomflag", "international")
  } else if (model == model_2){
    mod_vars = c("crs_term","gpao", "female", "urm", "firstgen", "transfer", "lowincomflag", "international")
  } 
  ## Level 1 residuals
  #===================
  
  for (i in 1:length(st.res)){
    for (j in 1:length(mod_vars)){
      ggplot(as.data.frame(st.res[[i]]), aes(x = nested_data$data[[i]][[mod_vars[j]]],
                                             y = st.res[[i]]))+
        geom_point() +
        labs(y = "Level 1 Residuals", x = mod_vars[j]) 
      ggsave(filename = paste0(path, sub_directory, "/Level1_Residuals.",mod_vars[j],"_", crs_nm[i],".png"))
    }
  }
  
  for (i in 1:length(st.res)) {
    ggplot(as.data.frame(st.res[[i]]), aes(x = fit_mod[[i]],
                                           y = st.res[[i]]))+
      geom_point() +
      labs(y = "Level 1 Residuals", x = "Fitted values") 
    ggsave(filename = paste0(path, sub_directory, "/Level1_ResidualsvsFitted_", crs_nm[i],".png"))
  }
  
} # end of function

