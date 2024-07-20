# Loop through the .fna files and append their paths to the text file
for file in *.fna; do
    echo "$(pwd)/$file" >> path_list_total_cyano_mal_15jul2024.txt
done
