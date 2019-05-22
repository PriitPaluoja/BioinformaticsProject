#!/bin/bash
#SBATCH --time=48:00:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=priitpaluoja@gmail.com
#SBATCH -J LOSSY
#SBATCH -N 1
#SBATCH --ntasks-per-node=1
#SBATCH --mem=8000
#SBATCH --cpus-per-task=1

module load htslib-1.9
module load samtools-1.9

fasta_index="/gpfs/hpchome/a72094/hpc/annotations/GRCh38/Homo_sapiens.GRCh38.dna.primary_assembly.fa"
soft="/gpfs/hpchome/ppaluoja/bioinformaatika/projekt/BioinformaticsProject/crumble/crumble"

bams="ls -l mapped/*.bam"

for f in $bams; do
	base=$(basename $f)
	samtools sort $f | samtools view -C -T $fasta_index | $soft -I CRAM -O cram,lossy_names,seqs_per_slice=100000 > lossy/${base%.bam}.lossy.cram
	samtools index lossy/${base%.bam}.lossy.cram
done

