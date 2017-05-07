#!/bin/bash
## --------------------------------------------------------

## RENAME for your job
#PBS -N topo-1936

## DIRECTORY where this job is run
#PBS -d ./

## GROUP to run under, or run under backfill
#PBS -W group_list=hyak-stf

## NUMBER nodes, CPUs per node, and MEMORY
#PBS -l nodes=3:ppn=16,mem=180gb

## WALLTIME (defaults to 1 hour, always specify for longer jobs)
#PBS -l walltime=06:00:00

## LOG the (stderr and stdout) job output in the directory
#PBS -j oe -o .

## EMAIL to send when job is aborted, begins, and terminates
#PBS -m abe -M sale.danny@gmail.com

## LOAD modules needed
module load matlab_2015b
module load contrib/openscad
module load contrib/starccm_12.02.010

## RUN my simulation file in batch mode
starSimFile="time-1936"
ROMStime="1936"

matlab -nodesktop -nosplash < topoCascadia_UserInputs_time${ROMStime}.m 2>&1 | tee log.topoCascadia-time${ROMStime}
cd cases/${starSimFile}
echo 'running starccm from directory:'
pwd
starccm+ -batch ../../macros/_main_ROMS_nesting_step4_Solution.java -np ${PBS_NP} -machinefile ${PBS_NODEFILE} -licpath 1999@mgmt2.hyak.local -batch-report ${starSimFile}.sim 2>&1 | tee log.run_${starSimFile}
# cd ../..
# mv cases/${starSimFile} cases/${starSimFile}_time${ROMStime}

echo 'all finished, have a nice day'

