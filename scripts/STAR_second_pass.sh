#!/bin/bash
#SBATCH --job-name=STAR_map_twopass
#SBATCH --output=STAR_two_pass_%A_%a.out
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=mch284@georgetown.edu
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --time=24:00:00
#SBATCH --mem=40G
#SBATCH --array=0-11%4 #got worried about running too many jobs at once so swithced to limiting to 4 at a time

#-----------------------------------------------------------------------------#
# This script maps reads to the ref genome using STAR with splice junctions   #
#-----------------------------------------------------------------------------#

module load star/2.7.1a
cd $SCRATCH

#- Set variables ----------------------------------------------------------------#

trim_dir=/home/scratch/mch284/trim_dir
splice_junctions=/home/scratch/mch284/STAR1
out_dir=/home/scratch/mch284/twopass_mapped_reads
refgen_dir=/home/scratch/mch284/genome/STAR_index

# Get sorted R1 files
files=( $(ls ${trim_dir}/*_1_PE.fastq.gz | sort) )

# Use SLURM array index to get a single file for this task
file="${files[$SLURM_ARRAY_TASK_ID]}"
base=$(basename "$file" _1_PE.fastq.gz)

# Check that both R1 and R2 exist
if [[ ! -f "${trim_dir}/${base}_1_PE.fastq.gz" ]] || [[ ! -f "${trim_dir}/${base}_2_PE.fastq.gz" ]]; then
    echo "Missing FASTQ files for sample $base"
    exit 1
fi

# Run STAR with sjdbFileChrStartEnd from ALL SJ.out.tab files
STAR --genomeDir "${refgen_dir}" \
     --readFilesCommand gunzip -c \
     --readFilesIn "${trim_dir}/${base}_1_PE.fastq.gz" "${trim_dir}/${base}_2_PE.fastq.gz" \
     --sjdbFileChrStartEnd "${splice_junctions}"/*_SJ.out.tab \
     --outFileNamePrefix "${out_dir}/${base}_"

echo "STAR two-pass mapping for $base complete."
