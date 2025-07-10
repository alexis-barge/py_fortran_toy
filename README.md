# Python-wrapped Fortran-written Toy Model

**Requires:**
  - MPI implementation
  - GCC Fortran and C compilers
  - Python packages : *mpi4py  numpy  Cython*

## Fortran sources

Toy Model is a lagrangian particle solver. A particle is defined by an ID number, and two vectors for position and velocity, respectively. The toy model manipulates two arrays of particles shared in memory between the solver modules. The solver initializes sizes of arrays from *params.txt*. Particles initial values are randomly set. The solver advances position of particles in time from velocity. Time integration can be done by Euler or (phony) RK2 scheme. Time step and number of iteration are taken from *params.txt*. Toy model can write particles arrays in output files.

``toy_particules.f90`` : classic Fortran program that uses Toy Model modules to perform particles simulation.

``solver_interface_iso.f90`` : C-interfaced Fortran layer designed to connect Toy Model functions with incoming simple instructions. 

For instance: 
- impose number of particles to simulate, bypassing *params.txt*
- perform N iterations with given time step
- Return copy of the particles values


**Compile Fortran core**

```bash
cd fortran_src
make
```
  - **make** : compile solver as executable from sources
  - **make lib** : compile solver as shared library ``libparticules.so``
  - **make libprog** : compile solver as executable from shared library
  - **make clean** : clean up Fortran build and sources directory



## Python bindings

``py_src`` contains the Cython (*.pyx) layer that wrapps the C-interfaced Fortran layer within Python functions.

``solver.py`` is a Python abstraction class that encapsulates the Python wrappers to an user-friendly interface.

``py_particules.ipynb`` notebook showcasing interactive Python wrapper for Toy Model.

**Compile Python bindings**

```bash
cd fortran_src
make lib
cd ../py_bind
# Edit $(DIR) in Makefile in accordance with your machine
make
```
  - **make** : compile Cython sources as Python module ``py_particules.cpython-<...>.so``
  - **make prog** : execute parallelized Python program ``main.py`` that executes Toy Model from Python wrapper
  - **make clean** : clean up Python build and sources directory



## C binbings 

Useless to wrapp Toy Model in Python. C sources are just here to show how to use the C interface of the Fortran sources to build C wrapper of Toy Model.

**Compile C sources**

```bash
cd fortran_src
make lib
cd ../cbind
make lib
make
```
  - **make lib** : compile C wrapper of the Fortran layer as shared library ``libparticules_cbind.so``
  - **make** : compile C program that executes Toy Model from C wrapper (parallelized)
  - **make clean** : clean up C build and sources directory
