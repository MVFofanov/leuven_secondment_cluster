#!/bin/bash

#SBATCH --job-name=drep

#SBATCH --time=12:00:00 # days-hh:mm:ss
#SBATCH --partition=interactive
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=80
#SBATCH --mem=240GB # 4GB

#SBATCH --output=/home/zo49sog/crassvirales/leuven_secondment/slurm/results/drep/result_%x.%j.txt

date;hostname;pwd

source /home/groups/VEO/tools/anaconda3/etc/profile.d/conda.sh

conda activate /vast/groups/VEO/tools/anaconda3/envs/drep_v3.4.3

working_dir="/home/zo49sog/crassvirales/leuven_secondment"
input_directory="${working_dir}/hive_analysis/filtered_bins"
output_directory="${working_dir}/hive_analysis/filtered_bins_drep"

cd "${working_dir}"

dRep dereplicate "${input_directory}" \
       	-g /home/zo49sog/crassvirales/leuven_secondment/hive_analysis/filtered_bins/*.fa

conda deactivate

date

