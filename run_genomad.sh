#!/bin/bash

#SBATCH --job-name=genomad_hive_mags

#SBATCH --time=12:00:00 # days-hh:mm:ss
#SBATCH --partition=interactive
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=90
#SBATCH --mem=240GB # 4GB

#SBATCH --output=/home/zo49sog/crassvirales/leuven_secondment/slurm/results/genomad/result_%x.%j.txt

date;hostname;pwd

source /vast/groups/VEO/tools/anaconda3/etc/profile.d/conda.sh && conda activate genNomad_v20230721

working_dir="/home/zo49sog/crassvirales/leuven_secondment"

cd "${working_dir}"


# Set the input and output directories
INPUT_DIR="${working_dir}/hive_analysis/filtered_bins/hive_bins"
OUTPUT_DIR="${working_dir}/hive_analysis/genomad_results"
DATABASE="/work/groups/VEO/databases/geNomad/v1.3"

# Set the number of CPUs and memory to use
CPUS=90
MEMORY=240

# Create the output directory if it doesn't exist
mkdir -p ${OUTPUT_DIR}

# Iterate over all .fa files in the input directory
for FILE in ${INPUT_DIR}/*.fa; do
  # Extract the sample name from the file name
  SAMPLE_NAME=$(basename ${FILE} .fa)
  OUTPUT_PATH="${OUTPUT_DIR}/${SAMPLE_NAME}"

  # Run geNomad
  echo "Running geNomad for ${FILE}"
  genomad end-to-end --cleanup --threads ${CPUS} ${FILE} ${OUTPUT_PATH} ${DATABASE}
  
  # Check if the command was successful
  if [ $? -eq 0 ]; then
    echo "Finished running geNomad for ${FILE}"
  else
    echo "Error running geNomad for ${FILE}"
  fi
done

echo "Prophage prediction completed. Results are saved in ${OUTPUT_DIR}"

date
