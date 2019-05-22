#!/bin/bash
#SBATCH --time=24:00:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=rain.vagel@gmail.com
#SBATCH -J HISAT
#SBATCH -N 1
#SBATCH --ntasks-per-node=1
#SBATCH --mem=9000
#SBATCH --cpus-per-task=10

module load java-1.8.0_40
module load jdk-1.8.0_25

source activate rain_bio_project

export JAVA_OPTS=-Xmx1500m

# Moving to the Bazam folder
cd /gpfs/hpchome/ppaluoja/bioinformaatika/projekt/BioinformaticsProject/bazam

./gradlew clean jar
