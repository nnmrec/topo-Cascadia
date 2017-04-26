function OPTIONS = init_topoCascadia(OPTIONS)

%% setup the case directory, where any newly generated files will be stored
OPTIONS.dir_case = ['cases' filesep OPTIONS.casename];

mkdir(OPTIONS.dir_case);


%% setup STAR-CCM+ to run on your local *nix/GNU computer or supercomputer ... sorry Windows is not supported! :-P
%  initialize the starccm file(s)

% determine the starccm license server
if OPTIONS.runOnHPC
    lic_server = '1999@mgmt2.hyak.local';
else
    lic_server = '1999@lmas.engr.washington.edu';
end

% the actual command to run starccm+
if OPTIONS.runOnHPC
    OPTIONS.run_starccm_Meshing       = ['starccm+ -new -batch ../../macros/_main_ROMS_nesting_step1_Meshing.java       -np ${PBS_NP} -machinefile ${PBS_NODEFILE} -licpath ' lic_server ' -batch-report ' OPTIONS.casename       '.sim 2>&1 | tee log.' OPTIONS.casename];
    OPTIONS.run_starccm_Turbines      = ['starccm+      -batch ../../macros/_main_ROMS_nesting_step2_Turbines.java      -np ${PBS_NP} -machinefile ${PBS_NODEFILE} -licpath ' lic_server ' -batch-report ' OPTIONS.casename       '.sim 2>&1 | tee log.' OPTIONS.casename];
    OPTIONS.run_starccm_Mapping_Flood = ['starccm+      -batch ../../macros/_main_ROMS_nesting_step3_Mapping_Flood.java -np ${PBS_NP} -machinefile ${PBS_NODEFILE} -licpath ' lic_server ' -batch-report ' OPTIONS.casename '__init.sim 2>&1 | tee log.' OPTIONS.casename];
    OPTIONS.run_starccm_Mapping_Ebb   = ['starccm+      -batch ../../macros/_main_ROMS_nesting_step3_Mapping_Ebb.java   -np ${PBS_NP} -machinefile ${PBS_NODEFILE} -licpath ' lic_server ' -batch-report ' OPTIONS.casename '__init.sim 2>&1 | tee log.' OPTIONS.casename];
    OPTIONS.run_starccm_Solver        = ['starccm+      -batch ../../macros/_main_ROMS_nesting_step4_Solution.java      -np ${PBS_NP} -machinefile ${PBS_NODEFILE} -licpath ' lic_server ' -batch-report ' OPTIONS.casename '__init.sim 2>&1 | tee log.' OPTIONS.casename];
else
    % if on your local workstation, PBS variables are not used, and the license server is different
    OPTIONS.run_starccm_Meshing       = ['starccm+ -new -batch ../../macros/_main_ROMS_nesting_step1_Meshing.java       -np ' num2str(OPTIONS.nCPUs) ' -licpath ' lic_server ' -batch-report ' OPTIONS.casename       '.sim 2>&1 | tee log.' OPTIONS.casename];
    OPTIONS.run_starccm_Turbines      = ['starccm+      -batch ../../macros/_main_ROMS_nesting_step2_Turbines.java      -np ' num2str(OPTIONS.nCPUs) ' -licpath ' lic_server ' -batch-report ' OPTIONS.casename       '.sim 2>&1 | tee log.' OPTIONS.casename];
    OPTIONS.run_starccm_Mapping_Flood = ['starccm+      -batch ../../macros/_main_ROMS_nesting_step3_Mapping_Flood.java -np ' num2str(OPTIONS.nCPUs) ' -licpath ' lic_server ' -batch-report ' OPTIONS.casename '__init.sim 2>&1 | tee log.' OPTIONS.casename];
    OPTIONS.run_starccm_Mapping_Ebb   = ['starccm+      -batch ../../macros/_main_ROMS_nesting_step3_Mapping_Ebb.java   -np ' num2str(OPTIONS.nCPUs) ' -licpath ' lic_server ' -batch-report ' OPTIONS.casename '__init.sim 2>&1 | tee log.' OPTIONS.casename];
    OPTIONS.run_starccm_Solver        = ['starccm+      -batch ../../macros/_main_ROMS_nesting_step4_Solution.java      -np ' num2str(OPTIONS.nCPUs) ' -licpath ' lic_server ' -batch-report ' OPTIONS.casename '__init.sim 2>&1 | tee log.' OPTIONS.casename];
end


%% INITIALIZE parallel Matlab (tested in R2015b ... it may not work in older versions like R2011b)
% because of reasons, ensure that you have no files open when opening the parallel pool
fclose('all');

delete(gcp('nocreate')); % in case we are re-sizing the pool, or this option deactivated
if OPTIONS.nCPUs > 1           
    parpool('local',OPTIONS.nCPUs);
end

