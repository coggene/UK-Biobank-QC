# This script reads in two files, CEU_PCs1-8.txt and UKB_PCs1-8.txt. These files were created by editing the
# .eigenvec file output from PCA to contain only CEU samples and only UKB samples, respectively. The multi-mean 
# of the CEU samples is calculated and the ml distance of each UKB sample from this mean is calculated. All 
# samples under 6 S.D. away from mean are identified as being European.

euro_pca <- read.table("CEU_PCs1-8.txt",header=FALSE)
ukb_pca <- read.table("UKB_PCs1-8.txt",header=FALSE, row.names = 1)
matrix_ukb_pca <- data.matrix(ukb_pca, rownames.force = TRUE)
multi_mean <- sapply(euro_pca,mean)
cov_ukb = cov(matrix_ukb_pca)
ml <- mahalanobis(matrix_ukb_pca, multi_mean, cov_ukb, method = mcd)
ml_df_sorted <- data.frame(sort(ml, decreasing = TRUE))
euro <- ml_df_sorted[ml_df_sorted$sort.ml..decreasing...TRUE. < 6,,drop=FALSE]
non_euro <- ml_df_sorted[ml_df_sorted$sort.ml..decreasing...TRUE. >= 6,,drop=FALSE]
euro_samples <- rownames(euro)
noneuro_samples <- rownames(non_euro)
writeLines(euro_samples, "euro_samples", sep = "\n")
writeLines(noneuro_samples, "noneuro_samples", sep = "\n")
