library(tidyverse)

hp_2015 <- read.csv("data/2015.csv")
hp_2016 <- read.csv("data/2016.csv")

hp_2015 <- hp_2015 %>%
  mutate(year = 2015)

hp_2016 <- hp_2016 %>%
  mutate(Standard.Error = round(((Upper.Confidence.Interval-Lower.Confidence.Interval)/2)/1.96,
                                digits = 5)) %>%
  select(-Lower.Confidence.Interval) %>%
  select(-Upper.Confidence.Interval) %>%
  mutate(year = 2016)

hp_tot <- full_join(hp_2015, hp_2016) %>%
  arrange(Country)
hp_tot <- hp_tot[c(13,1,2,3,4,5,6,7,8,9,10,11,12)]

write.csv(hp_tot,"data/joined_data.csv") 
