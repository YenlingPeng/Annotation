#!/bin/bash
#PBS -l select=1:ncpus=20
#PBS -q ntu192G
#PBS -P MST109178
#PBS -W group_list=MST109178
#PBS -N AnnotSV
#PBS -M s0890003@gmail.com
#PBS -j oe 
#PBS -m e

SAMPLE_NAME="NA12878_HG001"
hg="hg38"

source /pkg/biology/AnnotSV/AnnotSV_v2.3.2/bin/env.sh
export PATH=$PATH:/pkg/biology/BEDTools/BEDTools_v2.27.1/bin/

AnnotSV=/pkg/biology/AnnotSV/AnnotSV_v2.3.2/bin/AnnotSV
INPUT_PATH=/work2/lynn88065/Dragen/Outputs/GRCh38/v3.6.3/NA12878_HG001_hg38/
SV_VCF=$INPUT_PATH/Dragen_${SAMPLE_NAME}_${hg}.sv.vcf.gz
CNV_VCF=$INPUT_PATH/Dragen_${SAMPLE_NAME}_${hg}.cnv.vcf.gz
REPEAT_VCF=$INPUT_PATH/Dragen_${SAMPLE_NAME}_${hg}.repeats.vcf.gz
OUTPUT_PATH=/work2/lynn88065/script/Annotation/AnnotSV

mkdir -p $OUTPUT_PATH/${SAMPLE_NAME}
cd $OUTPUT_PATH/${SAMPLE_NAME}

# Usage
$AnnotSV -SVinputFile $SV_VCF -annotationsDir /work2/lynn88065/Software/Download \
        -bedtools bedtools -genomeBuild GRCh38 -metrics us -outputDir $OUTPUT_PATH/$SAMPLE_NAME \
        -outputFile ${SAMPLE_NAME}_sv.sorted.vcf.annotSV.output.tsv >& AnnotSV_sv.log &&

$AnnotSV -SVinputFile $CNV_VCF -annotationsDir /work2/lynn88065/Software/Download \
        -bedtools bedtools -genomeBuild GRCh38 -metrics us -outputDir $OUTPUT_PATH/$SAMPLE_NAME \
        -outputFile ${SAMPLE_NAME}_cnv.sorted.vcf.annotSV.output.tsv >& AnnotSV_cnv.log &&

$AnnotSV -SVinputFile $REPEAT_VCF -annotationsDir /work2/lynn88065/Software/Download \
        -bedtools bedtools -genomeBuild GRCh38 -metrics us -outputDir $OUTPUT_PATH$SAMPLE_NAME \
        -outputFile ${SAMPLE_NAME}_repeats.sorted.vcf.annotSV.output.tsv >& AnnotSV_repeats.log


