#!/bin/bash

#SBATCH --job-name=metaquast

#SBATCH --time=12:00:00 # days-hh:mm:ss
#SBATCH --partition=interactive
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=95
#SBATCH --mem=240GB # 4GB

#SBATCH --mail-user=mikhail.v.fofanov@gmail.com
#SBATCH --mail-type=ALL

#SBATCH --output=slurm/results/metaquast/result_%x.%j.txt

date;hostname;pwd

source /home/groups/VEO/tools/anaconda3/etc/profile.d/conda.sh

working_dir="/home/zo49sog/crassvirales/leuven_secondment"
input_directory="${working_dir}/metaspades_results_all"
output_directory="${working_dir}/results_quast"

cd "${working_dir}"

# Find all scaffolds.fasta files and save them to an array
scaffold_files=($(find "${input_directory}" -type f -name "scaffolds.fasta"))

# Run MetaQUAST with all scaffold files as positional arguments
python3 /home/groups/VEO/tools/quast/v5.2.0/metaquast.py -o "${output_directory}" \
        -t 95 -L --mgm "${scaffold_files[@]}"

conda deactivate

date

