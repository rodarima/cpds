EXPERIMENTS=exp1 exp2 exp3 exp4

all:
	for exp in $(EXPERIMENTS) ; do \
		make -C $$exp; \
	done
	make -C doc/


clean:
	for exp in $(EXPERIMENTS) ; do \
		make -C $$exp clean; \
	done
	make -C doc/ clean
