import sys
import os

module_dir = os.path.abspath(os.path.join(os.path.dirname(__file__), "../build/lib"))
sys.path.insert(0, module_dir)

import py_particules
from mpi4py import MPI

comm = MPI.COMM_WORLD
rank = comm.Get_rank()
size = comm.Get_size()

py_particules.init_core(comm.py2f())

class Solver:

    def __init__(self,label,solver_type,list,Npart):
        self.label = label
        self.type = solver_type
        self.total_time = 0.0
        self.total_ite = 0
        self.Npart = Npart
        if list == 1:
            self.l1 = True
            self.l2 = False
            py_particules.create_solver(Npart,0)
        if list == 2:
            self.l1 = False
            self.l2 = True
            py_particules.create_solver(0,Npart)

        if rank == 0:
            print(f"Solver {label} created with method {solver_type}")

    def __del__(self):
        py_particules.destroy_solver()

    def __str__(self):
        if rank == 0:
            return f"Current iteration: {self.total_ite} and simulation time: {self.total_time}"
        else:
            return f""

    def advance(self,ite,step):
        self.total_ite += ite
        self.total_time += ite*step
        if self.type == "euler":
            py_particules.solver_euler(ite,step,self.l1,self.l2)
        elif self.type == "RK2":
            py_particules.solver_RK2(ite,step,self.l1,self.l2)

        if rank == 0:
            print(f"Advancement reached iteration: {self.total_ite} and Total simulation time: {self.total_time}")

    def write(self):
        py_particules.write_data(self.total_ite,self.l1,self.l2)

    def get(self):
        if rank == 0:
            print("Get particles values at ",self,"\n")
        li = 1 if self.l1 else 2
        return py_particules.get_data(li)

    def set(self,ids,poss,vels):
        if rank == 0:
            print("\nImposing values at ",self,"\n")
        li = 1 if self.l1 else 2
        py_particules.set_data(li,ids,poss,vels)
