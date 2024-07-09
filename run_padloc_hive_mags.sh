#!/bin/bash

#SBATCH --job-name=padloc_hive_bins

#SBATCH --time=3-00:00:00 # days-hh:mm:ss
#SBATCH --partition=standard
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=95
#SBATCH --mem-per-cpu=2GB # 4GB

#SBATCH --output=/home/zo49sog/crassvirales/leuven_secondment/slurm/results/padloc/result_%x.%j.txt

date;hostname;pwd

source /home/zo49sog/miniconda3/etc/profile.d/conda.sh

conda activate

conda activate /home/zo49sog/mambaforge/envs/padloc

cd /home/zo49sog/crassvirales/leuven_secondment

# Set the directory containing *.fna files
input_directory="/home/zo49sog/crassvirales/leuven_secondment/hive_analysis/filtered_bins/hive_bins/"

infernal_dir="/home/zo49sog/crassvirales/leuven_secondment/hive_analysis/padloc/infernal"
crisprdetect_dir="/home/zo49sog/crassvirales/leuven_secondment/hive_analysis/padloc/crisprdetect"
padloc_dir="/home/zo49sog/crassvirales/leuven_secondment/hive_analysis/padloc/padloc"

# Create output directories if they don't exist
mkdir -p "${infernal_dir}"
mkdir -p "${crisprdetect_dir}"
mkdir -p "${padloc_dir}"

# Iterate over all *.fa files in the input directory
for file_path in ${input_directory}*.fa; do
    # Extract file name without extension
    file_name=$(basename "${file_path%.fa}")

    # Step 1: run-infernal
    run-infernal --input "${file_path}" --output "${infernal_dir}/${file_name}_ncrna.tblout"

    # Step 2: run-crisprdetect
    run-crisprdetect --input "${file_path}" --output "${crisprdetect_dir}/${file_name}_crispr"

    # Step 3: padloc
    padloc --fna "${file_path}" --ncrna "${infernal_dir}/${file_name}_ncrna.tblout.formatted" \
	   --crispr "${crisprdetect_dir}/${file_name}_crispr.gff" --cpu 95 \
	   --outdir "${padloc_dir}"
done

conda deactivate
conda deactivate

date

