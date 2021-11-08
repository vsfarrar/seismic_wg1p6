library(ggplot2)
library(dplyr)

mydata<-read.csv("Results//demographic_gaps_by_term_2021-11-03.csv")

mydata$value<-as.factor(mydata$value)
mydata$crs_term<-factor(mydata$crs_term,levels = c('FA 2009', "WN 2010", 'FA 2010', "WN 2011", 'FA 2011', "WN 2012",'FA 2012', "WN 2013",'FA 2013', "WN 2014",
                                                  'FA 2014', "WN 2015",'FA 2015', "WN 2016",'FA 2016', "WN 2017",'FA 2017', "WN 2018",'FA 2018', "WN 2019"))

head(mydata)

ggplot(mydata %>% filter(demographic_var=='female',crs_name=='BIOLOGY 305'),aes(x=crs_term,y=mean_grade,color=value))+
    geom_point()+
    geom_errorbar(aes(ymin=mean_grade-sem_grade,ymax=mean_grade+sem_grade,width=0.5))+
    geom_point(aes(y=mean_prior_gpa,color=value),shape=15,position=position_nudge(-0.5),alpha=0.4)+
    geom_errorbar(aes(ymin=mean_prior_gpa-se_prior_gpa,ymax=mean_prior_gpa+se_prior_gpa,width=0.5),position=position_nudge(-0.5),alpha=0.4)+
    ylim(c(0,4))+
    ggtitle("BIO 305 Female")+
    coord_flip()

ggplot(mydata %>% filter(demographic_var=='firstgen',crs_name=='BIOLOGY 305'),aes(x=crs_term,y=mean_grade,color=value))+
    geom_point()+
    geom_errorbar(aes(ymin=mean_grade-sem_grade,ymax=mean_grade+sem_grade,width=0.5))+
    geom_point(aes(y=mean_prior_gpa,color=value),shape=15,position=position_nudge(-0.5),alpha=0.4)+
    geom_errorbar(aes(ymin=mean_prior_gpa-se_prior_gpa,ymax=mean_prior_gpa+se_prior_gpa,width=0.5),position=position_nudge(-0.5),alpha=0.4)+
    ylim(c(0,4))+
    ggtitle("BIO 305 First Gen")+
    coord_flip()

ggplot(mydata %>% filter(demographic_var=='lowincomflag',crs_name=='BIOLOGY 305'),aes(x=crs_term,y=mean_grade,color=value))+
    geom_point()+
    geom_errorbar(aes(ymin=mean_grade-sem_grade,ymax=mean_grade+sem_grade,width=0.5))+
    geom_point(aes(y=mean_prior_gpa,color=value),shape=15,position=position_nudge(-0.5),alpha=0.4)+
    geom_errorbar(aes(ymin=mean_prior_gpa-se_prior_gpa,ymax=mean_prior_gpa+se_prior_gpa,width=0.5),position=position_nudge(-0.5),alpha=0.4)+
    ylim(c(0,4))+
    ggtitle("BIO 305 Low Income")+
    coord_flip()

ggplot(mydata %>% filter(demographic_var=='transfer',crs_name=='BIOLOGY 305'),aes(x=crs_term,y=mean_grade,color=value))+
    geom_point()+
    geom_errorbar(aes(ymin=mean_grade-sem_grade,ymax=mean_grade+sem_grade,width=0.5))+
    geom_point(aes(y=mean_prior_gpa,color=value),shape=15,position=position_nudge(-0.5),alpha=0.4)+
    geom_errorbar(aes(ymin=mean_prior_gpa-se_prior_gpa,ymax=mean_prior_gpa+se_prior_gpa,width=0.5),position=position_nudge(-0.5),alpha=0.4)+
    ylim(c(0,4))+
    ggtitle("BIO 305 Transfer")+
    coord_flip()

ggplot(mydata %>% filter(demographic_var=='urm',crs_name=='BIOLOGY 305'),aes(x=crs_term,y=mean_grade,color=value))+
    geom_point()+
    geom_errorbar(aes(ymin=mean_grade-sem_grade,ymax=mean_grade+sem_grade,width=0.5))+
    geom_point(aes(y=mean_prior_gpa,color=value),shape=15,position=position_nudge(-0.5),alpha=0.4)+
    geom_errorbar(aes(ymin=mean_prior_gpa-se_prior_gpa,ymax=mean_prior_gpa+se_prior_gpa,width=0.5),position=position_nudge(-0.5),alpha=0.4)+
    ylim(c(0,4))+
    ggtitle("BIO 305 URM")+
    coord_flip()

