#!/bin/bash

working_dir="/home/zo49sog/crassvirales/leuven_secondment"
read_directory="/home/zo49sog/crassvirales/leuven_secondment/read_hives"

#metaspades_directory="${working_dir}/metaspades_results_all"
log_directory="${working_dir}/slurm/results/hive_analysis"

# Create log directory if it doesn't exist
mkdir -p "$log_directory"

# Loop through subdirectories in input_directory
for subdirectory in "${read_directory}"/*; do
    if [ -d "$subdirectory" ]; then
        #scaffolds_file="${subdirectory}/scaffolds.fasta"
        sample="$(basename "$subdirectory")"
        job_name="${sample}_analysis"
        #output_log="${log_directory}/result_%x.%j.log"

        echo "Submitting job for $subdirectory"
        sbatch run_submit_hive_genome_assembly_and_binning_jobs.sh "$job_name" "$sample" "$log_directory"
        echo "Job submitted for $subdirectory"
    fi
done

