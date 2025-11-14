##!/bin/bash
vcftools --gzvcf P.beagle.vcf.gz \
         --keep montanella_sample.txt \
         --recode \
         --recode-INFO-all \
         --out  montanella.beagle

######split by chromosome
for i in {1..34};
do vcftools --vcf montanella.beagle.recode.vcf \
            --recode \
            --recode-INFO-all \
            --chr ${i} \
            --out  montanella.chr${i};
done

###prepare the MAP file
for k in {1..34};
do vcftools --vcf montanella.chr${k}.recode.vcf \
            --plink \
            --out chr${k}.MT;
done


###calculate genetic distance
for k in {1..34}; 
do awk 'BEGIN{OFS=" "} {print 1,".",$4/1000000,$4}' chr${k}.MT.map > chr${k}.MT.map.distance;
done

###calculate ihh12
for k in {1..34}; 
do /home/software/selscan/bin/linux/selscan --ihh12 \
                                            --vcf chr${k}.vcf \
                                            --map chr${k}.MT.map.distance \
                                            --out  chr${k}.ihh12;
done  

###Change the first column to chromosome number
for k in  {1..34};
do awk  '{print '${k}',$2,$3,$4,$5,$6}'  chr${k}.ihh12.ihh12.out > Chr${k}.ihh12.out ;
sed -i 's/ /\t/g' Chr${k}.ihh12.out;      
done


for k in  {1..34};
do /home/software/selscan/bin/linux/norm --ihh12 \
                                         --files  Chr${k}.ihh12.out  \
                                         --bp-win --winsize 50000;
done

####Add a 50 kb window and standardize
for k in  {1..34};
do /home/software/selscan/bin/linux/norm --ihh12 \
                                         --files  Chr${k}.ihh12.out  \
                                         --bp-win --winsize 50000;
done