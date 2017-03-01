#TARGETS=$(wilcard */)
TARGETS=$(shell find * -maxdepth 1 -type d)

.PHONY: all

all: model graph tests

%:
	@for t in ${TARGETS}; do \
		$(MAKE) -C $$t $@; \
	done

