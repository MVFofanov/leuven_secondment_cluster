#!/bin/bash

working_dir="/home/zo49sog/crassvirales/leuven_secondment"
input_directory="${working_dir}/metaspades_results_all"
output_main_directory="${working_dir}/metaquast_results_all"
log_directory="${working_dir}/slurm/metaquast"

# Create log directory if it doesn't exist
mkdir -p "$log_directory"

# Loop through subdirectories in input_directory
for subdirectory in "${input_directory}"/*; do
    if [ -d "$subdirectory" ]; then
        output_directory="${output_main_directory}/$(basename "$subdirectory")"
        job_name="metaquast_$(basename "$subdirectory")"
        output_log="${log_directory}/result_$(basename "$subdirectory").log"
	scaffolds_file="${subdirectory}/scaffolds.fasta"

        echo "Submitting job for $subdirectory"
        sbatch <<EOT
#!/bin/bash

#SBATCH --job-name=${job_name}
#SBATCH --time=12:00:00
#SBATCH --partition=interactive
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=80
#SBATCH --mem=240GB
#SBATCH --mail-user=mikhail.v.fofanov@gmail.com
#SBATCH --mail-type=ALL
#SBATCH --output=${output_log}

date
hostname
pwd

source /home/groups/VEO/tools/anaconda3/etc/profile.d/conda.sh

cd "${working_dir}"

#gzip -c "${scaffolds_file}" > "${scaffolds_file}.gz"

/home/groups/VEO/tools/metabat/v2/bin/metabat2 -i "${scaffolds_file}"\
	

python3 /home/groups/VEO/tools/quast/v5.2.0/metaquast.py \
        -o "${output_directory}" \
        -t 80 -L --mgm \
	"${scaffolds_file}"

conda deactivate

date
EOT
        echo "Job submitted for $subdirectory"
    fi
done

