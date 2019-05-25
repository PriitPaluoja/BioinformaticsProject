#!/bin/bash
#SBATCH --time=25:00:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=priitpaluoja@gmail.com
#SBATCH -J PIPELINE2
#SBATCH -N 1
#SBATCH --ntasks-per-node=1
#SBATCH --mem=500
#SBATCH --cpus-per-task=1

module load python-3.6.3
module load samtools-1.9
module load htslib-1.9
module load jdk-1.8.0_25

source activate bio

export bazam="/gpfs/hpchome/ppaluoja/bioinformaatika/projekt/BioinformaticsProject/bazam.jar"

hisat_db="/gpfs/hpchome/ppaluoja/bioinformaatika/projekt/BioinformaticsProject/annotations/Homo_sapiens.GRCh38.dna.primary_assembly"
fasta_ref="/gpfs/hpchome/ppaluoja/bioinformaatika/projekt/BioinformaticsProject/annotations/Homo_sapiens.GRCh38.dna.primary_assembly.fa"
crams="/gpfs/hpchome/ppaluoja/bioinformaatika/projekt/BioinformaticsProject/cram/test/"


nextflow pipeline2.nf --hisat2_index $hisat_db --fasta_ref $fasta_ref --crams $crams
