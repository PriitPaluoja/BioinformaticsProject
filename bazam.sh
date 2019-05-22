#!/bin/bash
#SBATCH --time=24:00:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=rain.vagel@gmail.com
#SBATCH -J HISAT
#SBATCH -N 1
#SBATCH --ntasks-per-node=1
#SBATCH --mem=20000
#SBATCH --cpus-per-task=1

module load jdk-1.8.0_25
module load python-3.6.3
module load samtools-1.9

source activate rain_bio_project

# conda install -c bioconda hisat2

# mkdir bazam_results

#usage: java -jar bazam.jar -bam <bam> -L <regions>
# -bam <arg>           BAM file to extract read pairs from
# -dr <arg>            Specify a read name to debug: processing of the read
#                      will be verbosey printed
# -f,--filter <arg>    Filter using specified groovy expression
# -gene <arg>          Extract region of given gene
# -h,--help            Show help
# -L,--regions <arg>   Regions to include reads (and mates of reads) from
# -n <arg>             Concurrency parameter (4)
# -namepos             Add original position to the read names
# -o <arg>             Output file
# -pad <arg>           Amount to pad regions by (0)
# -r1 <arg>            Output for R1 if extracting FASTQ in separate files
# -r2 <arg>            Output for R2 if extracting FASTQ in separate files
# -s <arg>             Sharding factor: format <n>,<N>: output only reads
#                      belonging to shard n of N

index="/gpfs/hpchome/a72094/hpc/annotations/GRCh38/hisat2_index/Homo_sapiens.GRCh38.dna.primary_assembly"
reference="/gpfs/hpchome/ppaluoja/bioinformaatika/projekt/BioinformaticsProject/annotations/Homo_sapiens.GRCh38.dna.primary_assembly.fa"


files="ls -l /gpfs/hpchome/ppaluoja/bioinformaatika/projekt/BioinformaticsProject/lossy/*.lossy.cram"

for f in $files; do
  base=$(basename $f)
  java  -Xmx12g -Dsamjdk.reference_fasta=$reference -Xmx8000m \
        -jar bazam.jar -bam "$f" | hisat2 -q -x "$index" --threads "10" -U - | samtools view -Sb > "bazam_results/$base.bam"
done

#java  -Xmx12g -Dsamjdk.reference_fasta=$reference -Xmx8000m \
#      -jar bazam.jar -bam "$file" | hisat2 -q -x "$index" --threads "10" -U - | samtools view -Sb > "bazam_results/ERR188021.bam"
