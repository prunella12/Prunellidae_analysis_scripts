#!/bin/bash
####genotype imputation using Beagle
java -Xmx716800m -jar beagle.29Oct24.c8e.jar gt=final_variant.vcf out=P.beagle nthreads=80

vcftools --gzvcf P.beagle.vcf.gz \
         --keep strophiata_sample.txt \
         --recode \
         --recode-INFO-all \
         --out strophiata.beagle

vcftools --gzvcf P.beagle.vcf.gz \
         --keep montanella_sample.txt \
         --recode \
         --recode-INFO-all \
         --out  montanella.beagle

######split by chromosome
for i in {1..34};
do vcftools --vcf strophiata.beagle.recode.vcf \
            --recode \
            --recode-INFO-all \
            --chr ${i} \
            --out  strophiata.chr${i};
done

for i in {1..34};
do vcftools --vcf montanella.beagle.recode.vcf \
            --recode \
            --recode-INFO-all \
            --chr ${i} \
            --out  montanella.chr${i};
done

###prepare the MAP file
for k in {1..34};
do vcftools --vcf strophiata.chr${k}.recode.vcf \
            --plink \
            --out chr${k}.MT;
done


###calculate genetic distance
for k in {1..34}; 
do awk 'BEGIN{OFS=" "} {print 1,".",$4/1000000,$4}' chr${k}.MT.map > chr${k}.MT.map.distance;
done


####calculate XP-EHH
for k in {1..34}; 
do /home/software/selscan/bin/linux/selscan --xpehh \
                                            --vcf strophiata.chr${k}.recode.vcf \
                                            --vcf-ref montanella.chr${k}.recode.vcf \
                                            --map chr${k}.MT.map.distance \
                                            --threads 10 \
                                            --out  chr${k}.montanella_strophiata;
done 



###Change the first column to chromosome number
for k in {1..34};
do awk  '{print '${k}',$2,$3,$4,$5,$6,$7,$8}' chr${k}.montanella_strophiata.xpehh.out > Chr${k}.montanella_strophiata.xpehh.out;
sed -i 's/ /\t/g' Chr${k}.montanella_strophiata.xpehh.out;      
done


####Add a 50 kb window and standardize
for k in {1..34};
do /home/software/selscan/bin/linux/norm --xpehh \
                                         --files  Chr${k}.montanella_strophiata.xpehh.out \
                                         --bp-win --winsize 50000;
done
