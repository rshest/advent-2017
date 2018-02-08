.PHONY: run clean build 

all: run 

build:
	@mkdir -p target
	@gcc -O3 solution.c -o target/solution

run: build
	@./target/solution

clean:
	rm -rf target
