from setuptools import setup, Extension
from Cython.Build import cythonize
import numpy

extensions = [
    Extension(
        "py_particules",                       # nom du module Cython à générer
        sources=["py_src/py_particules.pyx"],  # ton code Cython
        libraries=["particules"],              # nom de ta lib Fortran (sans préfixe lib ni suffixe .a/.so)
        library_dirs=["../build/lib"],         # où chercher la lib - compil
        runtime_library_dirs=["../build/lib"], # ou chercher la lib - exec
        include_dirs=[numpy.get_include()],    # inclure headers numpy si nécessaire
        extra_compile_args=["-O3"],            # options compilateur (optionnel)
        extra_link_args=[],                    # options linker si besoin
        language="c",                          # langage à générer
    )
]

setup(
    name="wrapper",
    ext_modules=cythonize(extensions, language_level=3),
)
