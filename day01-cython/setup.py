from distutils.core import setup
from Cython.Build import cythonize

setup(
  ext_modules = cythonize("solution.pyx", build_dir="build")
)
