.PHONY: run clean build 

all: run 

build:
	@mkdir -p target
	@coffee -c -m -o target solution.coffee

run: build
	@node target/solution.js 

clean:
	rm -rf target
