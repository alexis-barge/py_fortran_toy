import sys
import os
import numpy as np

module_dir = os.path.abspath(os.path.join(os.path.dirname(__name__), "../build/lib"))
sys.path.insert(0, module_dir)

from py_src.solver import *

# ----------------------------- #
# Create solver
nemo = Solver("NEMO","euler",1,5)
print(nemo)

# Advance in time - get values - write
nemo.advance(5,0.1)
nemo.advance(3,0.5)

ids, pos, vels = nemo.get()
print(f"Rank: {rank}, ids: {ids}, pos: {pos}, vel: {vels}\n")

nemo.write()

# Impose values
new_ids = ids[-1:]
new_pos = np.array([ 2+rank+i for i in range(3*len(new_ids)) ])
new_vels = np.array([ (rank+i) / 10. for i in range(3*len(new_ids)) ])
nemo.set(new_ids,new_pos,new_vels)
ids, pos, vels = nemo.get()
print(f"Rank: {rank}, ids: {ids}, pos: {pos}, vel: {vels}\n")

del nemo
