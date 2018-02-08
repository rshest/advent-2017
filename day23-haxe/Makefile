.PHONY: run clean build 

all: run 

build:
	@mkdir -p target
	@haxe -main Solution -neko target/solution.n

run: build
	@neko target/solution.n 

clean:
	rm -rf target
