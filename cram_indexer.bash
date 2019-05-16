#!/bin/bash
#SBATCH --time=24:00:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=joonas.kriisk@gmail.com
#SBATCH -J Bazam_test
#SBATCH -N 1
#SBATCH --ntasks-per-node=1
#SBATCH --mem=8000
#SBATCH --cpus-per-task=1

module load samtools-1.9
#samtools faidx fasta

all="ls -l /gpfs/hpchome/ppaluoja/bioinformaatika/projekt/BioinformaticsProject/cram/*.cram"

for f in $all; do
	samtools index $f 
done