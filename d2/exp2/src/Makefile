ROOT=../..

ERL=$(wildcard *.erl)
BEAM=$(patsubst %.erl,%.beam,${ERL})

OBJS=${BEAM}

all: ${OBJS}

%.beam: %.erl
	erlc $<
clean:
	rm -rf ${OBJS}
