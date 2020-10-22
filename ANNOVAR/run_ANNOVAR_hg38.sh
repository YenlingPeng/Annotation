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
humandb="/project/GP1/u3710062/AI_SHARE/shared_scripts/ANNOVAR/humandb"

$ANNOVAR $VCF $humandb -buildver ${hg} -out ${para} -remove -protocol refGene,exac03,exac03nonpsych,gnomad211_exome,gnomad211_genome,avsnp150,clinvar_20190305 -operation gx,f,f,f,f,f,f -nastring . -vcfinput -polish

