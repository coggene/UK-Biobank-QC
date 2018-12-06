### For the script to work you need: ###
# create_new_relfile1.py
# rel.py

#Inputs:
# $1 = rel file
# $2 = list of individuals you preferentially want to keep
# $3 = output file name


awk '{print $1}' $1 > rel_ids.txt
awk '{print $2}' $1 > rel_ids2.txt

cat rel_ids.txt rel_ids2.txt | sort | uniq -c | sort -nr > rel_ids_count.txt

# first remove all individuals with 4 or more relatives. -n will be different depending on rel file and chosen threshold

head -n 3177 rel_ids_count.txt > ids4
awk '{print $2}' ids4 > ids_to_remove4.txt

# now make a new rel file with rows containing ids in ids_to_remove4.txt removed.

python create_new_relfile1.py $1 ids_to_remove4.txt over4_removed.dat

# Of remaining related individuals in ids_to_remove4.txt, remove one individual from each pair, preferentially removing those that do not 
# have data of interest available.

python rel.py $2 over4_removed.dat extract_4.txt

cat extract_4.txt ids_to_remove4.txt > $3
