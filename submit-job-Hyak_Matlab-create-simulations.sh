#!/bin/bash
## --------------------------------------------------------

## RENAME for your job
#PBS -N topo-Cascadia

## DIRECTORY where this job is run
#PBS -d ./

## GROUP to run under, or run under backfill
## PBS -W group_list=hyak-fluids
#PBS -W group_list=hyak-motley
## PBS -W group_list=hyak-stf

## NUMBER nodes, CPUs per node, and MEMORY
#PBS -l nodes=1:ppn=16,mem=50gb
## PBS -l nodes=2:ppn=16,mem=100gb

## WALLTIME (defaults to 1 hour, always specify for longer jobs)
#PBS -l walltime=12:00:00

## LOG the (stderr and stdout) job output in the directory
#PBS -j oe -o .

## EMAIL to send when job is aborted, begins, and terminates
#PBS -m abe -M sale.danny@gmail.com

## END of PBS commmands ... only BASH from here and below
## --------------------------------------------------------

## LOAD modules needed
echo 'loading modules Matlab and STAR-CCM+:'
module load matlab_2015b
module load contrib/openscad
module load contrib/starccm_12.02.010

## RUN my simulation file in batch mode
matlab -nodesktop -nosplash < topoCascadia_UserInputs.m 2>&1 | tee log.topoCascadia

echo 'all finished, have a nice day'

