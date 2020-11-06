#!/bin/bash

# basic info
SAMPLE_ID=$1
VCF=$2
OUTPUT_PATH=$3
hg="hg19"

mkdir -p $OUTPUT_PATH/${SAMPLE_ID}_${hg}
cd $OUTPUT_PATH/${SAMPLE_ID}_${hg}

#liftovervcf from hg38 to hg19 and normalized
CHAIN_FILE="/project/GP1/u3710062/AI_SHARE/reference/Liftover/hg38ToHg19.over.chain.gz"
REF_GENOME_PATH="/project/GP1/u3710062/AI_SHARE/reference/GATK_bundle/hg19/ucsc.hg19.fasta"
Picard="/pkg/biology/Picard/Picard_v2.18.11/picard.jar"
VT_PATH="/project/GP1/u3710062/AI_SHARE/software/vt-0.57721/vt"

#TODAY=`date +%Y%m%d%H%M`
#logfile=$OUTPUT_PATH/${SAMPLE_ID}_${hg}/${TODAY}_run.log
#exec 3<&1 4<&2
#exec >$logfile 2>&1
#set -euo pipefail
#set -x

# Liftover VCF
java -jar $Picard LiftoverVcf \
      I=$VCF \
      O=${SAMPLE_ID}_${hg}_hard-filtered_liftover.vcf \
      CHAIN=$CHAIN_FILE \
      REJECT=${SAMPLE_ID}_${hg}_rejected_variants.vcf \
      R=$REF_GENOME_PATH

# VT-normalization
$VT_PATH decompose -s -o ${SAMPLE_ID}_${hg}.decomposed.vcf ${SAMPLE_ID}_${hg}_hard-filtered_liftover.vcf
$VT_PATH normalize -o ${SAMPLE_ID}_${hg}.norm.vcf -r $REF_GENOME_PATH ${SAMPLE_ID}_${hg}.decomposed.vcf

# run Annotation
para="ANNOVAR_${SAMPLE_ID}"
ANNOVAR="/pkg/biology/ANNOVAR/ANNOVAR_20191024/table_annovar.pl"
normalized_VCF=$OUTPUT_PATH/${SAMPLE_ID}_${hg}/${SAMPLE_ID}_${hg}.norm.vcf
humandb="/project/GP1/u3710062/AI_SHARE/shared_scripts/ANNOVAR/humandb/"

# hg19
$ANNOVAR $normalized_VCF $humandb -buildver ${hg} -out ${para} -remove -protocol refGene,knownGene,ensGene,TaiwanBiobank993WGS,gnomad211_genome,avsnp150,TaiwanBiobank-official,gnomad211_exome,clinvar_20200316,cosmic_coding_GRCh37_v92,cosmic_noncoding_GRCh37_v92,dbnsfp41a -operation gx,gx,gx,f,f,f,f,f,f,f,f,f -nastring . -vcfinput -polish --maxgenethread 20 --thread 20

# filtering the exonic/splicing and nonsynonymous/ncRNA_exonic variants
head -n 1 ${para}.${hg}_multianno.txt > ${para}_filtered_annotation.txt
grep -e "exonic" -e "splicing" ${para}.${hg}_multianno.txt | grep -P -v "\tsynonymous" | grep -P -v "\tncRNA_exonic\t" >> ${para}_filtered_annotation.txt
