#!/bin/bash

#SBATCH --job-name="${1}"
#SBATCH --time=12:00:00
#SBATCH --partition=interactive
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=90
#SBATCH --mem=240GB
#SBATCH --mail-user=mikhail.v.fofanov@gmail.com
#SBATCH --mail-type=ALL
#SBATCH --output="${4}/result_%x.%j.log"

date
hostname
pwd

source /home/zo49sog/mambaforge/etc/profile.d/conda.sh
conda activate

working_dir="/home/zo49sog/crassvirales/leuven_secondment"

#output_log="${log_directory}/result_%x.%j.log"

threads=90

reads_directory="/home/zo49sog/crassvirales/leuven_secondment/read/${3}"

bbmap_directory="${working_dir}/bbmap_results_all"
metabat_directory="${working_dir}/metabat_results_all"
checkm_directory="${working_dir}/checkm_results_all"

cd "${working_dir}"

mkdir -p "${bbmap_directory}/${3}"
mkdir -p "${metabat_directory}/${3}"
mkdir -p "${checkm_directory}/${3}"

/home/groups/VEO/tools/bbmap/v39.06/bbmap.sh ref="${2}" \
            in="${reads_directory}/${3}_e.ExBee.ExHuman_modified_R1.fastq.gz" \
            in2="${reads_directory}/${3}_e.ExBee.ExHuman_modified_R2.fastq.gz" \
            out="${bbmap_directory}/${3}/mapped.bam" \
            threads=${threads} \
            scafstats="${bbmap_directory}/${3}/scafstats.txt" \
            covstats="${bbmap_directory}/${3}/covstats.txt" \
            covhist="${bbmap_directory}/${3}/covhist.txt" \
            basecov="${bbmap_directory}/${3}/basecov.txt" \
            bincov="${bbmap_directory}/${3}/bincov.txt"

samtools sort "${bbmap_directory}/${3}/mapped.bam" -o "${bbmap_directory}/${3}/mapped_sorted.bam"

rm "${bbmap_directory}/${3}/mapped.bam"

cd "${metabat_directory}/${3}"

/home/groups/VEO/tools/metabat/v2/bin/runMetaBat.sh "$2" \
        "${bbmap_directory}/${3}/mapped_sorted.bam"

# CheckM analysis
source /vast/groups/VEO/tools/anaconda3/etc/profile.d/conda.sh && conda activate checkm_v1.2.2

# Find the subdirectory within ${metabat_directory}/${sample} and trim whitespace
sub_directory=$(find "${metabat_directory}/${3}" -mindepth 1 -maxdepth 1 -type d | head -n 1)

# Check if a subdirectory was found
if [ -n "$sub_directory" ]; then
    checkm lineage_wf "${sub_directory}" "${checkm_directory}/${3}" -t ${threads} -x fa
else
    echo "Error: Subdirectory not found in ${metabat_directory}/${3}"
fi

conda deactivate
conda deactivate

date

