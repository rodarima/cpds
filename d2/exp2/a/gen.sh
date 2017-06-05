Cmin=1
Cmax=20

for i in $(seq $Cmin $Cmax); do
	echo "10, 20, 10, 10, 3, $i"
done > conf
