#!/bin/bash -l
#NOTETE the -l flag!
#
#SBATCH -J NAME
# Default in slurm
# Request 5 hours run time
#SBATCH -t 5:0:0
#
#SBATCH -p dellmid  -N 1 -n 12
# NOTE Each small node has 12 cores
#

module load vasp/5.4.4-impi-mkl

# add your job logical here!!!
mpirun  -n 12 vasp_std

