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

df_macellazioni %>%
  filter (FREQ == "A") %>%
  filter (REF_AREA == "IT") %>%
  filter (DATA_TYPE == "TOTLIVWEIG_KG") %>%
  #filter (obsTime %in% c(2002:2024)) %>%
  group_by(TYPE_OF_HERD) %>%
  summarize (Total = sum(obsValue, na.rm = TRUE))

