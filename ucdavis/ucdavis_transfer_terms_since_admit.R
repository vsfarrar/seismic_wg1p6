updiv %>%
  select(cohort, crs_term) %>%
  mutate(test = crs_term - cohort) %>%
  head()

max(updiv$crs_term, na.rm = T)

year <- rep(2006:2021, each = 5) 
quarter <- rep(c("01","03","05","07","10"), times = 16)

term_map <- 
data.frame(year,quarter) %>%
  mutate(term = as.numeric(as.character(paste0(year,quarter)))) %>%
  rowid_to_column() %>%
  select(-year, -quarter)

updiv <- 
updiv %>%
left_join(., term_map, by = c("cohort" = "term")) %>%
rename(qno_admit = rowid) %>%
left_join(., term_map, by = c("crs_term" = "term")) %>%
rename(qno_crsterm = rowid) %>%
mutate(terms_since_admit = qno_crsterm - qno_admit) %>%
  mutate(year_since_admit = case_when(
    between(terms_since_admit,0,3)  ~ "1",
    between(terms_since_admit,4,7)  ~ "2",
    between(terms_since_admit,8,11) ~ "3",
    TRUE ~ "4+"
  )) #this code doesn't work


updiv %>%
  group_by(transfer, crs_name) %>%
  summarise(mean(terms_since_admit, na.rm = T)) %>%
  filter(transfer == 1)

updiv %>%
  filter(transfer == 1) %>%
  filter(between(terms_since_admit,0,15)) %>%
  mutate(dept = str_sub(crs_name, 1,3)) %>%
  ggplot(aes(x = terms_since_admit, y = numgrade, color = dept)) + 
  geom_smooth(method = "lm")
