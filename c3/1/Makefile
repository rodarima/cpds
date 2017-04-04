all: model graph tests png

model: model.lts

model.lts: model.fsp
	fspcc -i model.fsp -o model.lts

#%.lts: %.fsp
#	fspcc -i $^ -o $@

tests: deadlock


deadlock: model.lts
	fspcc -d -l model.lts > deadlock.txt
	@grep 'Deadlock found'  deadlock.txt | \
	sed -e 's/Deadlock found for process \([^:]*\): state \([0-9]*\)/\1 \2/g' \
	> deadlock.states
	@echo deadlock.states
	@while read f n; do\
	        sed -i -e "s/\($$n \[.*\)pink/\1red/g" "$$f.gv"; \
	done < deadlock.states


graph: model.lts
	fspcc -g -l model.lts

png:
	@for f in *.gv; do\
		echo $$f;\
		dot $$f -n -Tpng -o $${f%%.gv}.png; \
	done
		

clean:
	rm -rf *.lts *.gv *.png deadlock.*
