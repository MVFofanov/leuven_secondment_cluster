import csv
import json
import os
import glob

if __name__ == "__main__":
    # Pattern to match all files in the specified directory and subdirectories
    pattern = "/home/zo49sog/crassvirales/leuven_secondment/checkm_results_all/*/storage/bin_stats_ext.tsv"

    # Iterate over all matching files
    for checkm_bin_stats_ext in glob.glob(pattern):
        # Output file path
        checkm_bin_stats_ext_edited = checkm_bin_stats_ext.replace(".tsv", "_edited.tsv")

        with open(checkm_bin_stats_ext, encoding='utf8') as input_file,\
             open(checkm_bin_stats_ext_edited, 'w', encoding='utf8')  as output_file:

            header = ['sample_name', 'bin_number', 'country', 'hive', 'season', 'gut_part', 'marker lineage', '# genomes', '# markers',
                      '# marker sets', '0', '1', '2', '3', '4', '5+', 'Completeness', 'Contamination', 'GC', 'GC std', 'Genome size',
                      '# ambiguous bases', '# scaffolds', '# contigs', 'Longest scaffold', 'Longest contig', 'N50 (scaffolds)',
                      'N50 (contigs)', 'Mean scaffold length', 'Mean contig length', 'Coding density', 'Translation table',
                      '# predicted genes', 'GCN0', 'GCN1', 'GCN2', 'GCN3', 'GCN4', 'GCN5+']

            writer = csv.DictWriter(output_file, delimiter='\t', fieldnames=header)
            writer.writeheader()

            for line in input_file:
                #print(line)
                bin_number, fields = line.strip().split('\t')
                #print(bin_number)
                #print(fields)
                json_acceptable_string = fields.replace("'", "\"")

                # Get the parent directory of the file
                parent_directory = os.path.dirname(checkm_bin_stats_ext)
                #print(f'{parent_directory=}')

                # Get the parent directory of the parent directory (grandparent directory)
                grandparent_directory = os.path.dirname(parent_directory)

                #print(f'{grandparent_directory=}')

                fields_dict = json.loads(json_acceptable_string)

                sample_name = grandparent_directory.split('/')[-1]
                country, hive, season, gut_part = sample_name.split('_')

                sample_info_dict = {
                                    "sample_name": sample_name,
                                    "bin_number": bin_number,
                                    "country": country,
                                    "hive": '_'.join((country, hive)),
                                    "season": season,
                                    "gut_part": gut_part
                                    }


                result_dict = sample_info_dict | fields_dict

                #print(type(result_dict))
                #print(result_dict)
                #print(result_dict['Completeness'])
                #print(result_dict.keys())

                writer.writerow(result_dict)

