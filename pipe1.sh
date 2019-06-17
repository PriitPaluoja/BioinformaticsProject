#!/bin/bash
#SBATCH --time=24:00:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=priitpaluoja@gmail.com
#SBATCH -J HISAT
#SBATCH -N 1
#SBATCH --ntasks-per-node=1
#SBATCH --mem=40000
#SBATCH --cpus-per-task=20
module load python-3.6.3
module load samtools-1.9

source activate bio


all="/gpfs/hpchome/a72094/hpc/datasets/open_access/GEUVADIS/fastq/ERR188021_1.fastq.gz"
features="/gpfs/hpc/home/a72094/teaching/MTAT.03.239_Bioinformatics/software/bin/"
annotations="/gpfs/hpchome/ppaluoja/bioinformaatika/projekt/BioinformaticsProject/annotations/Homo_sapiens.GRCh38.91.gtf"
fasta_index="/gpfs/hpchome/a72094/hpc/annotations/GRCh38/Homo_sapiens.GRCh38.dna.primary_assembly.fa"
hisat_index="/gpfs/hpchome/a72094/hpc/annotations/GRCh38/hisat2_index/Homo_sapiens.GRCh38.dna.primary_assembly"
soft="/gpfs/hpchome/ppaluoja/bioinformaatika/projekt/BioinformaticsProject/crumble/crumble"

for f in $all; do
	first=$f
	second=${first%1.fastq.gz}2.fastq.gz
	base=$(basename $first)
	out=${base%_1.fastq.gz}.bam
	
	# FASTQ -> HISAT2 -> featureCounts
	#hisat2 -q -x $hisat_index -1 "$first" -2 "$second" | samtools view -Sb -@ 20 | samtools sort -@ 20 > $base.sorted.bam
	#samtools index $base.sorted.bam 
	# $features/featureCounts -p -C -D 5000 -d 50 -s2 -a $annotations -o $base.results.1.counts $base.sorted.bam
	
	# Fastq -> HISAT2 -> CRAM -> FASTQ -> HISAT2 -> featureCounts
	#samtools view -C -T $fasta_index $base.sorted.bam -@ 20 > $base.cram
	#samtools collate -o $base.collated.bam $base.cram
	#samtools fastq -F 2816 --reference $fasta_index -1 $base.cram.1.fastq.gz -2 $base.cram.2.fastq.gz $base.collated.bam

	#hisat2 -q -x $hisat_index -1 $base.cram.1.fastq.gz -2 $base.cram.2.fastq.gz | samtools view -Sb -@ 20 | samtools sort -@ 20 > $base.new.sorted.bam
	#samtools index $base.new.sorted.bam
	#$features/featureCounts -p -C -D 5000 -d 50 -s2 -a $annotations -o $base.results.2.counts $base.new.sorted.bam
	
	# CRAM -> Crumble -> lossy cram -> fastq -> hisat2 -> featureCounts
	samtools view -C -T $fasta_index $base.sorted.bam -@ 20 | $soft -I CRAM -O cram,lossy_names,seqs_per_slice=100000 > $base.lossy.cram
	samtools index $base.lossy.cram
	samtools collate $base.lossy.cram -o $base.collated2.bam 
	samtools fastq -F 2816 --reference $fasta_index -1 $base.lossy.1.fastq.gz -2 $base.lossy.2.fastq.gz $base.collated2.bam 
	
	hisat2 -q -x $hisat_index -1 $base.lossy.1.fastq.gz -2 $base.lossy.2.fastq.gz | samtools view -Sb -@ 20 | samtools sort -@ 20 > $base.lossy.sorted.bam
	samtools index $base.lossy.sorted.bam
	$features/featureCounts -p -C -D 5000 -d 50 -s2 -a $annotations -o $base.results.3.counts $base.lossy.sorted.bam
done

