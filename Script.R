################################################################################
# R project to explore the Istat (Italian Institute of Statistics)
# Created by Alberto Frison in March 2025
################################################################################

# INSTALLATION OF PACKAGES #####################################################
install.packages("istat")
################################################################################


# LOAD OF LIBRARIES ############################################################
library (istat)
library (tidyverse)
################################################################################


# gathers all the available datasets
db_list <- list_istatdata()

#returns 3831 as of 2025.03.27
nrow(db_list$agencyId) 

subject <- "acqua"
search_istatdata (subject)



data_set <- "101_1033" # Macellazioni

# retreive the data for the data_set
db_macellazioni <-get_istatdata(agencyId = "IT1",
              dataset_id = data_set,
              version = "1.0",
              start = NULL,
              end = NULL,
              recent = FALSE,
              csv = FALSE,
              xlsx = FALSE)


# transfer data into a dataframe
df_macellazioni <- data.frame (db_macellazioni)

#df_macellazioni$obsTime <- as.factor(df_macellazioni$obsTime)
df_macellazioni$obsValue <- as.numeric(df_macellazioni$obsValue)
df_macellazioni$YEAR <- str_sub(df_macellazioni$obsTime, 1,4)
df_macellazioni$MONTH <- ifelse (df_macellazioni$FREQ == "M", as.character (str_sub(df_macellazioni$obsTime,6,8)), "")
   
df_macellazioni %>%
  filter (FREQ == "M") %>%
  filter (REF_AREA == "IT") %>%
  filter (DATA_TYPE == "TOTLIVWEIG_KG") %>%
  filter (TYPE_OF_HERD == "BREEDTURK") %>%
  filter (YEAR %in% as.character(c(2014:2024))) %>%
  #group_by(obsTime) %>%
  group_by(obsTime) %>%
  summarize (Total = sum(obsValue, na.rm = TRUE)) %>%
  ggplot (aes (x = obsTime, y = Total)) +
  geom_bar(stat = "identity") 


