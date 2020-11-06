#!/bin/bash

# basic info
SAMPLE_ID=$1
VCF=$2
OUTPUT_PATH=$3
hg="hg38"

mkdir -p $OUTPUT_PATH/${SAMPLE_ID}_${hg}
cd $OUTPUT_PATH/${SAMPLE_ID}_${hg}

# logfile
TODAY=`date +%Y%m%d%H%M`
logfile=./${TODAY}_run.log
exec 3<&1 4<&2
exec >$logfile 2>&1
set -euo pipefail
set -x

# run Annotation
para="ANNOVAR_${SAMPLE_ID}"
ANNOVAR="/pkg/biology/ANNOVAR/ANNOVAR_20191024/table_annovar.pl"
humandb="/project/GP1/u3710062/AI_SHARE/shared_scripts/ANNOTATION/ANNOVAR/humandb/"

# hg38
$ANNOVAR $VCF $humandb -buildver ${hg} -out ${para} -remove -protocol refGene,knownGene,ensGene,gnomad211_genome,avsnp150,gnomad211_exome,clinvar_20200316,dbnsfp41a -operation gx,gx,gx,f,f,f,f,f -nastring . -vcfinput -polish --maxgenethread 20 --thread 20  

# filtering the exonic/splicing and nonsynonymous/ncRNA_exonic variants
head -n 1 ${para}.${hg}_multianno.txt > ${para}_filtered_annotation.txt
grep -e "exonic" -e "splicing" ${para}.${hg}_multianno.txt | grep -P -v "\tsynonymous" | grep -P -v "\tncRNA_exonic\t" >> ${para}_filtered_annotation.txt
