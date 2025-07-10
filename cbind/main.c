#include <mpi.h>
#include <stdio.h>
#include "solver_interface_c.h"


int main(int argc, char *argv[]) {

	int n1 = 3;
	int n2 = 0;
	int stp = 10;
	int l1 = 1;
	int l2 = 0;
        int size = 0;
	int rank = -1;
	int res;

	MPI_Init(&argc,&argv);

        MPI_Comm comm = MPI_COMM_WORLD;
        MPI_Fint comm_f; 

        comm_f = MPI_Comm_c2f(comm); 
	MPI_Comm_size(comm, &size);
        MPI_Comm_rank(comm, &rank);

	res = init_c(&comm_f);

	res = create_solver_c(&n1,&n2);
	res = write_data_c(&stp,&l1,&l2);
	res = destroy_solver_c();

	return 0;
}
