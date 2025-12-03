#!/bin/bash
#SBATCH --job-name=STAR
#SBATCH --output=STAR_%A_%a.out
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=mch284@georgetown.edu
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --time=24:00:00
#SBATCH --mem=30G
#SBATCH --array=0-11 ##use 0-11%4 if necessary to limit to 4 jobs at a time

# Load STAR
module load star/2.7.1a

# Directories
trim_dir=/home/scratch/mch284/trim_dir
out_dir=/home/scratch/mch284/STAR1
refgen_dir=/home/scratch/mch284/genome/STAR_index

# List and sort R1 files 
files=( $(ls ${trim_dir}/*_1_PE.fastq.gz | sort) )

# Get this array task's file and base
file="${files[$SLURM_ARRAY_TASK_ID]}"
base=$(basename "$file" _1_PE.fastq.gz)

# Check for input files-- this checks if both R1 and R2 files exist for the current sample. If either is missing it prints an error and exits without running
if [[ ! -f "${trim_dir}/${base}_1_PE.fastq.gz" ]] || [[ ! -f "${trim_dir}/${base}_2_PE.fastq.gz" ]]; then
  echo "Input FASTQ files missing for sample $base" >&2
  exit 1
fi

# Run STAR
STAR --genomeDir "$refgen_dir" \
     --readFilesCommand gunzip -c \
     --readFilesIn "${trim_dir}/${base}_1_PE.fastq.gz" "${trim_dir}/${base}_2_PE.fastq.gz" \
     --outFileNamePrefix "${out_dir}/${base}_"

# Report completion
echo "STAR mapping for $base complete."
