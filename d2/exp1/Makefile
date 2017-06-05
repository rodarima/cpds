EXPERIMENTS=$(wildcard [a-z])

all:
	make -C src/
	for exp in $(EXPERIMENTS) ; do \
		make -C $$exp; \
	done

clean:
	make -C src/ clean
	for exp in $(EXPERIMENTS) ; do \
		make -C $$exp clean; \
	done


