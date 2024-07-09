#!/bin/bash

working_dir="/home/zo49sog/crassvirales/leuven_secondment"
metaspades_directory="${working_dir}/metaspades_results_all"
log_directory="${working_dir}/slurm/results/binning"

# Create log directory if it doesn't exist
mkdir -p "$log_directory"

# Loop through subdirectories in input_directory
for subdirectory in "${metaspades_directory}"/*; do
    if [ -d "$subdirectory" ]; then
        scaffolds_file="${subdirectory}/scaffolds.fasta"
        sample="$(basename "$subdirectory")"
        job_name="binning_${sample}"
        #output_log="${log_directory}/result_%x.%j.log"

        echo "Submitting job for $subdirectory"
        sbatch run_submit_binning_jobs.sh "$job_name" "$scaffolds_file" "$sample" "$log_directory"
        echo "Job submitted for $subdirectory"
    fi
done

