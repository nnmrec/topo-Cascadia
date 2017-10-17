#!/bin/bash
##
#SBATCH --job-name=topo-smallDomain
#SBATCH --account=fluids
#SBATCH --partition=fluids
#SBATCH --mail-user=sale.danny@gmail.com
#SBATCH --mail-type=ALL
#SBATCH --exclusive
#SBATCH --nodes=1
#SBATCH --ntasks=28
#SBATCH --time=01:00:00
#SBATCH --mem=120G
#SBATCH --workdir=./

NTASKS=$(echo $SLURM_TASKS_PER_NODE | cut -c1-2)
NPROCS=$(expr $SLURM_NNODES \* $NTASKS)

echo 'hello SLURM'
echo 'NTASKS, NPROCS, NNODES = '
echo $NTASKS
echo $NPROCS
echo $NNODES

echo "working directory = " $SLURM_SUBMIT_DIR
echo "SLURM_JOBID="$SLURM_JOBID
echo "SLURM_JOB_NODELIST"=$SLURM_JOB_NODELIST
echo "SLURM_NNODES"=$SLURM_NNODES
echo "SLURMTMPDIR="$SLURMTMPDIR

## Create our hosts file ala slurm
#srun hostname -s &> `pwd`/slurmhosts.$SLURM_JOB_ID.txt


# module load contrib/starccm+_12.02.010
# starSimFile="mySIMfile"
# starMacros="macroMeshAndRun.java"
# starccm+ -batch $starMacros -mpi platform -mppflags "-e MPI_IB_PKEY=0xffff" -batch -licpath 27005@swlic01.s.uw.edu -machinefile slurmhosts.$SLURM_JOB_ID.txt -np $NPROCS -clientcore $starSimFile.sim 2>&1 | tee log.$starSimFile

module load matlab_2017a
module load contrib/openscad
module load contrib/starccm+_12.02.010

## RUN my simulation file in batch mode
starSimFile="topo-Cascadia-ROMS-nesting"
ROMStime="test-SLURM"

matlab -nodesktop -nosplash < topoCascadia_UserInputs_time${ROMStime}.m 2>&1 | tee log.topoCascadia-time${ROMStime}
cd cases/${starSimFile}
echo 'running starccm from directory:'
pwd
# this is the PBS way to run STAR-CCM+ on Hyak "first generation"
# starccm+ -batch ../../macros/_main_ROMS_nesting_step4_Solution.java -np ${PBS_NP} -machinefile ${PBS_NODEFILE} -licpath 1999@mgmt2.hyak.local -batch-report ${starSimFile}.sim 2>&1 | tee log.run_${starSimFile}
# this is the SLURM way to run STAR-CCM+ on Mox, the Hyak "next generation"
starccm+ -batch $starMacros -mpi platform -mppflags "-e MPI_IB_PKEY=0xffff" -licpath 27005@swlic01.s.uw.edu -np $NPROCS -batch-report $starSimFile.sim 2>&1 | tee log.$starSimFile
#starccm+ -batch $starMacros -mpi platform -mppflags "-e MPI_IB_PKEY=0xffff" -licpath 27005@swlic01.s.uw.edu -machinefile slurmhosts.$SLURM_JOB_ID.txt -np $NPROCS -clientcore -batch-report $starSimFile.sim 2>&1 | tee log.run_${starSimFile}
cd ../..
mv cases/${starSimFile} cases/${starSimFile}_time${ROMStime}

echo 'all finished, have a nice day'

