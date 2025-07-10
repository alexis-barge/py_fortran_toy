NP=3

all: link
	python3 setup.py build_ext --build-lib=../build/lib --build-temp=../build/python

prog:
	mpirun -np $(NP) python3 ./main.py > log.out

notebook: link
	jupyter notebook --ip=0.0.0.0 --port=8888 --no-browser --allow-root

link:
	export LD_LIBRARY_PATH=:/home/bargea.linux/py_fortran_toy/build/lib/:$(LD_LIBRARY_PATH)

clean:
	-rm *.dat *.out
	-rm -r __pycache__ py_src/__pycache__
	-rm py_src/*.c
	-rm -f ../build/python/*
	-rm -f ../build/lib/*cpython*
