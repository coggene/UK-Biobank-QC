### For the script to work you need: ###
# create_new_relfile1.py
# rel.py

Inputs:
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

cat extract_4.txt ids_to_remove4t.txt > $3

[lfahey@node021 EGAD00010001497]$ cat create_new_relfile1.py
import sys
rel_inFile = sys.argv[1]
ids_inFile = sys.argv[2]
outFile = sys.argv[3]

import pandas as pd
X = pd.read_csv(rel_inFile, sep=" ", header=None)

# Read in the list of ids I want to remove from ukb_rel.dat

with open(ids_inFile) as f:
    ids = [rel.strip() for rel in f]

# Convert to integers
ids = map(int, ids)

# pandas.Dateframe.isin will return boolean values depending on whether each element is inside the list a or not. You then invert this with the ~ to convert True to False and vice versa.
# Identify id ids in 1st column are in ids or not, remove entire row and create new data holder, f_X
f_X = X[~X[0].isin(ids)]
# Take in f_X. This time if values in 2nd column are in ids, entire row is removed.
X_f = f_X[~f_X[1].isin(ids)]

X_f.to_csv(outFile, sep='\t', index=False, header=None)
