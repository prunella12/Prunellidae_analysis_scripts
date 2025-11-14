#!/bin/bash
for i in collaris himalayana fulvescens strophiata rubeculoides immaculata atrogularis koslowi ocularis montanella modularis rubida
do
vcftools --gzvcf final_variant.vcf.gz --keep ${i}.sample.txt --TajimaD 50000 --out ${i}_prefix &
done