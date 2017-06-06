MIN=1
MAX=20

for i in $(seq $MIN $MAX); do
	echo "10, 10, 10, $i, 3"
done > conf
