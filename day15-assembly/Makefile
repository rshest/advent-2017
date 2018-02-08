.PHONY: run build clean

all: run

build: 
	mkdir -p target
	nasm -f elf64 solution.asm -o target/solution.o
	gcc -o target/solution target/solution.o
	
run: build
	@target/solution

clean:
	rm -rf target
