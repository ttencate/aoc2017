.PHONY: all
all: run18a run18b

run%: %/*.e
	cd $* && se c MAIN make -o $* && ./$* < ../input
