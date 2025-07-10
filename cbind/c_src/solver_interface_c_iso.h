#ifndef __SOLVER_INTERFACE_C_ISO_H__
#define __SOLVER_INTERFACE_C_ISO_H__

/* FORTRAN interfaces */
void init_iso(const int *comm);

void write_data_iso(const int* stp, const int* list1, const int* list2 );

void create_solver_iso(const int* npart1, const int* npart2);

void solver_euler_iso(const int* nite, const float* step, const int* list_1, const int* list_2);

void solver_RK2_iso(const int* nite, const float* step, const int* list_1, const int* list_2);

void destroy_solver_iso();

#endif
