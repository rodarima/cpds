ROOT=../..
PY=${ROOT}/py

OBJS=conf out.csv mean.csv fig.png log.png

all: ${OBJS}

%.png: %.gp mean.csv
	gnuplot $<

mean.csv: out.csv ${PY}/mean.py mean.sh
	./mean.sh < out.csv > mean.csv

out.csv: conf ../src/run.sh
	../src/run.sh < conf > out.csv

conf: gen.sh
	./gen.sh

clean:
	rm -rf ${OBJS}
