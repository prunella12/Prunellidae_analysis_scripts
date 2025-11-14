#!/bin/bash
##For example, P. collaris
##Index the VCF file
tabix collaris.vcf.recode.vcf.gz
###Run SMC++
for i in {1..34}; do nohup smc++ vcf2smc /disk3/wuxinlai/genome/smc++/collaris.vcf.recode.vcf.gz chr${i}.smc.gz scaffold_$i collaris:PA20150614-3,PCS2,PCS3,PCM2,PCM749,PCM756,S1318 & done
nohup smc++ estimate --base collaris --konts 15 --timepoints 1000 1000000  --cores 20  -o ./data/ 3.3e-9 ./*.smc.gz &
smc++ plot collaris.pdf collaris.final.json -g 1 --ylim 1000 1000000 -c