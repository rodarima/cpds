set datafile separator ','
set terminal pngcairo
set output 'fig.png'
set xlabel 'Entries'
set ylabel 'Success rate'
set grid
set xrange [1:20]

set offset graph 0.05, graph 0.05, graph 0.05, graph 0.05


plot '../../exp1/b/mean.csv' w l lt 1 title 'Opty', \
	'../../exp1/b/mean.csv' using 1:2:3 w yerrorbars notitle lt 1 , \
	'mean.csv' w l lt 2 title 'Timey', \
	'mean.csv' using 1:2:3 w yerrorbars notitle lt 2

