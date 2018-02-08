Day01 solution in [Cython](https://en.wikipedia.org/wiki/Cython) programming language.

## Why?

`Cython` is a "faster Python", it's something inbetween `C` and `Python` programming languages - indeed, your pythonesque *.pyx files get translated into .c code first, and then it's just compiled via gcc.

It is used as an "escape hatch" in performance-critical parts of many data science and machine learning Python libraries (e.g. `gensim`, but there are many others).

It's seamlessly integrated into the Python distribution model, and in many cases your client won't even notice that it's not a "real" Python code - they just do `pip install <package>` and `import <package>` on the Python side. The code will be automagically translated into C, and then built with gcc into a shared library behind the scenes during the installation.



## Installing
You need Python3 with Cython installed:

```bash
$ pip3 install cython
```

## Running
```bash
make
```
