library(knitr)
library(tidyverse)
library(janitor)
library(lubridate) 
library(here) 
library(sf) 
library(tmap)
library(tidycensus)


neigh = st_read(here("data_raw","DC_Health_Planning_Neighborhoods.geojson")) |> clean_names()
df_c = read_csv(here("data_raw","DC_COVID-19_Total_Positive_Cases_by_Neighborhood.csv")) |> clean_names()


df_cases=df_c %>%
  filter(as_date(date_reported) == "2021-11-17") %>% 
  separate(neighborhood,into=c("code","name"),sep = ":") %>%
  mutate(code=case_when(code=="N35" ~"N0",
                        TRUE ~ code)) %>%
  select(-date_reported)


v20 = load_variables(2018,"acs5")
df_census=get_acs(geography = "tract",
                  variables=c("median_inc"="B06011_001",
                              "pop"="B01001_001",
                              "pop_black"="B02009_001"),
                  state="DC",geometry=TRUE,year=2021) 

df_cens=df_census %>% 
  select(-moe) %>% 
  pivot_wider(names_from = "variable", 
              values_from = "estimate")

tm_shape(df_cens) +tm_polygons("median_inc",alpha=.5)




