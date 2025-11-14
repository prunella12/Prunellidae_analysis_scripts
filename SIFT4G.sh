#!/bin/bash
# Annotate VCF with SIFT4G

java -jar /disk3/hkqm/genetic_load/sift/scripts_to_build_SIFT_db/SIFT4G_Annotator.jar \
     -c \
     -i "/home/wuxinlai/ME/genetic_load/file/cds.vcf" \
     -d "/home/wuxinlai/ME/genetic_load/file/a.m/" \
     -r "/home/wuxinlai/ME/genetic_load/file/" \
     -t