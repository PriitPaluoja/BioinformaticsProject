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

fasta_index="/gpfs/hpchome/a72094/hpc/annotations/GRCh38/Homo_sapiens.GRCh38.dna.primary_assembly.fa"

mkdir cram

bams="ls -l mapped/*.bam"

for f in $bams; do
	base=$(basename $f)
	samtools view -C -T $fasta_index  $f > cram/${base%.bam}.cram
done
