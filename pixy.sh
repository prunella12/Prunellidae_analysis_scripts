#!/bin/bash

pixy --stats pi fst dxy \
--vcf /home/wuxinlai/ME/2-filter_vcf/all_P.vcf.gz \
--populations sample.list \
--window_size 50000 \
--n_cores 8