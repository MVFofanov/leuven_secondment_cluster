#!/bin/bash

#SBATCH --job-name=metaspades_bee_gut_metagenome_assembly_only_continue

#SBATCH --time=3-00:00:00 # days-hh:mm:ss
#SBATCH --partition=fat
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=140
#SBATCH --mem=4000GB # 4GB

#SBATCH --mail-user=mikhail.v.fofanov@gmail.com
#SBATCH --mail-type=ALL

#SBATCH --output=result_%x.%j.txt

date;hostname;pwd

source /home/groups/VEO/tools/anaconda3/etc/profile.d/conda.sh

working_dir="/home/zo49sog/crassvirales/leuven_secondment/"
input_directory="${working_dir}/metaspades_results"
output_directory="${input_directory}/assembly_results"

cd "${working_dir}"

/home/groups/VEO/tools/SPAdes/v3.15.5/metaspades.py --restart-from last -t 140 -m 4000 -o "$output_directory"

conda deactivate

date

