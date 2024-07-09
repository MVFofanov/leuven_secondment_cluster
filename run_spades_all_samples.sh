#!/bin/bash

working_dir="/home/zo49sog/crassvirales/leuven_secondment/"
input_directory="${working_dir}/read"
output_main_directory="${working_dir}/metaspades_results_all"
log_directory="${working_dir}/slurm/results"

# Create log directory if it doesn't exist
mkdir -p "$log_directory"

# Loop through subdirectories in input_directory
for subdirectory in "${input_directory}"/*; do
    if [ -d "$subdirectory" ]; then
        output_directory="${output_main_directory}/$(basename "$subdirectory")"
        job_name="metaspades_$(basename "$subdirectory")"
        output_log="${log_directory}/result_$(basename "$subdirectory").log"

        echo "Submitting job for $subdirectory"
        sbatch <<EOT
#!/bin/bash

#SBATCH --job-name=${job_name}
#SBATCH --time=12:00:00
#SBATCH --partition=interactive
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=95
#SBATCH --mem=250GB
#SBATCH --mail-user=mikhail.v.fofanov@gmail.com
#SBATCH --mail-type=ALL
#SBATCH --output=${output_log}

date
hostname
pwd

source /home/groups/VEO/tools/anaconda3/etc/profile.d/conda.sh

cd "${working_dir}"

/home/groups/VEO/tools/SPAdes/v3.15.5/metaspades.py \
        -1 "${subdirectory}/"*modified_R1.fastq.gz \
        -2 "${subdirectory}/"*modified_R2.fastq.gz \
        -t 95 -m 250 \
        -o "${output_directory}"

conda deactivate

date
EOT
        echo "Job submitted for $subdirectory"
    fi
done

