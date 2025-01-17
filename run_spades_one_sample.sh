#!/bin/bash

#SBATCH --job-name=metaspades_bee_gut_metagenome_assembly_BE_16556_aut_ile

#SBATCH --time=12:00:00 # days-hh:mm:ss
#SBATCH --partition=interactive
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=95
#SBATCH --mem=250GB # 4GB

#SBATCH --mail-user=mikhail.v.fofanov@gmail.com
#SBATCH --mail-type=ALL

#SBATCH --output=result_%x.%j.txt

date;hostname;pwd

source /home/groups/VEO/tools/anaconda3/etc/profile.d/conda.sh

working_dir="/home/zo49sog/crassvirales/leuven_secondment/"
input_directory="${working_dir}/read"
output_directory="${working_dir}/metaspades_results_all/BE_16556_aut_ile"

cd "${working_dir}"

/home/groups/VEO/tools/SPAdes/v3.15.5/metaspades.py \
	-1 "${input_directory}/BE_16556_aut_ile/BE_16556_aut_ile_e.ExBee.ExHuman_modified_R1.fastq.gz" \
	-2 "${input_directory}/BE_16556_aut_ile/BE_16556_aut_ile_e.ExBee.ExHuman_modified_R2.fastq.gz" \
	-t 95 -m 250 \
	-o "$output_directory"

conda deactivate

date

