#!/bin/bash
#SBATCH --time=48:00:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=priitpaluoja@gmail.com
#SBATCH -J CRAM
#SBATCH -N 1
#SBATCH --ntasks-per-node=1
#SBATCH --mem=8000
#SBATCH --cpus-per-task=1

module load samtools-1.9

crams="ls -l cram/*.cram"

for f in $crams; do
	base=$(basename $f)
	samtools fastq $f > cram/${base%.cram}.fastq
done
