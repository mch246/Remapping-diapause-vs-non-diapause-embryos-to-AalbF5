#!/bin/bash
#SBATCH --job-name=sra_dump_array
#SBATCH --output=sra_dump_%A_%a.out
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=mch284@georgetown.edu
#SBATCH --time=10:00:00
#SBATCH --mem=5G
#SBATCH --cpus-per-task=1
#SBATCH --array=0-11 ###Running as an array. If necessary to limit to 4 jobs at a time use SBATCH --array=0-11%4

SRADIR=/home/scratch/mch284/SRADIR
OUTDIR=/home/scratch/mch284/OUTDIR

export PATH=/home/mch284/sratoolkit.3.0.0-ubuntu64/bin:$PATH

# Get list of subdirs (one per .sra file)
SRADIR_LIST=($(find "$SRADIR" -mindepth 1 -maxdepth 1 -type d))

MYDIR=${SRADIR_LIST[$SLURM_ARRAY_TASK_ID]}
SRA_FILE=$(find "$MYDIR" -maxdepth 1 -name "*.sra" -type f)

fasterq-dump --threads $SLURM_CPUS_PER_TASK --outdir "$OUTDIR" "$SRA_FILE"
