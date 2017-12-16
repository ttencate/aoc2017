.PHONY: all
all: run16a # run16b

run%: %.fs
	fsharpc $< && mono $*.exe < input
