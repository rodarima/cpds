set datafile separator ','
set terminal pngcairo
set output 'fig.png'
set xlabel 'Reads'
set ylabel 'Success rate'
set grid
set xrange [1:20]

set offset graph 0.05, graph 0.05, graph 0.05, graph 0.05


plot 'mean.csv' w l lt 1 notitle, \
	'mean.csv' using 1:2:3 w yerrorbars notitle lt 1

