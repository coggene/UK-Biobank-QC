## Below creates a list of individuals to remove based on sample QC information provided in sample_qc_v2.txt.
## Removing samples on basis of high heterozygosity, high missingness, discordent sex info., and chromosomal aneuploidies. 
## Relatedness (to be carried out last) and ancestry (carried out seperately) not included.

awk '$12 != $13 {print $1, $12, $13}' sample_qc.txt > discordent_sex_ids.txt
awk '$21==1 {print $1, $2}' sqc2.txt > het_missing_outliers.txt
awk '$22==1 {print $1, $2}' sqc2.txt > sex_aneuploidy.txt

cat discordent_sex_ids.txt het_missing_outliers.txt sex_aneuploidy.txt | sort | uniq > samplesToRemove.txt
