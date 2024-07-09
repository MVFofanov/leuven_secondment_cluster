import os

def concatenate_files(source_dir, destination_dir):
    # Create destination directory if it doesn't exist
    if not os.path.exists(destination_dir):
        os.makedirs(destination_dir)

    # Dictionary to store file contents for each country_hive
    country_hive_files = {}

    # Iterate over files in the source directory
    for filename in os.listdir(source_dir):
        if filename.endswith(".fastq"):
            # Parse country_hive name from the filename
            parts = filename.split("_")
            country_hive = "_".join(parts[:2])

            # Read file contents
            with open(os.path.join(source_dir, filename), 'r') as file:
                file_content = file.read()

            # Append file content to the list for the corresponding country_hive
            if country_hive not in country_hive_files:
                country_hive_files[country_hive] = []
            country_hive_files[country_hive].append(file_content)

    # Write concatenated files to corresponding subdirectories
    for country_hive, files in country_hive_files.items():
        hive_dir = os.path.join(destination_dir, country_hive)
        if not os.path.exists(hive_dir):
            os.makedirs(hive_dir)

        # Concatenate file contents
        concatenated_content = '\n'.join(files)

        # Write concatenated content to a new file in the subdirectory
        with open(os.path.join(hive_dir, f"{country_hive}_ExBee.ExHuman.unpaired.fastq"), 'w') as outfile:
            outfile.write(concatenated_content)

    print("Files concatenated and saved successfully.")

# Example usage:
source_directory = "read_unpaired"
destination_directory = "read_hives"
concatenate_files(source_directory, destination_directory)

