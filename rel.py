import sys
ids_to_keep = sys.argv[1]
over4_removed = sys.argv[2]
outFile = sys.argv[3]

import pandas as pd
# Open file containing list of ids i want to keep. Strip newlines.
# Convert strings to integers
#ids = map(int, ids)
with open(ids_to_keep) as f: # IDstoKeep_cog.txt
    ids = [cogs.strip() for cogs in f]
ids = map(int, ids)
# Read in space seperated rel file as a pandas table
X = pd.read_csv(over4_removed, sep="\t", header=None) #over4_removed.dat
extract = []
for i, j in zip(X[0], X[1]):
    if (i not in extract and j not in extract):
            if i not in ids:
                extract.append(i)
            else:
                extract.append(j)
with open(outFile, 'w') as file_handler: #extract_4.txt
    for item in extract:
        file_handler.write("{}\n".format(item))
