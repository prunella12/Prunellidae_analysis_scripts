#!/bin/bash
VCF=/home/wuxinlai/ME/2-filter_vcf/final_variant
nohup plink --vcf $VCF --double-id --allow-extra-chr --indep-pairwise 50 10 0.1 --out prunella &
nohup plink --vcf $VCF --double-id --allow-extra-chr --extract prunella.prune.in --make-bed --pca --out prunella &