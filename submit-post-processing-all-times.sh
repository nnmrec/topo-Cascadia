#!/bin/bash
## --------------------------------------------------------

## RENAME for your job
#PBS -N topo-post-process-all-times

## DIRECTORY where this job is run
#PBS -d ./

## GROUP to run under, or run under backfill
## PBS -W group_list=hyak-stf
#PBS -W group_list=hyak-motley

## NUMBER nodes, CPUs per node, and MEMORY
#PBS -l nodes=1:ppn=16,mem=60gb

## WALLTIME (defaults to 1 hour, always specify for longer jobs)
#PBS -l walltime=01:00:00

## LOG the (stderr and stdout) job output in the directory
#PBS -j oe -o .

## EMAIL to send when job is aborted, begins, and terminates
#PBS -m abe -M sale.danny@gmail.com

## LOAD modules needed
module load contrib/starccm_12.02.010

## RUN my simulation file in batch mode

# macro1='_main_ROMS_nesting_step5_PostProcessing.java'
macro1='export_VerticalProfiles.java'
PBS_NP='2'
PBS_NODEFILE=''

starSimFile="time-0568"
cd cases/${starSimFile}
starccm+ -batch ../../macros/$macro1 -np ${PBS_NP} -machinefile ${PBS_NODEFILE} -licpath 27005@swlic01.s.uw.edu -batch-report ${starSimFile}.sim 2>&1 | tee log.post_${starSimFile}
cd ../..

starSimFile="time-0592"
cd cases/${starSimFile}
starccm+ -batch ../../macros/$macro1 -np ${PBS_NP} -machinefile ${PBS_NODEFILE} -licpath 27005@swlic01.s.uw.edu -batch-report ${starSimFile}.sim 2>&1 | tee log.post_${starSimFile}
cd ../..

starSimFile="time-0666"
cd cases/${starSimFile}
starccm+ -batch ../../macros/$macro1 -np ${PBS_NP} -machinefile ${PBS_NODEFILE} -licpath 27005@swlic01.s.uw.edu -batch-report ${starSimFile}.sim 2>&1 | tee log.post_${starSimFile}
cd ../..

starSimFile="time-0689"
cd cases/${starSimFile}
starccm+ -batch ../../macros/$macro1 -np ${PBS_NP} -machinefile ${PBS_NODEFILE} -licpath 27005@swlic01.s.uw.edu -batch-report ${starSimFile}.sim 2>&1 | tee log.post_${starSimFile}
cd ../..



starSimFile="time-1812"
cd cases/${starSimFile}
starccm+ -batch ../../macros/$macro1 -np ${PBS_NP} -machinefile ${PBS_NODEFILE} -licpath 27005@swlic01.s.uw.edu -batch-report ${starSimFile}.sim 2>&1 | tee log.post_${starSimFile}
cd ../..

starSimFile="time-1840"
cd cases/${starSimFile}
starccm+ -batch ../../macros/$macro1 -np ${PBS_NP} -machinefile ${PBS_NODEFILE} -licpath 27005@swlic01.s.uw.edu -batch-report ${starSimFile}.sim 2>&1 | tee log.post_${starSimFile}
cd ../..

starSimFile="time-1912"
cd cases/${starSimFile}
starccm+ -batch ../../macros/$macro1 -np ${PBS_NP} -machinefile ${PBS_NODEFILE} -licpath 27005@swlic01.s.uw.edu -batch-report ${starSimFile}.sim 2>&1 | tee log.post_${starSimFile}
cd ../..

starSimFile="time-1936"
cd cases/${starSimFile}
starccm+ -batch ../../macros/$macro1 -np ${PBS_NP} -machinefile ${PBS_NODEFILE} -licpath 27005@swlic01.s.uw.edu -batch-report ${starSimFile}.sim 2>&1 | tee log.post_${starSimFile}
cd ../..

echo 'all finished, have a nice day'
