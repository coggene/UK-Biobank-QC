# UK-Biobank-QC

## Generation of Sample QC Files

### sample_qc.R ###

This script adds sample IDs to ukb_sqc_v2.txt. Samples are in the same order in fam files and ukb_sqc_v2.txt.

Input files:
1. ukb_chr1.fam (Obtained using: ./ukbgene cal -c1 -m; fam files are the same for all chromosomes)
2. ukb_sqc_v2.txt (downloaded through EGA)

### samples_to_remove.sh

Creates a list of samples to remove based on the failing of sample QC checks for high heterozygosity, high missingness, discordent sex info., and chromosomal aneuploidies. Relatedness (to be carried out last) and ancestry (carried out seperately) not included.

Necessary files:
1. sample_qc.txt (output of sample_qc.R)
2. any .sample file (./ukbgene imp -c1 -m)

### pca.sh 

Downloads 1000 genomes vcf files and merges them with UKB directly genotyped files. PCA is carried out on this merged set of plink files in Plink2 using the --approx option to reduce memory requirements.

Necessary files:
1. ukb_snp_qc.txt (UKB supplied)
2. ukb_122merged.bed; ukb_122merged.bim; ukb_122merged.fam (UKB directly genotpyed chromosomes 1-22 merged)


### euro_samples.sh

This script takes the .eigenvec file output of pca.sh and subsets it to create two new files. One containing only 1000 genomes CEU samples and the other containing only UKB samples. pca_maha.R is then run to output a list of european individuals based on Mahalanobis distance > 6 s.d.

Necessary files:
1. ukb_1KG_pca.eigenvec (output of pca.sh)
2. integrated_call_samples.20101123.ped (pca.sh)

### pca_maha.R

Calculates the multi-mean eigenvectors of CEU samples and measures the distance of each UKB sample to this mean. Samples with Mahalanobis distance < 6 s.d are identified as being of european ancestry.

Necessary files:
1. CEU_PCs1-8.txt (output of euro_samples.sh)
2. UKB_PCs1-8.txt (output of euro_samples.sh)

### rel_qc.sh

This script loops through the relatedness file supplied by UK Biobank and removes individuals from related pairs in a way that optimises the number of individuals kept, while preferentially removing samples that do not contain data of interest. 

Input files:
1. Relatedness file (./ukbgene rel)
2. List of individuals with data of interest available i.e. list of individuals you preferentially want to keep. 
I preferentially wanted to keep individuals with cognitive data available. I first extracted phenotypic data using ukbconv. From the resulting .tab file, I was interested in preferentially keeping those individuals who had data available in at least one of columns 3, 4 or 5:

On terminal:
#### If columns 3, 4 or 5 does not equal to NA, print first column (containing sample IDs) and place in new file
awk '$3 != "NA" || $4 != "NA" || $5 != "NA" {print $1}' ids_cognition.tab | sed "1d" > IDstoKeep.txt




## Generation of Variant QC Files

### snpsTokeep.R

Input files:
1. Chromomsome specific mfi files supplied by UKB

Creates a list of SNPs that have an info score greater than 0.9 and MAF greater than 0.001 for each chromosome.

### Plink command:

For each chromosome:

../plink2 --bgen ukb_imp_chr22_v3.bgen --sample ukb23739_imp_chr22_v3_s487334.sample --keep euro_samples13.txt --remove samplesToRemove.txt --exclude UKBioBiLallfreqSNPexclude.dat --extract snpsToKeep_chr22 --geno 0.02 --make-bed --out chr22_cleaned

### Merge Chromosome specific cleaned files

Last step (project specific):

Filter out related individuals as well as SNPs that fail Hardy Weinburg Tests (affected by relatedness, therefore must be carried out last).




