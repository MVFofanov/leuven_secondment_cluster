#!/bin/bash

#SBATCH --job-name=gtdbtk_de_novo_wf

#SBATCH --time=3-00:00:00 # days-hh:mm:ss
#SBATCH --partition=standard
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=80
#SBATCH --mem=240GB # 4GB

#SBATCH --output=/home/zo49sog/crassvirales/leuven_secondment/slurm/results/gtdbtk/result_%x.%j.txt

date;hostname;pwd

source /vast/groups/VEO/tools/anaconda3/etc/profile.d/conda.sh && conda activate gtdbtk_v2.1.1

working_dir="/home/zo49sog/crassvirales/leuven_secondment"
input_directory="${working_dir}/hive_analysis/filtered_bins"
output_directory="${working_dir}/hive_analysis/filtered_bins_gtdbtk_de_novo"

cd "${working_dir}"

gtdbtk de_novo_wf --genome_dir "${input_directory}" --bacteria --outgroup_taxon p__Patescibacteria \
	--out_dir "${output_directory}" --cpus 80 --force --extension fa

gtdbtk de_novo_wf --genome_dir "${input_directory}" --archaea --outgroup_taxon p__Altiarchaeota \
	--out_dir "${output_directory}" --cpus 80 --force --extension fa

conda deactivate

date

