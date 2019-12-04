# Use UK Biobank supplied mfi files to create a list of SNPs for each chromosome with MAF > 0.001 and info score > 0.9. 

for (i in 1:22){
mfi_chr <- read.table(paste("ukb_mfi_chr", i, "_v3.txt", sep = ""), header = F)
snpsTokeep <- mfi_chr[mfi_chr$V6 > 0.01 & mfi_chr$V8 > 0.9,]
write.table(snpsTokeep, paste("snpsTokeep_chr", i, sep = ""), quote = FALSE, row.names = FALSE}

## Edit resulting files on command line:
# for i in {1..22}
# do 
# awk '{print $2}' snpsTokeep_chr$i.txt | sed "1d" | sort | uniq > snpsToKeep_chr$i.txt
# done
