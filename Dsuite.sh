#!/bin/bash

#######Dsuite
### Run Dsuite Dtrios to calculate D-statistics (ABBA-BABA test) for all possible trios
/home/sparrow/software/Dsuite/Build/Dsuite Dtrios -c -n with_geneflow -t /home/wuxinlai/ME/Dsuit/pruned_tree_file.nwk /home/wuxinlai/ME/2-filter_vcf/final_variant.vcf.gz /home/wuxinlai/ME/Dsuit/P.txt

### Run Fbranch to summarize and visualize admixture signals across the tree
Dsuite Fbranch pruned_tree_file.nwk species_sets_with_geneflow_tree.txt > species_sets_with_geneflow_Fbranch.txt

### Visualize Fbranch results using the dtools.py plotting script
python3 dtools.py species_sets_with_geneflow_Fbranch.txt pruned_tree_file.nwk 
