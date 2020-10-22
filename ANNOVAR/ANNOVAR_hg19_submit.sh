#!/bin/bash
#PBS -q ngs96G
#PBS -P MST109178
#PBS -W group_list=MST109178
#PBS -N ANNOVAR_hg38Tohg19
#PBS -j oe
#PBS -M s0890003@gmail.com
#PBS -m e

SAMPLE_ID="NA12878_HG001"
SCRIPT_PATH=/work2/lynn88065/script/Annotation/ANNOVAR/
INPUT_FILE_DIR=/work2/lynn88065/script/Annotation/Input/
OUTPUT_PATH=/work2/lynn88065/script/Annotation/ANNOVAR/

#SAMPLE_ID=$1
#VCF=$2
#OUTPUT_PATH=$3

$SCRIPT_PATH/run_ANNOVAR_hg19.sh $SAMPLE_ID \
         $INPUT_FILE_DIR/Dragen_${SAMPLE_ID}_hg38.chr1.vcf.gz \
         $OUTPUT_PATH
