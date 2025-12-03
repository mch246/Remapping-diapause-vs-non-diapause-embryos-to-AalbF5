#!/bin/bash
#SBATCH --job-name=trim
#SBATCH --output=trim_%A_%a.out
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=mch284@georgetown.edu
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1         
#SBATCH --time=24:00:00
#SBATCH --mem=4G                 
#SBATCH --array=0-23             ##could use 0-23%4 to only run 4 jobs at time

cd $SCRATCH/mch284

#Set variables

raw_dir=/home/scratch/mch284/OUTDIR
trim_dir=/home/scratch/mch284/trim_dir
trim=/home/mch284/trimmomatic/Trimmomatic-0.39/trimmomatic-0.39.jar
adapter=/home/mch284/trimmomatic/Trimmomatic-0.39/adapters/TruSeq3-PE-2.fa:2:30:10

# Get sample list
files=(${raw_dir}/*_1.fastq.gz)

# Determine file for this task
file=${files[$SLURM_ARRAY_TASK_ID]}
base=$(basename $file _1.fastq.gz)

java -Xmx2G -jar $trim PE \
    $raw_dir/${base}_1.fastq.gz \
    $raw_dir/${base}_2.fastq.gz \
    $trim_dir/${base}_1_PE.fastq.gz $trim_dir/${base}_1_SE.fastq.gz \
    $trim_dir/${base}_2_PE.fastq.gz $trim_dir/${base}_2_SE.fastq.gz \
    ILLUMINACLIP:$adapter \
    HEADCROP:15 \
    SLIDINGWINDOW:4:15 \
    MINLEN:50
    
# Count reads in paired output files to check they match Sarah's previous worklflow with AalbF3
for fq in ${trim_dir}/${base}_1_PE.fastq.gz ${trim_dir}/${base}_2_PE.fastq.gz; do
    n_reads=$(zcat "$fq" | wc -l)
    echo "$fq: $((n_reads/4)) reads" >> ${trim_dir}/${base}_trim_summary.txt
done
