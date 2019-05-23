#!/bin/bash
#SBATCH --time=24:00:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=joonas.kriisk@gmail.com
#SBATCH -J bazam_features_count
#SBATCH -N 1
#SBATCH --ntasks-per-node=1
#SBATCH --mem=24000
#SBATCH --cpus-per-task=1

module load samtools-1.9

# srun --pty --time=01:00:00 --mem=8000 bash

bams=/gpfs/hpchome/ppaluoja/bioinformaatika/projekt/BioinformaticsProject/task3/bam/
soft=/gpfs/hpc/home/a72094/teaching/MTAT.03.239_Bioinformatics/software/bin/

for bam_file in "$bams"*.bam; 
do
	base=$(basename $bam_file)
	samtools sort -o results/sortedByCoords.$base $bam_file
	samtools index results/sortedByCoords.$base
	# http://bioinf.wehi.edu.au/subread-package/SubreadUsersGuide.pdf PAGE 38
	$soft/featureCounts -p -C -D 5000 -d 50 -s2 -a "annotations/Homo_sapiens.GRCh38.91.gtf" -o "results/$base.counts" "results/sortedByCoords.$base"
done