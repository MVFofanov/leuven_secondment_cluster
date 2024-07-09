#!/bin/bash

#SBATCH --job-name=gtdbtk

#SBATCH --time=12:00:00 # days-hh:mm:ss
#SBATCH --partition=interactive
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=80
#SBATCH --mem=240GB # 4GB

#SBATCH --output=/home/zo49sog/crassvirales/leuven_secondment/slurm/results/gtdbtk/result_%x.%j.txt

date;hostname;pwd

source /vast/groups/VEO/tools/anaconda3/etc/profile.d/conda.sh && conda activate gtdbtk_v2.1.1

working_dir="/home/zo49sog/crassvirales/leuven_secondment"
input_directory="${working_dir}/hive_analysis/filtered_bins"
output_directory="${working_dir}/hive_analysis/filtered_bins_gtdbtk"

cd "${working_dir}"

gtdbtk classify_wf --genome_dir "${input_directory}" --out_dir "${output_directory}" \
	--cpus 80 --force --extension fa

conda deactivate

date

