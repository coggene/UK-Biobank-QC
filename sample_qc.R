### Input files ###
# ukb_chr1.fam (Obtained using: ./ukbgene cal -c1 -m; fam files are the same for all chromosomes)
# ukb_sqc_v2.txt (downloaded through EGA)
# Aim: add sample IDs to ukb_sqc_v2.txt to create the file sample_qc.txt. Samples are in the same order in fam files and ukb_sqc_v2.txt.


library(data.table)
sqc <- fread('ukb_sqc_v2.txt',stringsAsFactors=F)
sqc <- data.frame(sqc)
sqc <- sqc[,3:ncol(sqc)] # removes first 2 columns
fam <- fread('ukb_chr1.fam')
fam <- data.frame(fam)
fid <- fam$V1
eid <- fam$V2

sample_qc <- cbind.data.frame(fid,eid,sqc)

write.table(sample_qc, file="sample_qc.txt", quote = FALSE, row.names = FALSE, col.names=FALSE)
