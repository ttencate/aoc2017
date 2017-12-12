.PHONY: all
all: run12a # run12b

run%: %.dart
	dartanalyzer --strong --fatal-infos --fatal-warnings $< && dart $< --checked < input
