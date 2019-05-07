#!/bin/bash
#SBATCH --time=24:00:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=priitpaluoja@gmail.com
#SBATCH -J HISAT
#SBATCH -N 1
#SBATCH --ntasks-per-node=1
#SBATCH --mem=9000
#SBATCH --cpus-per-task=1

module load jdk-1.8.0_25

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


java -Xmx5000m -jar bazam.jar

