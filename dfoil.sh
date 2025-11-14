#!/bin/bash

####### Dfoil analysis
# The directory ../split_50kb/ contains the aligned sequences of five species,
# each file representing a 50-kb genomic fragment.
##species for koslowi,fulvescens,montanella,rubida,outgroup

# Convert multi-fasta alignments into Dfoil input format (allele counts file)
nohup python /disk3/wuxinlai/Dfoil/dfoil/fasta2dfoil.py --out kofu.counts -n koslowi,fulvescens,montanella,rubida,outgroup ../split_50kb/kofu* &

# Run Dfoil to infer the direction and intensity of introgression among the four ingroup taxa
nohup python /disk3/wuxinlai/Dfoil/dfoil/dfoil.py --infile kofu.counts --out kofu.out --plot kofu.pdf &

#####species for atrogularis,ocularis,montanella,rubida,outgroup
nohup python /disk3/wuxinlai/Dfoil/dfoil/fasta2dfoil.py --out atoc.counts -n atrogularis,ocularis,montanella,rubida,outgroup ../split_50kb/atoc* &
nohup python /disk3/wuxinlai/Dfoil/dfoil/dfoil.py --infile atoc.counts --out atoc.out --plot atoc.pdf &
