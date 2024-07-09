#!/bin/bash
echo "Note: This script is designed to run with the amount of memory detected by BBMap."
echo "      If Samtools crashes, please ensure you are running on the same platform as BBMap,"
echo "      or reduce Samtools' memory setting (the -m flag)."
echo "Note: Please ignore any warnings about 'EOF marker is absent'; this is a bug in samtools that occurs when using piped input."
samtools view -bShu /home/zo49sog/crassvirales/leuven_secondment/bbmap_results_all/BE_16556_aut_ile/mapped.sam | samtools sort -m 48G -@ 3 - -o /home/zo49sog/crassvirales/leuven_secondment/bbmap_results_all/BE_16556_aut_ile/mapped_sorted.bam
samtools index /home/zo49sog/crassvirales/leuven_secondment/bbmap_results_all/BE_16556_aut_ile/mapped_sorted.bam
