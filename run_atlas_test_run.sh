#!/bin/bash

#SBATCH --job-name=atlas_test_run_genomes

#SBATCH --time=12:00:00 # days-hh:mm:ss
#SBATCH --partition=interactive
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=2GB # 4GB

#SBATCH --mail-user=mikhail.v.fofanov@gmail.com
#SBATCH --mail-type=ALL

#SBATCH --output=/home/zo49sog/crassvirales/leuven_secondment/slurm/results/%x/result_%x.%j.txt

date;hostname;pwd

source /home/groups/VEO/tools/anaconda3/etc/profile.d/conda.sh && conda activate atlas_v2.0.6

working_dir="/home/zo49sog/crassvirales/leuven_secondment/atlas_new/test/"

mkdir -p "${working_dir}"

cd "${working_dir}"

input_directory="../read/"

#atlas init --db-dir atlas_databases "${input_directory}"

atlas run genomes --profile cluster -w "${working_dir}" \
	-c "/home/zo49sog/crassvirales/leuven_secondment/atlas_new/test/config.yaml" 

conda deactivate

date
