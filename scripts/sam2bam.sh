#!/bin/bash
#SBATCH --job-name=sam2bam
#SBATCH --output=sam2bam_%A_%a.out
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=mch284@georgetown.edu
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --time=12:00:00
#SBATCH --mem=1G
#SBATCH --array=0-11%4

cd $SCRATCH

module load samtools/1.9

sam_dir=/home/scratch/mch284/twopass_mapped_reads
bam_dir=/home/scratch/mch284/bamdir

mkdir -p "$bam_dir"

# Sorted list for consistent order
files=( $(ls ${sam_dir}/*_Aligned.out.sam | sort) )
file="${files[$SLURM_ARRAY_TASK_ID]}"
base=$(basename "${file}" _Aligned.out.sam)

samtools view -b -S "${sam_dir}/${base}_Aligned.out.sam" | \
    samtools sort -o "${bam_dir}/${base}_Aligned.out.bam"

samtools index "${bam_dir}/${base}_Aligned.out.bam"
