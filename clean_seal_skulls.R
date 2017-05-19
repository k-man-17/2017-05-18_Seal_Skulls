

library(tidyverse)
library(RCurl)

seal_skulls_raw <-
  read_csv("2017-05-15_Seal_Skull_raw.csv")

names(seal_skulls_raw)
str(seal_skulls_raw)


# 1. create a clean version of the seal skulls data with 
# just the relevant information for the analysis
seal_skulls_clean <-
  seal_skulls_raw %>%
  rename("CBL" = Condylobasal_Length_mm,
         "ZW" = Zygomatic_Width_mm,
         "PL" = Palatal_Length_mm,
         "NT" = Nasal_Turbinates) %>%
  mutate("Age" = Age_Years*12 + Age_Months) %>%
  select(Registration_Number,
         Age,
         Sex,
         Locality,
         CBL,
         ZW,
         PL,
         Comments)

write.csv(seal_skulls,
          file = "seal_skulls_clean.csv")

# 2. create a metadata table
# who, what, where, when, how?
# This uses a function in the file eml_utils.R
# https://github.com/k-man-17/2017-05-18_Seal_Skullsfrom Anna's ACCE_RDM repository:

eval(parse(text = getURL(
  "https://raw.githubusercontent.com/annakrystalli/ACCE_RDM/master/R/eml_utils.R", 
  ssl.verifypeer = FALSE)))

read_csv(
  "https://raw.githubusercontent.com/k-man-17/2017-05-18_Seal_Skulls/master/seal_skulls_clean.csv")

seal_skulls_metadata <-
  get_attr_shell(seal_skulls)

# add the min and max values for numeric variables
seal_skulls_metadata[seal_skulls_metadata$attributeName %in% "Age",c("minimum", "maximum")] <-
  range(seal_skulls$Age, na.rm = TRUE)

seal_skulls_metadata[seal_skulls_metadata$attributeName %in% "PL",c("minimum", "maximum")] <-
  range(seal_skulls$PL, na.rm = TRUE)

seal_skulls_metadata[seal_skulls_metadata$attributeName %in% "CBL",c("minimum", "maximum")] <-
  range(seal_skulls$CBL, na.rm = TRUE)

seal_skulls_metadata[seal_skulls_metadata$attributeName %in% "ZW",c("minimum", "maximum")] <-
  range(seal_skulls$ZW, na.rm = TRUE)

write_csv(seal_skulls_metadata,
          "seal_skulls_metadata_shell.csv")











select(slice(seal_skulls_metadata, attributeName %in% Age), minimum, maximum)




