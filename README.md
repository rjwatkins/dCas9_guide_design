****dCas9_Guide_Design.R****

This program uses the protospacer sequences identified in Horlbeck et al., 2016 to design sense and antisense oligo sequences for any gene of choice that are formatted as a csv file ready to upload to the University of Cambridge (UFS) purchasing program.

The original .xlsx file from the Horlbeck paper is: CRISPRi sg database (Horlbeck et al., 2016).xlsx

Run the following steps of the program:
 -  import raw data
 -  remove first 9 rows and rename columns
 -  change selection rank, predicted score and empirical score to numeric
 -  add new column with strand + or -
 -  install Biostrings
 -  reverse complement protospacer sequence

 -  filter out top 3 guides and add overhangs for cloning
 
In this step chnage the gene name to your gene of interest and the cloning overhangs for your sense and antisense strands. The current overhangs are suitable for cloning into pKLV and pX459.

 -  export as csv for your records
 
Exports the relevant information as a csv file for your records.

 -  Convert table to format required by UFS
 
Change your name and any other parameters you require.

 - export as csv for ordering
 
Exports csv file in correct format for upload on UFS. It creates a few errors on UFS but doesn't seem to prevent upload.
