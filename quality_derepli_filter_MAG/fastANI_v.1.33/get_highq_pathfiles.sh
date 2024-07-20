#! /bin/bash

# Read accession numbers and store in a variable
accessions=$(cat checkm_firstfilter_accesionnumber.txt)

# Create and name the output file
output_file="/storage/pietrasiaklab/Benjy_SH/project/project_1_evo_cyano_terr/input_files/quality_control_MGA/fastANI_v1_33/fastani_input/path_list_highq_cyano_mal_15jul2024.txt"> $output_file

# Loop through each accession number and grep the corresponding path
for accession in $accessions; do
  grep "$accession" checkm_cyano_mal_mag_952/path_list_total_cyano_mal_15jul2024.txt >> $output_file
done
