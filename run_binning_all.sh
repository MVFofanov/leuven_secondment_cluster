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
        #output_directory="${output_main_directory}/$(basename "$subdirectory")"
        sample="$(basename "$subdirectory")"
	job_name="binning_${sample}"
        #output_log="${log_directory}/result_%x.%j.log"

        echo "Submitting job for $subdirectory"
        sbatch <<EOT
#!/bin/bash

#SBATCH --job-name=${job_name}
#SBATCH --time=12:00:00
#SBATCH --partition=interactive
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=90
#SBATCH --mem=240GB
#SBATCH --mail-user=mikhail.v.fofanov@gmail.com
#SBATCH --mail-type=ALL
#SBATCH --output="${log_directory}/result_%x.%j.log"

date
hostname
pwd

#source /home/groups/VEO/tools/anaconda3/etc/profile.d/conda.sh
source /home/zo49sog/mambaforge/etc/profile.d/conda.sh

conda activate

working_dir="/home/zo49sog/crassvirales/leuven_secondment"

#sample="BE_16556_aut_ile"
threads=90

reads_directory="/home/zo49sog/crassvirales/leuven_secondment/read/${sample}"

#metaspades_directory="${working_dir}/metaspades_results_all"
#subdirectory="${metaspades_directory}/${sample}"
#scaffolds_file="${subdirectory}/scaffolds.fasta"

bbmap_directory="${working_dir}/bbmap_results_all"
metabat_directory="${working_dir}/metabat_results_all"
checkm_directory="${working_dir}/checkm_results_all"

cd "${working_dir}"

mkdir -p "${bbmap_directory}/${sample}"
mkdir -p "${metabat_directory}/${sample}"
mkdir -p "${checkm_directory}/${sample}"

/home/groups/VEO/tools/bbmap/v39.06/bbmap.sh ref="${scaffolds_file}" \
            in="${reads_directory}/${sample}_e.ExBee.ExHuman_modified_R1.fastq.gz" \
            in2="${reads_directory}/${sample}_e.ExBee.ExHuman_modified_R2.fastq.gz" \
            out="${bbmap_directory}/${sample}/mapped.bam" \
            threads=${threads} \
            scafstats="${bbmap_directory}/${sample}/scafstats.txt" \
            covstats="${bbmap_directory}/${sample}/covstats.txt" \
            covhist="${bbmap_directory}/${sample}/covhist.txt" \
            basecov="${bbmap_directory}/${sample}/basecov.txt" \
            bincov="${bbmap_directory}/${sample}/bincov.txt"

samtools sort "${bbmap_directory}/${sample}/mapped.bam" -o "${bbmap_directory}/${sample}/mapped_sorted.bam"

rm "${bbmap_directory}/${sample}/mapped.bam"


# genomic binning via metabat
cd "${metabat_directory}/${sample}"

/home/groups/VEO/tools/metabat/v2/bin/runMetaBat.sh "${scaffolds_file}" \
        "${bbmap_directory}/${sample}/mapped_sorted.bam"

# CheckM analysis
source /vast/groups/VEO/tools/anaconda3/etc/profile.d/conda.sh && conda activate checkm_v1.2.2

# Find the subdirectory within ${metabat_directory}/${sample} and trim whitespace
sub_directory=$(find "${metabat_directory}/${sample}" -mindepth 1 -maxdepth 1 -type d | head -n 1)

# Check if a subdirectory was found
if [ -n "$sub_directory" ]; then
    checkm lineage_wf "${sub_directory}" "${checkm_directory}/${sample}" -t ${threads} -x fa
else
    echo "Error: Subdirectory not found in ${metabat_directory}/${sample}"
fi

conda deactivate
conda deactivate

date

EOT
        echo "Job submitted for $subdirectory"
    fi
done