ggplot(mydata %>% filter(demographic_var=='female',crs_name=='MCDB 428'),aes(x=crs_term,y=mean_grade,color=value))+
    geom_point()+
    geom_errorbar(aes(ymin=mean_grade-sem_grade,ymax=mean_grade+sem_grade,width=0.5))+
    geom_point(aes(y=mean_prior_gpa,color=value),shape=15,position=position_nudge(-0.5),alpha=0.4)+
    geom_errorbar(aes(ymin=mean_prior_gpa-se_prior_gpa,ymax=mean_prior_gpa+se_prior_gpa,width=0.5),position=position_nudge(-0.5),alpha=0.4)+
    ylim(c(0,4))+
    ggtitle("MCDB 428 Female")+
    coord_flip()

ggplot(mydata %>% filter(demographic_var=='firstgen',crs_name=='MCDB 428'),aes(x=crs_term,y=mean_grade,color=value))+
    geom_point()+
    geom_errorbar(aes(ymin=mean_grade-sem_grade,ymax=mean_grade+sem_grade,width=0.5))+
    geom_point(aes(y=mean_prior_gpa,color=value),shape=15,position=position_nudge(-0.5),alpha=0.4)+
    geom_errorbar(aes(ymin=mean_prior_gpa-se_prior_gpa,ymax=mean_prior_gpa+se_prior_gpa,width=0.5),position=position_nudge(-0.5),alpha=0.4)+
    ylim(c(0,4))+
    ggtitle("MCDB 428 First Gen")+
    coord_flip()

ggplot(mydata %>% filter(demographic_var=='lowincomflag',crs_name=='MCDB 428'),aes(x=crs_term,y=mean_grade,color=value))+
    geom_point()+
    geom_errorbar(aes(ymin=mean_grade-sem_grade,ymax=mean_grade+sem_grade,width=0.5))+
    geom_point(aes(y=mean_prior_gpa,color=value),shape=15,position=position_nudge(-0.5),alpha=0.4)+
    geom_errorbar(aes(ymin=mean_prior_gpa-se_prior_gpa,ymax=mean_prior_gpa+se_prior_gpa,width=0.5),position=position_nudge(-0.5),alpha=0.4)+
    ylim(c(0,4))+
    ggtitle("MCDB 428 Low Income")+
    coord_flip()

ggplot(mydata %>% filter(demographic_var=='transfer',crs_name=='MCDB 428'),aes(x=crs_term,y=mean_grade,color=value))+
    geom_point()+
    geom_errorbar(aes(ymin=mean_grade-sem_grade,ymax=mean_grade+sem_grade,width=0.5))+
    geom_point(aes(y=mean_prior_gpa,color=value),shape=15,position=position_nudge(-0.5),alpha=0.4)+
    geom_errorbar(aes(ymin=mean_prior_gpa-se_prior_gpa,ymax=mean_prior_gpa+se_prior_gpa,width=0.5),position=position_nudge(-0.5),alpha=0.4)+
    ylim(c(0,4))+
    ggtitle("MCDB 428 Transfer")+
    coord_flip()

ggplot(mydata %>% filter(demographic_var=='urm',crs_name=='MCDB 428'),aes(x=crs_term,y=mean_grade,color=value))+
    geom_point()+
    geom_errorbar(aes(ymin=mean_grade-sem_grade,ymax=mean_grade+sem_grade,width=0.5))+
    geom_point(aes(y=mean_prior_gpa,color=value),shape=15,position=position_nudge(-0.5),alpha=0.4)+
    geom_errorbar(aes(ymin=mean_prior_gpa-se_prior_gpa,ymax=mean_prior_gpa+se_prior_gpa,width=0.5),position=position_nudge(-0.5),alpha=0.4)+
    ylim(c(0,4))+
    ggtitle("MCDB 428 URM")+
    coord_flip()




