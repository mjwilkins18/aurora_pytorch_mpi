#!/bin/bash

MPIEXEC_PATH=/opt/cray/pals/1.4/bin/mpiexec
CPU_BIND_SCHEME="--cpu-bind=list:4:9:14:19:20:25:56:61:66:71:74:79"

NNODES=`wc -l < $PBS_NODEFILE`
PPN=12
PROCS=$(($NNODES * $PPN))

$MPIEXEC_PATH \
	-n $PROCS \
	-ppn $PPN \
	${CPU_BIND_SCHEME} \
	python dist_test.py
