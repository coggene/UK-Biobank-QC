# Get 1000 genomes data
for i in {1..22};
do
wget "ftp://ftp.1000genomes.ebi.ac.uk/vol1/ftp/phase1/analysis_results/integrated_call_sets/ALL.chr$i.integrated_phase1_v3.20101123.snps_indels_svs.genotypes.vcf.gz"
done

gunzip *.vcf.gz


# Using UK Biobank supplied maker QC file, extract list of snps used for PCA by UKB.
awk '$118==1 {print $1}' ukb_snp_qc.txt > snps_used_inPCA.txt

# Extract this list from vcf files and convert to plink binary format
for i in {1..22}
do
plink --vcf ALL.chr$i.integrated_phase1_v3.20101123.snps_indels_svs.genotypes.vcf --extract snps_used_inPCA.txt --make-bed --out chr${i}_1KG

# Merge chromosomes:

for i in {1..22}; do echo chr${i}_1KG.bed chr${i}_1KG.bim chr${i}_1KG.fam; done > merge_list.txt 

plink --merge-list merge-list.txt --make-bed --out All_Chr_1KG

# Extract list of 1KG SNPs from merged UKB directly genotyped files:

awk '{print $1}' All_Chr_1KG.bim > 1KG_snps.txt

plink --bfile ukb_122merged --extract 1KG_snps.txt --make-bed --out ukb_forPCA

# Merge UKB and 1KG files
plink --bfile ukb_forPCA --bmerge All_Chr_1KG.bed All_Chr_1KG.bim All_Chr_1KG.fam --make-bed --out ukb_1kg

# Copy this file from syd to headnode and carry out PCA using plink2. --approx option used to reduce memory requirement.

../plink2 --bfile --pca approx --out ukb_1KG_pca
