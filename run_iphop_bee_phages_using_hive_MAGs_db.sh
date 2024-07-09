#!/bin/bash

#SBATCH --job-name=iphop_bee_virome_with_custom_db

#SBATCH --time=3-00:00:00 # days-hh:mm:ss
#SBATCH --partition=standard
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=90
#SBATCH --mem=240GB # 4GB

#SBATCH --output=/home/zo49sog/crassvirales/leuven_secondment/slurm/results/iphop/result_%x.%j.txt

date;hostname;pwd

source /vast/groups/VEO/tools/anaconda3/etc/profile.d/conda.sh && conda activate iphop_v1.3.3

working_dir="/home/zo49sog/crassvirales/leuven_secondment"
input_dir="${working_dir}/BPhage/bphage_ALL_1kb_phages.fasta"

iphop_db="${working_dir}/hive_analysis/filtered_bins_iphop_db"

output_dir="${working_dir}/hive_analysis/filtered_bins_iphop_db_results"

cd "${working_dir}"

iphop predict --fa_file "${input_dir}" --db_dir "${iphop_db}" --out_dir "${output_dir}" --num_threads 90

conda deactivate

date

