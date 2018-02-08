.PHONY: buid run clean

all: run


build:
	python3 setup.py build_ext --inplace


run: build
	python3 -c "import solution; solution.solution()"


clean:
	rm -rf build *.so
