MIN=1
MAX=10

for i in $(seq $MIN $MAX); do
	echo "10, 10, 10, 10, $i"
done > conf
