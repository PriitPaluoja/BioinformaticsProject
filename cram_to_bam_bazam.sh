#!/bin/bash
#SBATCH --time=48:00:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=joonas.kriisk@gmail.com
#SBATCH -J cram_to_bam
#SBATCH -N 1
#SBATCH --ntasks-per-node=1
#SBATCH --mem=24000
#SBATCH --cpus-per-task=1
module load python-3.6.3
module load samtools-1.9
module load jdk-1.8.0_25

# Create env, install hisat2
source activate bio

#usage: java -jar bazam.jar -bam <bam> -L <regions>
# -bam <arg>           BAM file to extract read pairs from
# -dr <arg>            Specify a read name to debug: processing of the read
#                      will be verbosey printed
# -f,--filter <arg>    Filter using specified groovy expression
# -gene <arg>          Extract region of given gene
# -h,--help            Show help
# -L,--regions <arg>   Regions to include r	eads (and mates of reads) from
# -n <arg>             Concurrency parameter (4)
# -namepos             Add original position to the read names
# -o <arg>             Output file
# -pad <arg>           Amount to pad regions by (0)
# -r1 <arg>            Output for R1 if extracting FASTQ in separate files
# -r2 <arg>            Output for R2 if extracting FASTQ in separate files
# -s <arg>             Sharding factor: format <n>,<N>: output only reads
#                      belonging to shard n of N

# srun --pty --time=01:00:00 --mem=8000 bash

fasta=/gpfs/hpchome/ppaluoja/bioinformaatika/projekt/BioinformaticsProject/annotations/Homo_sapiens.GRCh38.dna.primary_assembly.fa
index=/gpfs/hpchome/a72094/hpc/annotations/GRCh38/hisat2_index/Homo_sapiens.GRCh38.dna.primary_assembly

cram_dir="/gpfs/hpchome/ppaluoja/bioinformaatika/projekt/BioinformaticsProject/cram/"

for entry in "$cram_dir"*[5-9].cram;
do
	base=$(basename $entry)
	final_name=$(echo $base| cut -d'.' -f 1)
	out=${final_name}.bam
	java -Dsamjdk.reference_fasta="$fasta" -Xmx20G -jar bazam.jar -bam "$entry" | hisat2 -q -x "$index" --threads "10" -U - | samtools view -Sb > "task3/bam/$out"
done

	