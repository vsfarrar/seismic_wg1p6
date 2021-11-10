# Nick: initial run took around 20 minutes
wg1_p1_rename_umich_seismic <- function(sr,sc,st,COVID=FALSE)
{
   library(dplyr)
   library(stringr)
   library(tibble)
   #sc <- read_tsv("/Users/bkoester/Box Sync/LARC.WORKING/BPK_LARC_STUDENT_COURSE_20210209.tab")
   #sr <- read_tsv("/Users/bkoester/Box Sync/LARC.WORKING/BPK_LARC_STUDENT_RECORD_20210209.tab") 
   
   source('cleaning_functions.R')
  
   if (COVID == FALSE)
   {
      sc <- sc %>% filter(grepl("^U",PRMRY_CRER_CD) & !grepl("S",TERM_SHORT_DES) & 
                            !grepl("M",TERM_SHORT_DES) & TERM_CD >= 1210 & 
                            GRD_BASIS_ENRL_DES == 'Graded' & TERM_CD <= 2260) 
   }
   if (COVID == TRUE)
   {
      sc <- sc %>% filter(grepl("^U",PRMRY_CRER_CD) & !grepl("S",TERM_SHORT_DES) & 
                             !grepl("M",TERM_SHORT_DES) & TERM_CD >= 1210 & 
                             (GRD_BASIS_ENRL_DES == 'Graded' | grepl('COVID',GRD_BASIS_ENRL_DES,ignore.case=TRUE))) 
      
   }
      
   sr <- sr %>% filter(FIRST_TERM_ATTND_CD >= 1210)
  
   sc <- term_count(sr,sc)
   sc$SUM <- sc$TERMYR/2.0-0.5
   
   sr<-term_grad(sr) #Nick
   
   sr<-semester_grad(sr,st) #Nick
   
   sr <- sr %>% mutate(LI=0)
   sc <- sc %>% mutate(WD=0,RT=0,SEM=0,BLANK=NA,IS_DFW=0)
   sc$WD[which(sc$CRSE_GRD_OFFCL_CD == 'W')] <- 1
   sc$IS_DFW[which(sc$CRSE_GRD_OFFCL_CD == 'W' | sc$GRD_PNTS_PER_UNIT_NBR <= 1.3)] <- 1
   sc$SEM[grep('S',sc$TERM_SHORT_DES)] <- 1
   
   sr$LI[which(sr$MEDINC < 40000)] <- 1
   
   # Nick: get the graduation major(s) & graduation  date
   # Nick: graduation date is UC Davis format: YYYYMM where date is when degree is conferred
   sr<-sr %>% mutate(grad_major=if_else(is.na(UM_DGR_1_MAJOR_2_DES), 
                                        UM_DGR_1_MAJOR_1_DES,
                                        paste(UM_DGR_1_MAJOR_1_DES,UM_DGR_1_MAJOR_2_DES,sep = ";")),
                     grad_date=format(as.Date(UM_DGR_1_CNFR_DT), "%Y%m"))
   
   # Nick: use Ben's code to get grad GPA
   # Nick: needs st so loading and rewriting outcome to sr
   # Nick: only getting grad GPA of first degree
   sr<-merge(sr,st,by.y=c('STDNT_ID','TERM_CD'),by.x=c('STDNT_ID','UM_DGR_1_CMPLTN_TERM_CD'),all.x=TRUE)
   sr <- sr[,!names(sr) %in% c('TERM_CD','ENTRY_TYP_SHORT_DES','PRMRY_CRER_CD','CRER_LVL_CD')]

   
   # Nick: define a URM category
   sr$URM<-1
   
   # get total credits at beginning and end of term
   st<-st%>%  arrange(TERM_CD) %>% group_by(STDNT_ID) %>% mutate(EOT_CREDITS=cumsum(UNIT_TAKEN_GPA),BOT_CREDITS=EOT_CREDITS-UNIT_TAKEN_GPA)
   
   # get current major
   sc<-merge(sc,st,by.x=c("STDNT_ID","TERM_CD"),by.y=c("STDNT_ID","TERM_CD"),all.x=TRUE)
   sc<-sc %>% mutate(CURRENT_MAJOR=if_else(is.na(PGM_1_MAJOR_2_CIP_DES),PGM_1_MAJOR_1_CIP_DES,paste(PGM_1_MAJOR_1_CIP_DES,";",PGM_1_MAJOR_2_CIP_DES)))
   
   
   sr_names <- c("st_id"="STDNT_ID",
                "firstgen"="FIRST_GEN",
                "ethniccode"="STDNT_ETHNC_GRP_SHORT_DES",
                "ethniccode_cat"="STDNT_DMSTC_UNDREP_MNRTY_CD",
                "female"="STDNT_SEX_SHORT_DES",
                "famincome"="MEDINC",
                "lowincomflag"="LI",
                "transfer"="TRANSFER",
                "international"="STDNT_INTL_IND",
                "urm"="URM",
                "grad_gpa"="CUM_GPA", #Nick (Ben's code does the NA for non-grads)
                "grad_major"="grad_major", #Nick
                "grad_term"="UM_DGR_1_CMPLTN_TERM_DES", #Nick
                "grad_termcd"="UM_DGR_1_CMPLTN_TERM_CD", #Nick
                "attend_term"="FIRST_TERM_ATTND_SHORT_DES", #Nick
                "attend_termcd"="FIRST_TERM_ATTND_CD", #Nick
                "time_to_grad"="TIME_TO_GRAD", #Nick
                "us_hs"="HS_PSTL_CD",
                "cohort"="FIRST_TERM_ATTND_SHORT_DES",
                "englsr"="MAX_ACT_ENGL_SCR",
                "mathsr"="MAX_ACT_MATH_SCR",
                "hsgpa"="HS_GPA",

                "grad_date"="grad_date", #Nick added
                "time_to_grad_years"="TERMYR" #Nick added
)
   
   
      sc_names <- c("st_id"="STDNT_ID",
                    "crs_sbj"="SBJCT_CD",
                "crs_catalog"="CATLG_NBR",
                "crs_name"="CRSE_ID_CD",
                "numgrade"="GRD_PNTS_PER_UNIT_NBR",
                "numgrade_w"="WD",
                "is_dfw"="IS_DFW",
                "crs_retake"="RT",
                "crs_term"="TERM_SHORT_DES.x",# get doubles from merge so pick one
                "crs_termcd"="TERM_CD",
                "summer_crs"="SEM",
                "gpao"="EXCL_CLASS_CUM_GPA",
                "crs_component"="CRSE_CMPNT_CD",
                "current_major"="CURRENT_MAJOR", #Nick
                "begin_term_cum_gpa"="BOT_GPA", #cum_gpa
                "cum_prior_gpa"="BOT_GPA", #treating these two as the same
                "prior_units"="BOT_CREDITS", #Nick
                "crs_credits"="UNITS_ERND_NBR",
                "instructor_name"="BLANK",
                "class_number"="CLASS_NBR",
                "enrl_from_cohort"="SUM", # This is number of years
                "aptaker"="BLANK",
                "apskipper"="BLANK",
                "tookcourse"="BLANK",
                "apyear"="BLANK",
                "apscore"="BLANK") 
      
      sr <- sr  %>% select(sr_names)
      sc <- sc  %>% select(sc_names)
      
      
      sr$ethniccode_cat <- 1
      sr$ethniccode_cat[which(sr$ethniccode == 'White' | sr$ethniccode == 'Not Indic')] <- 0
      sr$ethniccode_cat[which(sr$ethniccode == 'Asian')] <- 2
      sr$ethniccode_cat[which(sr$ethniccode == '2 or More' | is.na(sr$ethniccode))] <- 3
      
      sr<-sr %>% mutate(urm=if_else(ethniccode_cat==1 | ethniccode_cat==3,1,0))
      
      e1 <- which(sr$female == 'Female')
      e0 <- which(sr$female == 'Male')
      
      sr$female <- NA 
      sr$female[e1] <- 1
      sr$female[e0] <- 0
      
      sc$crs_name <- str_c(sc$crs_sbj,sc$crs_catalog,sep=" ")
      sc <- flag_stem(sc)
      
      seismic_file<-merge(sc,sr,by="st_id",all.x=TRUE) # this is the file needed for the seismic work
      
    return(list(sr,sc,seismic_file))
  
}

