all: model graph tests

model: model.lts

model.lts: model.fsp
	fspcc -i model.fsp -o model.lts

#%.lts: %.fsp
#	fspcc -i $^ -o $@

tests: deadlock


deadlock: model.lts
	fspcc -d -l model.lts

graph: model.lts
	fspcc -g -l model.lts
	@for f in *.gv; do\
		echo $$f;\
		dot $$f -n -Tpng -o $${f%%.gv}.png; \
	done
		

clean:
	rm -rf *.lts *.gv *.png
