# Nick: based on Ben's term_count function
# 
# TERMYR is then the number of years
# 0.5 means graduated same semester as enrolled
# 1 is a fall & winter enrollment (as is any whole number)
# x.5 is summer to winter

term_grad <- function(sr)
{
  #sc <- left_join(sc,sr)
  
  #sc <- sc %>% distinct(STDNT_ID,TERM_CD,.keep_all=TRUE)
  
  # round those M1, M2, M3, and M4 terms to the actual term
  # ie Fall2009M1 should be just Fall2009
  delta <- plyr::round_any(sr$UM_DGR_1_CMPLTN_TERM_CD,10)-plyr::round_any(sr$FIRST_TERM_ATTND_CD,10)
  sr$TERMYR <- mat.or.vec(length(delta),1)
  
  # testing line
  #compute the number of years you've been here since your entrance term.
  # this may not deal well with winter entrance.

  e0 <- which(delta %% 50 == 0) # enter & exit same term type (i.e., fall to fall)
  e1 <- which(delta %% 50 == 10) # ten jump is fall to winter
  e2 <- which(delta %% 50 == 20) # this is summer to winter
  e3 <- which(delta %% 50 == 30)
  e4 <- which(delta %% 50 == 40)
  eNA <- is.na(delta)
  
  # run these after so they don't get counted as e0
  #eM<- which(delta <0) # this means they have multiple degrees and one was before the record keeping started
  #eNA<- which(between(delta,-0.1,0.1)) # this means they never graduated; might be not exactly zero
  

  sr$TERMYR[e0] <- delta[e0]/50+.5
  sr$TERMYR[e1] <- (delta[e1]-10)/50+1
  #sr$TERMYR[e2] <- (delta[e2]-20)/50+0.6+1
  #sr$TERMYR[e3] <- (delta[e3]-30)/50+0.7+1
  #sr$TERMYR[e4] <- (delta[e4]-40)/50+0.8+1
  sr$TERMYR[e2] <- (delta[e2]-20)/50+.5+1
  sr$TERMYR[e3] <- (delta[e3]-30)/50+1
  sr$TERMYR[e4] <- (delta[e4]-40)/50+1
  sr$TERMYR[eNA] <- NA # no grads
  
  # sr$TERMYR[eM] <- plyr::round_any(sr$UM_DGR_2_CMPLTN_TERM_CD[eM],10)-plyr::round_any(sr$FIRST_TERM_ATTND_CD[eM],10)
  # sr$TERMYR[eNA] <- NA # no grads
  
  return(sr)
  
}