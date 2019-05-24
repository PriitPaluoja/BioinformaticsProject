#!/bin/bash
#SBATCH --time=13:00:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=priitpaluoja@gmail.com
#SBATCH -J PIPELINE1
#SBATCH -N 1
#SBATCH --ntasks-per-node=1
#SBATCH --mem=1000
#SBATCH --cpus-per-task=1

module load python-3.6.3
module load samtools-1.9
module load htslib-1.9

source activate bio

export crumble="/gpfs/hpchome/ppaluoja/bioinformaatika/projekt/BioinformaticsProject/crumble/crumble"

hisat_db="/gpfs/hpchome/ppaluoja/bioinformaatika/projekt/BioinformaticsProject/annotations/Homo_sapiens.GRCh38.dna.primary_assembly"
fasta_ref="/gpfs/hpchome/ppaluoja/bioinformaatika/projekt/BioinformaticsProject/annotations/Homo_sapiens.GRCh38.dna.primary_assembly.fa"
input=/gpfs/hpchome/a72094/hpc/datasets/open_access/GEUVADIS/fastq/ERR188021_{1,2}.fastq.gz
#input=/gpfs/hpchome/ppaluoja/bioinformaatika/projekt/BioinformaticsProject/mock/file{1,2}.fastq

nextflow pipeline1.nf --hisat2_index $hisat_db --fasta_ref $fasta_ref --reads $input
