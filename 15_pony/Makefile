.PHONY: all
all: run15a run15b

run%: %/Main.pony
	cd $* && CC=gcc ponyc --pic && ./$* < ../input
