import glob
import pandas as pd
import os
import shutil

def copy_bins(filtered_table, bin_column, sample_name_column, metabat_dir, dest_dir):
    # Create destination directory if it doesn't exist
    os.makedirs(dest_dir, exist_ok=True)

    for index, row in filtered_table.iterrows():
        sample_name = row[sample_name_column]
        bin_number = row[bin_column]

        # Construct source directory path
        source_dir = os.path.join(metabat_dir, sample_name)
        source_dir_pattern = os.path.join(source_dir, "scaffolds.fasta.metabat-bins-*")

        # Find directories matching the pattern
        matching_dirs = glob.glob(source_dir_pattern)

        # Copy each matching file
        for dir_path in matching_dirs:
            # Construct file path
            file_path = os.path.join(dir_path, f"{bin_number}.fa")

            # Check if the file exists
            if os.path.isfile(file_path):
                # Construct destination path
                dest_path = os.path.join(dest_dir, f"{sample_name}_{bin_number}.fa")

                # Copy the file
                shutil.copy(file_path, dest_path)


def main():
    # Define paths and filenames
    sample_table_filtered_file = "hive_analysis/sample_table_filtered.tsv"
    hive_table_filtered_file = "hive_analysis/hive_table_filtered.tsv"
    metabat_dir_samples = "/home/zo49sog/crassvirales/leuven_secondment/metabat_results_all"
    metabat_dir_hives = "/home/zo49sog/crassvirales/leuven_secondment/hive_analysis/metabat_binning"
    dest_dir = "hive_analysis/filtered_bins"

    # Load filtered tables
    sample_table_filtered = pd.read_csv(sample_table_filtered_file, sep='\t')
    hive_table_filtered = pd.read_csv(hive_table_filtered_file, sep='\t')

    # Copy bins for sample table
    copy_bins(sample_table_filtered, 'bin_number', 'sample_name', metabat_dir_samples, dest_dir)

    # Copy bins for hive table
    copy_bins(hive_table_filtered, 'bin_number', 'sample_name', metabat_dir_hives, dest_dir)

if __name__ == "__main__":
    main()