flag_stem <- function(sc)
{
   #flag the stem courses
   clist <- c('AERO','AEROSP','ANAT','ANATOMY','ANESTH','AOSS','APPPHYS','ASTRO','AUTO',
              'BIOINF','BIOLCHEM','BIOLOGY','BIOMATLS','BIOMEDE','BIOPHYS','BIOSTAT',
              'BOTANY','CANCBIO','CEE','CHE','CHEM','CHEMBIO','CLIMATE','CMPLXSYS','CMPTRSC', #COGSCI
              'CS','EARTH','EEB','EECS','ENGR','ENSCEN','ENVIRON','ENVRNSTD','EPID','ESENG',
              'GEOSCI','HUMGEN','IOE',
              'MACROMOL','MATH','MATSCIE','MCDB','MECHENG','MEDCHEM','MEMS','MFG','MICROBIOL',
              'NAVARCH','MILSCI','NAVSCI','NERS','NEUROL','NEUROSCI',
              'PHARMACY','PHARMADM','PHARMCEU','PHARMCHM','PHARMCOG','PHARMSCI','PHYSICS','PHYSIOL',
              'PIBS','PUBHLTH', #PYSCH
              'RADIOL','SI','STATS','SPACE','ZOOLOGY')
   
   #clist <- c('MATH','PHYSICS','CHEM','BIOLOGY','STATS')
   
   ncrse        <- dim(sc)[1]
   is_stem  <- mat.or.vec(ncrse,1)
   e            <- sc$crs_sbj %in% clist
   is_stem[e]   <- 1
   data          <- as_tibble(data.frame(sc,is_stem))
   return(data)
}
   