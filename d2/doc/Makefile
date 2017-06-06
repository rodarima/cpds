OBJECTS=report.pdf

all: $(OBJECTS)

clean:
	latexmk -f -quiet -C $(OBJECTS)
	rm -f $(OBJECTS) *.nav *.snm

%.pdf: %.tex
	latexmk -quiet -pdf -pdflatex="pdflatex -interaction=nonstopmode -shell-escape" -use-make $<
