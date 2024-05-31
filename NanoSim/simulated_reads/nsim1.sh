#!/bin/bash
#SBATCH --job-name=nanosim_jobS1
#SBATCH --output=/home/lelshura/scratch/nanosim_output/nanosim_jobS1.out
#SBATCH --error=/home/lelshura/scratch/nanosim_output/nanosim_jobS1.err
#SBATCH --time=01:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=10
#SBATCH --mem=10G

# Load necessary modules
module load python/3.7.0

# Activate conda environment if needed
source /home/lelshura/miniconda3/etc/profile.d/conda.sh
conda activate nanosim_env

# Log job start
echo "Job started at $(date)" >> nanosim_jobS1.log
echo "Using Python from $(which python)" >> nanosim_jobS1.log

# Add HTSeq to PYTHONPATH
export PYTHONPATH="/home/lelshura/miniconda3/envs/nanosim_env/lib/python3.7/site-packages:$PYTHONPATH"

# Log current directory and environment variables for debugging
echo "Current directory: $(pwd)" >> /home/lelshura/scratch/nanosim_output/nanosim_jobS1.log
echo "Environment variables: $(env)" >> /home/lelshura/scratch/nanosim_output/nanosim_jobS1.log

# Run the Nanosim command
/home/lelshura/BINF6999/NanoSim/src/simulator.py metagenome \
-gl /home/lelshura/BINF6999/S1/scenario-1_genome_list.tsv \
-a /home/lelshura/BINF6999/S1/scenario-1_abundance_list.tsv \
-dl /home/lelshura/BINF6999/S1/scenario-1-dna_type.tsv \
-c /home/lelshura/BINF6999/metagenome_ERR3152366_Log/training \
-o /home/lelshura/scratch/nanosim_output/Scenario1 --seed 123 -b guppy --fastq --chimeric -t 28

# Log job end
echo "Job ended at $(date)" >> nanosim_jobS1.log
