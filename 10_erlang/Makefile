.PHONY: all
all: run10a run10b

run%: aoc%.erl
	erlc $< && erl -noshell -s aoc$* start < input
