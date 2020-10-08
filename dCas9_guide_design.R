library(tidyverse)
library(readxl)

# import raw data
getwd()
file.exists("CRISPRi sgRNA database (Horlbeck et al., 2016).xlsx")

excel_sheets("CRISPRi sgRNA database (Horlbeck et al., 2016).xlsx")

guidedb <- read_xlsx("CRISPRi sgRNA database (Horlbeck et al., 2016).xlsx", sheet = "hCRISPRi-v2.1")
head(guidedb, n = 20)

#remove first 9 rows and rename columns
guidedb_rows <- guidedb[-c(1:9),]
head(guidedb_rows)
guidedb_new <- guidedb_rows %>% setNames(c("sgID", "gene", "transcript", "protospacer_sequence", "selection_rank",
                                           "predicted_score", "empirical_score", "off_target_stringency", "sublibrary_half"))

# change selection rank, predicted score and empirical score to numeric 
guidedb_new$selection_rank <- as.numeric(guidedb_new$selection_rank)
guidedb_new$predicted_score <- as.numeric(guidedb_new$predicted_score)
guidedb_new$empirical_score <- as.numeric(guidedb_new$empirical_score)

# add new column with strand + or -
guidedb_new$strand <- ifelse(grepl("?._-_?.", guidedb_new$sgID), "-", "+")

# install Biostrings
if (!requireNamespace("BiocManager", quietly = TRUE))
  install.packages("BiocManager")
BiocManager::install("Biostrings")
require(Biostrings)

# reverse complement protospacer sequence
protospacer_reverse <- DNAStringSet(guidedb_new$protospacer_sequence)
protospacer_reverse <- reverseComplement(protospacer_reverse)
protospacer_reverse <- as.character(protospacer_reverse)

guidedb_new <- guidedb_new %>% mutate(protospacer_reverse = protospacer_reverse)


# filter out top 3 guides and add overhangs for cloning
top_three_table <- guidedb_new %>% filter(gene == "WWP1" & between(selection_rank, 1, 3)) %>%
  mutate(sense = paste("CACC", protospacer_sequence, sep = ""), 
         antisense = paste("AAAC", protospacer_reverse, sep = "")) %>%
  select(gene, protospacer_sequence, selection_rank, strand, sense, antisense)

# export as csv for your records
write.csv(top_three_table, "top_three.csv", row.names = FALSE)

# Convert table to format required by UFS
oligo_order <- top_three_table %>%
  gather(oligo, Oligo_sequence_5_to_3, "sense" : "antisense") %>%
  mutate(Oligo_name = paste(gene, selection_rank, oligo, sep = "_"), 
         Researcher_Name = "Dr Rachel Allison",
         Minimum_scale = as.numeric(25),
         Scale_units = "nano",
         Purification = "Desalted") %>%
  select(Researcher_Name, Oligo_name, Minimum_scale, Scale_units, Oligo_sequence_5_to_3, Purification)

# export as csv for ordering
write.csv(oligo_order, "oligo_order.csv", row.names = FALSE)
  

  
  
  
  
  
  
  
  
                   