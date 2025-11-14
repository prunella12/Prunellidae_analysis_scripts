#!/bin/bash

###Remove sites with missing data
vcftools --vcf "/home/wuxinlai/ME/2-filter_vcf/final_variant.vcf" --max-missing 1 --recode --stdout > SNPs_no_missing.vcf
###Perform LD pruning to remove physically linked SNPs
plink --vcf SNPs_no_missing.vcf --indep-pairwise 50 10 0.2 --out tmp.ld --allow-extra-chr --set-missing-var-ids @:# --keep-allele-order
plink --vcf SNPs_no_missing.vcf --extract tmp.ld.prune.in --freq --missing --within sample.list --out input --allow-extra-chr --set-missing-var-ids @:# --keep-allele-order

###Convert PLINK output to TreeMix format
gzip input.frq.strat
python2.7 plink2treemix.py input.frq.strat.gz input_treemix.frq.gz

### Run TreeMix testing 0¨C5 migration events, using Tree Sparrow as the root
for i in {0..5}; do treemix -i input_treemix.frq.gz -K 500 -m $i -bootstrap -root Tree_sparrow -noss -o out.${i} > treemix_${i}_log; done
