
#include "solver_interface_c.h"
#include "solver_interface_c_iso.h"
#include <stdlib.h>
#include <string.h>

int init_c(const int*comm){
	int done = 0;
	init_iso(comm);
	done = 1;
	return done;
}

int write_data_c(const int* stp, const int* list1, const int* list2){
	int done = 0;
	write_data_iso(stp, list1, list2);
	done = 1;
	return done;
}

int create_solver_c(const int* npart1, const int* npart2){
	int done = 0;
	create_solver_iso(npart1,npart2);
	done = 1;
	return done;
}

int solver_euler_c(const int* nite, const float* step, const int* list_1, const int* list_2){
	int done = 0;
	solver_euler_iso(nite, step, list_1, list_2);
	done =1;
	return done;
}

int solver_RK2_c(const int* nite, const float* step, const int* list_1, const int* list_2){
	int done = 0;
	solver_RK2_iso(nite, step, list_1, list_2);
	done = 1;
	return done;
}

int destroy_solver_c(){
	int done = 0;
	destroy_solver_iso();
	done = 1;
	return done;
}
