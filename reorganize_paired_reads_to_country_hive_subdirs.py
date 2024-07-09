import os
import gzip
import shutil

def concatenate_R_files(source_dir, destination_dir, R_number):
    # Iterate over subdirectories in the source directory
    for subdir in os.listdir(source_dir):
        subdir_path = os.path.join(source_dir, subdir)
        if os.path.isdir(subdir_path):
            R1_files = []
            R2_files = []
            country_hive = None

            # Collect R1 and R2 files and extract country_hive
            for filename in os.listdir(subdir_path):
                if filename.endswith("_modified_R1.fastq") or filename.endswith("_modified_R1.fastq.gz"):
                    R1_files.append(os.path.join(subdir_path, filename))
                    parts = filename.split("_")
                    country_hive = "_".join(parts[:2])
                elif filename.endswith("_modified_R2.fastq") or filename.endswith("_modified_R2.fastq.gz"):
                    R2_files.append(os.path.join(subdir_path, filename))

            # Concatenate R1 files
            if R1_files:
                concatenated_R1_content = b""
                for file_path in R1_files:
                    with open_or_gzip(file_path, 'rb') as file:
                        concatenated_R1_content += file.read()

                # Write concatenated R1 content to a new gzip file
                output_filename_R1 = f"{country_hive}_ExBee.ExHuman_R{R_number}.fastq.gz"
                output_path_R1 = os.path.join(destination_dir, country_hive, output_filename_R1)
                with gzip.open(output_path_R1, 'wb') as outfile:
                    outfile.write(concatenated_R1_content)

            # Concatenate R2 files
            if R2_files:
                concatenated_R2_content = b""
                for file_path in R2_files:
                    with open_or_gzip(file_path, 'rb') as file:
                        concatenated_R2_content += file.read()

                # Write concatenated R2 content to a new gzip file
                output_filename_R2 = f"{country_hive}_ExBee.ExHuman_R{R_number}.fastq.gz"
                output_path_R2 = os.path.join(destination_dir, country_hive, output_filename_R2)
                with gzip.open(output_path_R2, 'wb') as outfile:
                    outfile.write(concatenated_R2_content)

    print("R files concatenated and saved successfully.")

def open_or_gzip(file_path, mode):
    if file_path.endswith('.gz'):
        return gzip.open(file_path, mode)
    else:
        return open(file_path, mode)

# Example usage:
source_directory = "read"
destination_directory = "read_hives"
concatenate_R_files(source_directory, destination_directory, 1)  # For R1
concatenate_R_files(source_directory, destination_directory, 2)  # For R2

