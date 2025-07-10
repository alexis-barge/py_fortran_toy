FC=mpif90
CFLAGS= -Wall -Wextra -O2
EXEC=particules
LIB=libparticules.so

OBJ = worker.o in_out.o part_data.o part_solver.o toy_particules.o
OBJ_LIB = worker.o in_out.o part_data.o part_solver.o mod_part.o solver_interface_iso.o

all: bld $(EXEC)
	@echo "Compilation executable terminee"

$(EXEC): $(OBJ)
	$(FC) -o $@ $^ $(FFLAGS)

%.o: %.f90
	$(FC) -c -fPIC -J ../build/include $< $(FFLAGS)

lib: bld $(LIB)
	@mv *.o ../build/fortran
	@echo "Compilation of Fortran core with C bindings finished"

$(LIB): $(OBJ_LIB) 
	$(FC) -shared -o ../build/lib/$(LIB) $^ $(FFLAGS)

bld:
	@-mkdir -p ../build/fortran
	@-mkdir -p ../build/include
	@-mkdir -p ../build/lib

libprog:
	$(FC) main.f90 -J ../build/include -L ../build/lib -lparticules -Wl,-rpath,'../build/lib' -o $(EXEC) 

clean:
	-rm -f *.o *.mod $(EXEC) *.dat *.so
	-rm -f ../build/include/*mod
	-rm -f ../build/lib/$(LIB)
	-rm -f ../build/fortran/*

.PHONY: all clean
