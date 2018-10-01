## Below creates a list of individuals to remove based on sample QC information provided in sample_qc_v2.txt.
## Removing samples on basis of high heterozygosity, high missingness, discordent sex info., and chromosomal aneuploidies. 
## Relatedness (to be carried out last) and ancestry (carried out seperately) not included.

awk '$12 != $13 {print $1, $12, $13}' sample_qc.txt > discordent_sex_ids.txt
awk '$21==1 {print $1, $2}' sample_qc.txt > het_missing_outliers.txt
awk '$22==1 {print $1, $2}' sample_qc.txt > sex_aneuploidy.txt
# Find samples whos IDs begin with a minus (indicates these samples have retracted consent) and remove
grep '^\-' ukb23739_imp_chr22_v3_s487334.sample | awk '{print $1, $2}' > retracted_samples.txt 

cat discordent_sex_ids.txt het_missing_outliers.txt sex_aneuploidy.txt retracted_samples.txt | sort | uniq > samples_to_remove.txt
