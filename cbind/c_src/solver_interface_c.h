#ifndef __SOLVER_INTERFACE_C_H__
#define __SOLVER_INTERFACE_C_H__

/* C interfaces */
int init_c(const int *comm);

int write_data_c(const int* stp, const int* list1, const int* list2 );

int create_solver_c(const int* npart1, const int* npart2);

int solver_euler_c(const int* nite, const float* step, const int* list_1, const int* list_2);

int solver_RK2_c(const int* nite, const float* step, const int* list_1, const int* list_2);

int destroy_solver_c();

#endif
