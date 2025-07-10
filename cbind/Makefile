FC=mpif90
CC=mpicc
FFLAGS= -Wall -Wextra -O2
CFLAGS= -Wall -Wextra -ansi -pedantic
EXEC=particules_c
LIB=libparticules_cbind.so
SRC_C=c_src

OBJ_C = solver_interface_c.o

all:
	$(CC) main.c -o $(EXEC) -I ../build/include -L ../build/lib -lparticules_cbind -Wl,-rpath='../build/lib'

lib: bld header $(OBJ_C)
	$(FC) ../build/c/solver_interface_c.o $(FFLAGS) -shared -I ../build/include -L ../build/lib -lparticules -Wl,-rpath,'$$ORIGIN' -o ../build/lib/$(LIB)
	@echo "Compilation of cbindings terminee"


header: $(SRC_C)/solver_interface_c.h
	@(cp -f $(SRC_C)/*.h ../build/include)

solver_interface_c.o: $(SRC_C)/solver_interface_c.c ${SRC_C}/solver_interface_c.h
	$(CC) $(CFLAGS) -c -fPIC -I$(SRC_C) $(SRC_C)/solver_interface_c.c -o ../build/c/solver_interface_c.o

bld:
	@-mkdir -p ../build/c
	@-mkdir -p ../build/include
	@-mkdir -p ../build/lib

clean:
	-rm -f $(EXEC) *.dat
	-rm -f ../build/lib/$(LIB)
	-rm -f ../build/c/*

.PHONY: all clean
