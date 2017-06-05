Cmin=1
Cmax=20

for c in $(seq $Cmin $Cmax); do
	echo "$c, 10, 10, 10, 3"
done > conf
