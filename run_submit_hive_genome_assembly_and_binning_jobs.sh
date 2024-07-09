#!/bin/bash

#SBATCH --job-name="$1"
#SBATCH --time=12:00:00
#SBATCH --partition=interactive
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=90
#SBATCH --mem=240GB
#SBATCH --output="$3/result_%x.%j.log"

date
hostname
pwd

source /home/zo49sog/mambaforge/etc/profile.d/conda.sh
conda activate

working_dir="/home/zo49sog/crassvirales/leuven_secondment"

threads=90
requested_RAM=240

reads_directory="/home/zo49sog/crassvirales/leuven_secondment/read_hives/$2"

hive_analysis="${working_dir}/hive_analysis"

metaspades_directory="${hive_analysis}/metaspades_assembly"
bbmap_directory="${hive_analysis}/bbmap_alignment"
metabat_directory="${hive_analysis}/metabat_binning"
checkm_directory="${hive_analysis}/checkm_qc"

cd "${working_dir}"

mkdir -p "${hive_analysis}"
mkdir -p "${bbmap_directory}/$2"
mkdir -p "${metabat_directory}/$2"
mkdir -p "${checkm_directory}/$2"

#/home/groups/VEO/tools/SPAdes/v3.15.5/metaspades.py \
#        -1 "${reads_directory}/"*modified_R1.fastq.gz \
#        -2 "${reads_directory}/"*modified_R2.fastq.gz \
#        -s "${reads_directory}/"*unpaired.fastq \
#        -t ${threads} -m ${requested_RAM} \
#        --checkpoints all \
#        -o "${metaspades_directory}/$2"

cd "${bbmap_directory}/$2" 

scaffolds_file="${metaspades_directory}/$2/scaffolds.fasta"
/home/groups/VEO/tools/bbmap/v39.06/bbmap.sh ref="${scaffolds_file}" \
            in="${reads_directory}/$2.ExBee.ExHuman_modified_R1.fastq.gz" \
            in2="${reads_directory}/$2.ExBee.ExHuman_modified_R2.fastq.gz" \
            out="${bbmap_directory}/$2/mapped.bam" \
            threads=${threads} \
            scafstats="${bbmap_directory}/$2/scafstats.txt" \
            covstats="${bbmap_directory}/$2/covstats.txt" \
            covhist="${bbmap_directory}/$2/covhist.txt" \
            basecov="${bbmap_directory}/$2/basecov.txt" \
            bincov="${bbmap_directory}/$2/bincov.txt"

samtools sort "${bbmap_directory}/$2/mapped.bam" -o "${bbmap_directory}/$2/mapped_sorted.bam"

rm "${bbmap_directory}/$2/mapped.bam"

cd "${metabat_directory}/$2"

/home/groups/VEO/tools/metabat/v2/bin/runMetaBat.sh "${scaffolds_file}" \
        "${bbmap_directory}/$2/mapped_sorted.bam"

# CheckM analysis
source /vast/groups/VEO/tools/anaconda3/etc/profile.d/conda.sh && conda activate checkm_v1.2.2

# Find the subdirectory within ${metabat_directory}/${sample} and trim whitespace
sub_directory=$(find "${metabat_directory}/$2" -mindepth 1 -maxdepth 1 -type d | head -n 1)

# Check if a subdirectory was found
if [ -n "$sub_directory" ]; then
    checkm lineage_wf "${sub_directory}" "${checkm_directory}/$2" -t ${threads} -x fa
else
    echo "Error: Subdirectory not found in ${metabat_directory}/$2"
fi

conda deactivate
conda deactivate

date

