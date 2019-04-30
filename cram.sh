#!/bin/bash
#SBATCH --time=2:00:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=priitpaluoja@gmail.com
#SBATCH -J CRAM
#SBATCH -N 1
#SBATCH --ntasks-per-node=1
#SBATCH --mem=8000
#SBATCH --cpus-per-task=1

module load jdk-1.8.0_25
module load cramtools-3.0

fasta_index="/gpfs/hpchome/a72094/hpc/annotations/GRCh38/Homo_sapiens.GRCh38.dna.primary_assembly.fa"


mkdir cram


bams="ls -l mapped/*.bam"

for f in $bams; do
	base=$(basename $f)
	#java -Xms512m -Xmx8g -jar cramtools-3.0.jar cram -I $f -O cram/$base.cram --preserve-read-names true --lossless-quality-score true --reference-fasta-file $fasta_index
	java -Xms512m -Xmx8g -jar cramtools-3.0.jar cram -I $f -O cram/$base.cram --reference-fasta-file $fasta_index
done
