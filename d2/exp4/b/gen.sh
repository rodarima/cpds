Emin=1
Emax=20

for e in $(seq $Emin $Emax); do
	echo "10, $e, 10, 10, 3"
done > conf
