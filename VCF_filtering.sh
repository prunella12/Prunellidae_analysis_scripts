#!/bin/bash
#monomorphic site
plink2 --vcf /home/wuxinlai/ME/2-filter_vcf/all_P.bcftools.raw.out.vcf.gz -aec --geno 0.1 --vcf-min-dp  5 --vcf-max-dp 50 --min-alleles 1 --max-alleles 1  --export vcf-4.2  --out raw_invariant
#polymorphic site
plink2 --vcf /home/wuxinlai/ME/2-filter_vcf/all_P.bcftools.raw.out.vcf.gz -aec --geno 0.1 --vcf-min-dp  5 --vcf-max-dp 50 --min-alleles 2  --max-alleles 2 --var-min-qual 30 --export vcf-4.2  --out raw_variant

bcftools filter raw_variant.vcf --SnpGap 5 --threads 80 -Oz -o raw_variant.gap.vcf.gz

#remove indels
plink2 --vcf raw_variant.gap.vcf.gz --allow-extra-chr --snps-only --export vcf-4.2  --out final_variant

# combine the two VCFs using bcftools concat
bcftools concat --allow-overlaps raw_invariant.gz final_variant.vcf.gz -O z -o all_P.vcf.gz