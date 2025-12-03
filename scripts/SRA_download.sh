#!/bin/bash
#SBATCH --job-name=sra_download
#SBATCH --output=sra_download_%j.out
#SBATCH --mail-type=END,FAIL --mail-user=mch284@georgetown.edu
#SBATCH --time=10:00:00        
#SBATCH --mem=5G              
#SBATCH --cpus-per-task=1      

cd $SCRATCH

# set PATH to SRA Toolkit ---

export PATH=/home/mch284/sratoolkit.3.0.0-ubuntu64/bin:$PATH

# --- Set working directories ---
SRADIR=/home/scratch/mch284/SRADIR
OUTDIR=/home/scratch/mch284/OUTDIR

# --- Step 1: Download SRA files ---
prefetch --option-file /home/scratch/mch284/scripts/SRR_Acc_List_Embryo.txt --output-directory "$SRADIR"

# --- Step 2: Convert SRA to FASTQ ---
####NOTE step 2 failed because each .sra file is actually in its own directory. Proceeded with SRA2FASTQ.sh which finishes the job as an array
cd "$SRADIR"
for sra_file in *.sra; do
    fasterq-dump --threads $SLURM_CPUS_PER_TASK --outdir "$OUTDIR" "$sra_file"
done

# --- Step 3: Compress FASTQ files ---
cd "$OUTDIR"
gzip *.fastq
