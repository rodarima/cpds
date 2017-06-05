import numpy as np
from sys import stdin

data = np.genfromtxt(stdin.buffer, delimiter=", ")
#data = np.genfromtxt('firsthh.csv', delimiter='\t')

cols = data.shape[1]

if cols != 2:
	print("Data has {} columns, but I expected 2".format(cols))
	exit(1)

# First classify by the variable affected

var_col = np.unique(np.sort(data[:,0]))
#print(var_col)

for var in var_col:
	var_data = data[data[:,0] == var]
	mean = np.mean(var_data[:,1])
	std = np.std(var_data[:,1])
	print("{}, {}, {}".format(int(var), mean, std))
