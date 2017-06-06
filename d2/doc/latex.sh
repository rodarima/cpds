#!/bin/bash

FILE=$1
TEX=${FILE%.*}.tex
PDF=${FILE%.*}.pdf
TEX_FLAGS="-shell-escape -interaction=nonstopmode -halt-on-error"


while [ 1 ]; do
	sleep 2
	# Files to look can change
	FILES=$(cat "$TEX" |\
		grep -o '\\input{.*}' |\
		sed -e 's/\\input{\(.*\)}/\1.tex/g' |\
		paste -sd " ")

	inotifywait -e modify $TEX $FILES

	pdflatex $TEX_FLAGS $TEX
	if [ "$?" != "0" ]; then
		echo -e "\a"
		continue
	fi
#	bibtex $FILE
#	pdflatex $TEX_FLAGS $TEX
#	if [ "$?" != "0" ]; then
#		echo -e "\a"
#		continue
#	fi
#	pdflatex $TEX_FLAGS $TEX
#	if [ "$?" != "0" ]; then
#		echo -e "\a"
#		continue
#	fi
	kill -HUP $(pidof mupdf) $(pidof mu)
done
