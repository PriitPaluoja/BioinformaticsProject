#!/bin/bash
#SBATCH --time=80:00:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=priitpaluoja@gmail.com
#SBATCH -J HISAT
#SBATCH -N 1
#SBATCH --ntasks-per-node=1
#SBATCH --mem=9000
#SBATCH --cpus-per-task=10
module load python-3.6.3

# conda create --name myenv
source activate bio

# https://ccb.jhu.edu/software/hisat2/index.shtml
# conda install -c bioconda hisat2

index="/gpfs/hpchome/a72094/hpc/annotations/GRCh38/hisat2_index/Homo_sapiens.GRCh38.dna.primary_assembly"
mkdir mapped

# Manual run of 1 sample:
# first="/gpfs/hpchome/a72094/hpc/datasets/open_access/GEUVADIS/fastq/ERR188021_1.fastq.gz"
# second="/gpfs/hpchome/a72094/hpc/datasets/open_access/GEUVADIS/fastq/ERR188021_2.fastq.gz"
# out="test2.sam"
# hisat2 -S "mapped/$out" -q -x "$index" --threads "10" -1 "$first" -2 "$second"

# Run all the samples:
all="ls -l /gpfs/hpchome/a72094/hpc/datasets/open_access/GEUVADIS/fastq/*_1.fastq.gz"

for f in $all; do
	first=$f
	second=${first%1.fastq.gz}2.fastq.gz
	base=$(basename $first)
	out=${base%_1.fastq.gz}.sam
	hisat2 -1 $first -2 $second -S mapped/$out -q -x $index
done
