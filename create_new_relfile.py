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
