## Data retrieval
I [first downlowded the SRA toolkit](https://github.com/ncbi/sra-tools/wiki/02.-Installing-SRA-Toolkit) to my home directory on the GU hpc.
I tried to to fetch the raw .sra reads from NCBI and convert them to fastqz files in a [single script] (scripts/SRA_download.sh), but the second step in the script failed because the .sra fies were put in individual directories rather than in a single SRA directory. 
Therefore I also ran [SRA2FASTQ.sh] (scripts/SRA2FASTQ.sh) to account for the proper file hierarchy. To improve speed, I used an array and I checked that the resulting unzipped files matched the raw read counts previously reported: [see embryo tab] (https://docs.google.com/spreadsheets/d/1hIqqMIk8ZVw56BJ8_YN_OnwuzdWBSH7bujwDMTqsCKs/edit?gid=2121345980#gid=2121345980). 
After checking the array behaved as expected based on read counts, I zipped all files and [renammed] (misc/rename_SRA_files.sh) them with biologically meaningful names.

## Trimmomatic
Trimmed reads using this [script] (scripts/trim.sh), which removes adapters and uses HEADCROP:15 \ SLIDINGWINDOW:4:15 \ MINLEN:50 to remove low quality and short reads.

## Mapping
Mapped reads using STAR. The genome was originally retrieved from [NCBI] (https://www.ncbi.nlm.nih.gov/datasets/genome/GCF_035046485.1/) and indexed using STAR.
Reads were mapped using a two pass method to identify novel splice junctions. The script for the first pass is [here] (scripts/STAR_first_pass.sh). and the second pass is [here] (scripts/STAR_second_pass.sh). 
Convert sam to bam files ([script here]) (scripts/sam2bam.sh).

    
