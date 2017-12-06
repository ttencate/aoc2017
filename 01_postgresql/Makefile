.PHONY: all
all: run01a run01b

run%: %.sql
	psql -U postgres -f $<
