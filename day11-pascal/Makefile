.PHONY: run build clean

all: run

build:
	mkdir -p target
	fpc solution.pas -FEtarget

run: build
	./target/solution

clean:
	rm -rf target
