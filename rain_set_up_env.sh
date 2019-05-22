#!/bin/bash
#SBATCH --time=24:00:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=rain.vagel@gmail.com
#SBATCH -J HISAT
#SBATCH -N 1
#SBATCH --ntasks-per-node=1
#SBATCH --mem=9000
#SBATCH --cpus-per-task=10

module load python-3.6.3

# Creating the conda environment
# conda create --name rain_bio_project

# Activating conda environment
# source activate rain_bio_project

# Moving to the Crumble folder
cd /gpfs/hpchome/ppaluoja/bioinformaatika/projekt/BioinformaticsProject/crumble

# Install the necessary files and create the configure script
#autoreconf -i


# Compiling Crumble files
./configure
make
