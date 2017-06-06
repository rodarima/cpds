EXPERIMENTS=$(wildcard exp[0-9]*)

all:
	make -C doc/
	for exp in $(EXPERIMENTS) ; do \
		make -C $$exp; \
	done


clean:
	make -C doc/ clean
	for exp in $(EXPERIMENTS) ; do \
		make -C $$exp clean; \
	done
