#!/bin/sh

echo "HELLO" 2>&1 | tee log.HELLO
pwd

module load matlab_2015b

## RUN a matlab script
matlab -nodesktop -nosplash < ../../utilities/topo-Cascadia/mesh_mapping.m 2>&1 | tee log.mesh_mapping

