#!/bin/bash
#SBATCH --time=24:00:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=rain.vagel@gmail.com
#SBATCH -J FeatureCOUNTS
#SBATCH -N 1
#SBATCH --ntasks-per-node=1
#SBATCH --mem=4000
#SBATCH --cpus-per-task=1

module load samtools-1.9

mkdir task_4_counts

bams="ls -l bazam_results/*.bam"
soft=/gpfs/hpc/home/a72094/teaching/MTAT.03.239_Bioinformatics/software/bin/


for f in $bams; do
	base=$(basename $f)
	samtools sort -o task_4_counts/sortedByCoords.$base $f
	samtools index task_4_counts/sortedByCoords.$base
	# http://bioinf.wehi.edu.au/subread-package/SubreadUsersGuide.pdf PAGE 38
	$soft/featureCounts -p -C -D 5000 -d 50 -s2 -a "annotations/Homo_sapiens.GRCh38.91.gtf" -o "task_4_counts/$base.counts" "task_4_counts/sortedByCoords.$base"
done
