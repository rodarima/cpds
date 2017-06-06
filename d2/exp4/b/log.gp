set datafile separator ','
set terminal pngcairo
set xlabel 'Entries'
set ylabel 'Success rate'

set logscale xy
set output 'log.png'
set grid

set xtics (1,2,3,4,5,6,7,8,9,10)
set ytics (0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1.0)

plot 'mean.csv' w l lt 1 notitle, \
	'mean.csv' using 1:2:3 w yerrorbars notitle lt 1
