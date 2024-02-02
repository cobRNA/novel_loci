#!/bin/bash

# novel_loci
## Convert targets from gtf to bed format:
cat ./Data/Raw/targets.merged.probed.gene_type.fixed.short_lab.gtf | awk '{print $1 "\t" $4-1 "\t" $5 "\t" $9 "|" $10 "|" $13 "|" $14 "\t" $6 "\t" $7}' | sed 's/"//g' | sed 's/;//g' > ./Data/Processed/targets.merged.probed.gene_type.fixed.short_lab.bed


# For Post-capture
## Clean up ONT_Post_ALL.out file
echo '' > ./Data/Processed/ONT_Post_ALL.out
for file in ./Data/Raw/ONT_Post_*
do
    file_name=$(echo $file | awk -F"/" '{print $4}' | awk -F"." '{print $1}')
    sample=$(echo $file | awk -F"_" '{print $4}' | awk -F"." '{print $1}')
    bedtools intersect -a $file -b ./Data/Processed/targets.merged.probed.gene_type.fixed.short_lab.bed -wa -wb -s | awk '{for(i=1;i<=NF;i++) printf $i"\t"; print ""}' | awk -v s=${sample} '{print $0, "\t", s, "\t", "Post-capture"}' > ./Data/Processed/${file_name}.out
    cat ./Data/Processed/${file_name}.out >> ./Data/Processed/ONT_Post_ALL.out
done



# For Pre-capture
## Clean up ONT_Pre_ALL.out file
echo '' > ./Data/Processed/ONT_Pre_ALL.out
for file in ./Data/Raw/ONT_Pre_*
do
    file_name=$(echo $file | awk -F"/" '{print $4}' | awk -F"." '{print $1}')
    sample=$(echo $file | awk -F"_" '{print $4}' | awk -F"." '{print $1}')
    bedtools intersect -a $file -b ./Data/Processed/targets.merged.probed.gene_type.fixed.short_lab.bed -wa -wb -s | awk '{for(i=1;i<=NF;i++) printf $i"\t"; print ""}' | awk -v s=${sample} '{print $0, "\t", s, "\t", "Pre-capture"}' > ./Data/Processed/${file_name}.out
    cat ./Data/Processed/${file_name}.out >> ./Data/Processed/ONT_Pre_ALL.out
done