.PHONY: all
all: run14a run14b

run%: %.cu
	nvcc $< -o $* && ./$* < input
