#!/bin/bash
#SBATCH --time=24:00:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=priitpaluoja@gmail.com
#SBATCH -J FeatureCOUNTS
#SBATCH -N 1
#SBATCH --ntasks-per-node=1
#SBATCH --mem=4000
#SBATCH --cpus-per-task=1

module load samtools-1.9

mkdir results

bams="ls -l mapped/*.bam"
soft=/gpfs/hpc/home/a72094/teaching/MTAT.03.239_Bioinformatics/software/bin/


for f in $bams; do
	base=$(basename $f)
	samtools sort -o results/sortedByCoords.$base $f
	samtools index results/sortedByCoords.$base
	# http://bioinf.wehi.edu.au/subread-package/SubreadUsersGuide.pdf PAGE 38
	$soft/featureCounts -p -C -D 5000 -d 50 -s2 -a "annotations/Homo_sapiens.GRCh38.91.gtf" -o "results/$base.counts" "results/sortedByCoords.$base"
done
