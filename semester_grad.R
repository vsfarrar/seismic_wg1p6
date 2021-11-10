# Nick: this is a count of the number of terms a student has taken classes in
# This includes any summer and spring terms
# Use term_grad for simple difference in starting and ending points

semester_grad <- function(sr,st)
{
  sr_short<-sr_new %>% select(STDNT_ID,FIRST_TERM_ATTND_CD,UM_DGR_1_CMPLTN_TERM_CD)
  
  st<-left_join(st,sr_short)
  
  grad_time_df<-st %>% 
    filter(!is.na(UM_DGR_1_CMPLTN_TERM_CD)) %>% # only calculate for people who graduated
    mutate(is_first_dgr_course=if_else(TERM_CD<=UM_DGR_1_CMPLTN_TERM_CD & TERM_CD >=FIRST_TERM_ATTND_CD,1,0)) %>%
    group_by(STDNT_ID) %>%
    dplyr::summarize(TIME_TO_GRAD=sum(is_first_dgr_course)) # get the number of terms before first degree
  
  sr<-left_join(sr,grad_time_df)
  
  return(sr)
  
}