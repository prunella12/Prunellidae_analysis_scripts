##!/bin/bash
cat 62sample.list | while read line; do bcftools mpileup -Ou -I -f /home/prunella/BGI_genome/Prunella_strophita_assemble_HiC.fasta /home/wuxinlai/ME/1-raw_filter_bam/${line}.filtered.bam | bcftools call -c -Ov | vcfutils.pl vcf2fq -d 10 -D 100 | gzip - > ${line}.psmc.fq.gz & done

cat 62sample.list | while read line; do fq2psmcfa -q20 ${line}.psmc.fq.gz > ${line}.psmc.fa & done

cat ../62sample.list | while read line; do psmc -N30 -t5 -r5 -p "4+251*1+4+6+10" -o ${line}.psmc ../${line}.psmc.fa & done 

