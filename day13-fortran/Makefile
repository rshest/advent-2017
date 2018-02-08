.PHONY: run build clean

all: run

build:
	mkdir -p target && gfortran -O3 -o target/solution solution.f95

run: build
	@target/solution


clean:
	rm -rf target
