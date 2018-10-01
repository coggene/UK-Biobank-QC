# Extract sample ID and first 8 PCs from PCA output
awk '{print $2, $3, $4, $5, $6, $7, $8, $9, $10}' ukb_1KG_pca.eigenvec | sed '1d' > ukb_1kg.eigenvec

### Subset this to create two new files ###
#1. containing only 1000 genomes CEU samples (CEU_PCs1-8.txt)
#2. containing only ukb samples (UKB_PCs1-8.txt)

# Get population codes corresponding to each 1KG sample
awk '{print $2, $7}' integrated_call_samples.20101123.ped | sed "1d" > 1kg_sample_labels.txt

# Extract UKB samples from eigenvec file
awk '{print $1, "UKB"}' ukb_1kg1.eigenvec | grep '^1\|^2\|^3\|^4\|^5\|^6' > ukb_sample_labels.txt

# Concatenate these two files to create a file identifying each sample as being from UKB or if from 1KG, assigning them to their population. 
cat ukb_sample_labels.txt 1kg_sample_labels.txt > ukb_1kg_sample_labels.txt

# Add these labels to eigenvec file

awk 'NR==FNR { n[$1]=$0;next } ($1 in n) { print n[$1],$2 }' ukb_1kg.eigenvec ukb_1kg_sample_labels.txt > ukb_1kg_labelled.eigenvec

awk '$5 == "CEU" {print $2, $3, $4}' ukb_1kg_labelled.eigenvec > CEU_PCs1-8.txt

awk '$5 == "UKB" {print $1, $2, $3, $4}' ukb_1kg_labelled.eigenvec > UKB_PCs1-8.txt

## Run R script to calculate mahalinobis distance of each sample in UKB to the multi-mean of CEU samples and output a list of european samples
Rscript pca_maha.R
