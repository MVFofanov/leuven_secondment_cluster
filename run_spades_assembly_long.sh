#!/bin/bash

#SBATCH --job-name=metaspades_bee_gut_metagenome_assembly_only

#SBATCH --time=14-00:00:00 # days-hh:mm:ss
#SBATCH --partition=long
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=90
#SBATCH --mem=240GB # 4GB

#SBATCH --mail-user=mikhail.v.fofanov@gmail.com
#SBATCH --mail-type=ALL

#SBATCH --output=result_%x.%j.txt

date;hostname;pwd

source /home/groups/VEO/tools/anaconda3/etc/profile.d/conda.sh

working_dir="/home/zo49sog/crassvirales/leuven_secondment/"
input_directory="${working_dir}/metaspades_results"
output_directory="${input_directory}/assembly_results_long"

cd "${working_dir}"

/home/groups/VEO/tools/SPAdes/v3.15.5/metaspades.py \
	-1 "${input_directory}/corrected/all_modified_R1.fastq.00.0_0.cor.fastq.gz" \
	-2 "${input_directory}/corrected/all_modified_R2.fastq.00.0_0.cor.fastq.gz" \
	-s "${input_directory}/corrected/all_modified_R_unpaired.00.0_0.cor.fastq.gz" \
	--only-assembler --checkpoints all \
	-t 90 -m 240 \
	-o "$output_directory"

conda deactivate

date

