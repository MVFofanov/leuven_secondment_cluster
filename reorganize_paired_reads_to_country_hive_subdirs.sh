#!/bin/bash

# Iterate over subdirectories in read_hives directory
input_dir='read'
for subdir in read_hives/*; do
    if [ -d "$subdir" ]; then
        subdir_name=$(basename "$subdir")
        
        # Concatenate modified R1 files
        cat "${input_dir}/${subdir_name}"*/*_modified_R1.fastq.gz > \
		"read_hives/${subdir_name}/${subdir_name}.ExBee.ExHuman_modified_R1.fastq.gz"

        # Concatenate modified R2 files
        cat "${input_dir}/${subdir_name}"*/*_modified_R2.fastq.gz > \
		"read_hives/${subdir_name}/${subdir_name}.ExBee.ExHuman_modified_R2.fastq.gz"
    fi
done

echo "Modified R files concatenated and saved successfully."
