# cython: language_level=3
# distutils: language = c
# cython: boundscheck=True, wraparound=False

import numpy as np
cimport numpy as np

""" Import Fortran interface : nogil utilisé car Fortran ne manipule pass d'objet Python """
cdef extern void init_iso(int *comm) nogil
cdef extern int  get_size_iso(int *list) nogil
cdef extern void get_data_iso(int *list, int *siz, int *ids, float *poss, float *vels) nogil
cdef extern void set_data_iso(int *list, int *siz, int *ids, float *poss, float *vels) nogil
cdef extern void write_data_iso(int *stp, int *list1, int *list2) nogil
cdef extern void create_solver_iso(int *npart1, int *npart2) nogil
cdef extern void solver_euler_iso(int *nite, float *step, int *list_1, int *list_2) nogil
cdef extern void solver_RK2_iso(int *nite, float *step, int *list_1, int *list_2) nogil
cdef extern void destroy_solver_iso() nogil


def init_core(comm):
    if not isinstance(comm, (int)):
        raise TypeError(f"init_core: comm must be int, got {type(comm)}")

    cdef int comm_ = comm

    with nogil:
        init_iso(&comm_)


def get_data(list):
    if not isinstance(list, (int, np.integer)):
        raise TypeError(f"get_data: list must be int, got {type(list)}")
    
    # taille des tableaux
    cdef int list_ = list
    cdef int siz = get_size_iso(&list_)

    # declaration tableaux vides
    cdef np.ndarray[np.int32_t, ndim=1] ids = np.empty(siz, dtype=np.int32)
    cdef np.ndarray[np.float32_t, ndim=1] poss = np.empty(siz*3, dtype=np.float32)
    cdef np.ndarray[np.float32_t, ndim=1] vels = np.empty(siz*3, dtype=np.float32)

    with nogil:
        get_data_iso(&list_,&siz,<int*>ids.data,&poss[0],&vels[0])

    return ids, poss, vels


def set_data(list,ids,poss,vels):
    if not isinstance(list, (int, np.integer)):
        raise TypeError(f"set_data: list must be int, got {type(list)}")
    if not isinstance(ids, (np.ndarray)):
        raise TypeError(f"set_data: ids must be array, got {type(ids)}")
    if not isinstance(poss, (np.ndarray)):
        raise TypeError(f"set_data: poss must be array, got {type(poss)}")
    if not isinstance(vels, (np.ndarray)):
        raise TypeError(f"set_data: vels must be array, got {type(vels)}")

    # taille des tableaux
    if ids.ndim != 1 or poss.ndim != 1 or vels.ndim != 1:
        raise TypeError(f"set_data: ids, poss and vels must have one dimension")
    if 3*ids.size != poss.size or 3*ids.size != vels.size:
        raise TypeError(f"set_data: poss and vels must have same 3 times size of ids")

    # convert for C
    cdef int list_ = list
    cdef int siz_ = ids.size
    cdef np.ndarray[np.int32_t, ndim=1] ids_ = np.ascontiguousarray(ids, dtype=np.int32)
    cdef np.ndarray[np.float32_t, ndim=1] poss_ = np.ascontiguousarray(poss, dtype=np.float32)
    cdef np.ndarray[np.float32_t, ndim=1] vels_ = np.ascontiguousarray(vels, dtype=np.float32)

    with nogil:
        set_data_iso(&list_,&siz_,<int*>ids_.data,&poss_[0],&vels_[0])


def write_data(step,list1,list2):
    # Vérification des types
    if not isinstance(step, (int, np.integer)):
        raise TypeError(f"write_data: step must be int, got {type(step)}")
    if type(list1) not in (bool, np.bool_):
        raise TypeError(f"write_data: list1 must be bool, got {type(list1)}")
    if type(list2) not in (bool, np.bool_):
        raise TypeError(f"write_data: list2 must be bool, got {type(list2)}")

    # Conversion vers types C natifs
    cdef int step_ = step
    cdef int list1_ = 1 if bool(list1) else 0
    cdef int list2_ = 1 if bool(list2) else 0

    with nogil:
        write_data_iso(&step_,&list1_,&list2_)


def create_solver(npart1,npart2):
    # Vérification des types
    if not isinstance(npart1, (int, np.integer)):
        raise TypeError(f"create_euler: nite must be int, got {type(npart1)}")
    if not isinstance(npart2, (int, np.integer)):
        raise TypeError(f"create_euler: step must be int, got {type(npart2)}")

    # Conversion vers types C natifs
    cdef int npart1_ = npart1
    cdef int npart2_ = npart2

    with nogil:
        create_solver_iso(&npart1_,&npart2_)


def solver_euler(nite, step, list_1, list_2):
    # Vérification des types
    if not isinstance(nite, (int, np.integer)):
        raise TypeError(f"solver_euler: nite must be int, got {type(nite)}")
    if not isinstance(step, (float, np.floating)):
        raise TypeError(f"solver_euler: step must be float, got {type(step)}")
    if type(list_1) not in (bool, np.bool_):
        raise TypeError(f"solver_euler: list1 must be bool, got {type(list_1)}")
    if type(list_2) not in (bool, np.bool_):
        raise TypeError(f"solver_euler: list2 must be bool, got {type(list_2)}")

    # Conversion vers types C natifs
    cdef int nite_ = nite
    cdef float step_ = step
    cdef int list_1_ = 1 if bool(list_1) else 0
    cdef int list_2_ = 1 if bool(list_2) else 0

    with nogil:
        solver_euler_iso(&nite_,&step_,&list_1_,&list_2_)


def solver_RK2(nite,step,list_1,list_2):
    # Vérification des types
    if not isinstance(nite, (int, np.integer)):
        raise TypeError(f"solver_RK2: nite must be int, got {type(nite)}")
    if not isinstance(step, (float, np.floating)):
        raise TypeError(f"solver_RK2: step must be float, got {type(step)}")
    if type(list_1) not in (bool, np.bool_):
        raise TypeError(f"solver_RK2: list1 must be bool, got {type(list_1)}")
    if type(list_2) not in (bool, np.bool_):
        raise TypeError(f"solver_RK2: list2 must be bool, got {type(list_2)}")

    # Conversion vers types C natifs
    cdef int nite_ = nite
    cdef float step_ = step
    cdef int list_1_ = 1 if bool(list_1) else 0
    cdef int list_2_ = 1 if bool(list_2) else 0

    with nogil:
        solver_RK2_iso(&nite_,&step_,&list_1_,&list_2_)


def destroy_solver():
    with nogil:
        destroy_solver_iso()
