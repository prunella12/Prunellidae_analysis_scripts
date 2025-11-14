#!/bin/bash

set -e
set -x 
set -o pipefail

ref=/disk3/wuxinlai/ME/Prunella_strophita_assemble_HiC.fasta

##SNP calling was run in parallel on split chromosome files, and the per-chromosome VCFs were concatenated to  the final whole-genome VCF
awk '{print $1, 1 ,$2}' /disk3/wuxinlai/ME/Prunella_strophita_assemble_HiC.fasta.fai > split.txt
awk '{print $1}' /disk3/wuxinlai/ME/65sample.list | sed "s:^:/disk3/wuxinlai/ME/bam/:" |sed "s:$:.filtered.bam:" > bam.out.list.txt
while read line ; do { if [ -f $line ];then echo "yes" ; else echo "no" ; fi }; done < /disk3/wuxinlai/ME/call_vcf/bam.out.list.txt

thread=80
temfifo=$$.fifo
mkfifo $temfifo
exec 9<>$temfifo
rm $temfifo

for ((i=1;i<=$thread;i++))
do
    echo >&9
done

while read chr sta end 
do
if [ $chr ]
then
read -u9
{


time  bcftools mpileup -Ou -f $ref -r ${chr}:${sta}-${end} -b /disk3/wuxinlai/ME/call_vcf/bam.out.list.txt \
--annotate FORMAT/AD,FORMAT/ADF,FORMAT/ADR,FORMAT/DP,FORMAT/SP,INFO/AD,INFO/ADF,INFO/ADR | bcftools call -m -Oz -f GQ -o ${chr}.bcftools.chr.vcf.gz
    echo >&9
}&
fi
done < /disk3/wuxinlai/ME/call_vcf/split.txt
wait

awk '{print $1}' /disk3/wuxinlai/ME/Prunella_strophita_assemble_HiC.fasta.fai |sed "s:^:/disk3/wuxinlai/ME/call_vcf/:" |sed "s:$:.bcftools.chr.vcf.gz:" > chr.raw.list.txt

time bcftools concat  --threads 80 -Oz -o /disk3/wuxinlai/ME/call_vcf/P.bcftools.raw.out.vcf.gz -f chr.raw.list.txt

exec 9>$-
