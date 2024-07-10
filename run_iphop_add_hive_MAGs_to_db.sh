#!/bin/bash

#SBATCH --job-name=iphop_add_hive_mags_to_db

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

input_dir_mags="${working_dir}/hive_analysis/filtered_bins/hive_bins"
input_dir_gtdbtk_results="${working_dir}/hive_analysis/filtered_bins_gtdbtk_de_novo"

iphop_db="/work/groups/VEO/databases/iphop/v20240325/Aug_2023_pub_rw/"

output_dir="${working_dir}/hive_analysis/filtered_bins_iphop_db"

cd "${working_dir}"

iphop add_to_db --fna_dir "${input_dir_mags}" --gtdb_dir "${input_dir_gtdbtk_results}" --out_dir "${output_dir}" --db_dir "${iphop_db}" --num_threads 90

conda deactivate

date

