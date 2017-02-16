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
    OPTIONS.run_starccm_command1 = ['starccm+ -new -batch ../../macros/_main_ROMS_nesting_step1_Meshing.java -np ${PBS_NP} -machinefile ${PBS_NODEFILE} -licpath ' lic_server ' -batch-report ' OPTIONS.casename '.sim 2>&1 | tee log.' OPTIONS.casename];
    OPTIONS.run_starccm_command2 = ['starccm+      -batch ../../macros/_main_ROMS_nesting_step2_Solution.java -np ${PBS_NP} -machinefile ${PBS_NODEFILE} -licpath ' lic_server ' -batch-report ' OPTIONS.casename '.sim 2>&1 | tee log.' OPTIONS.casename];
%     run_starccm_command2 = ['starccm+ -batch macros/AMR_Initialize.java -np ${PBS_NP} -machinefile ${PBS_NODEFILE} -licpath ' lic_server ' -batch-report runs_' Mooring.casename '.sim 2>&1 | tee log.' Mooring.casename];
%     run_starccm_command3 = ['starccm+ -batch macros/AMR_Main.java -np ${PBS_NP} -machinefile ${PBS_NODEFILE} -licpath ' lic_server ' -batch-report runs_' Mooring.casename '.sim 2>&1 | tee log.' Mooring.casename];
else
    % if on your local workstation, PBS variables are not used, and the license server is different
    OPTIONS.run_starccm_command1 = ['starccm+ -new -batch ../../macros/_main_ROMS_nesting_step1_Meshing.java -np ' num2str(OPTIONS.nCPUs) ' -licpath ' lic_server ' -batch-report ' OPTIONS.casename '.sim 2>&1 | tee log.' OPTIONS.casename];
    OPTIONS.run_starccm_command2 = ['starccm+      -batch ../../macros/_main_ROMS_nesting_step2_Solution.java -np ' num2str(OPTIONS.nCPUs) ' -licpath ' lic_server ' -batch-report ' OPTIONS.casename '.sim 2>&1 | tee log.' OPTIONS.casename];
%     run_starccm_command2 = ['starccm+ -batch macros/AMR_Initialize.java -np ' num2str(Mooring.OptionsCFD.nCPUs) ' -licpath ' lic_server ' -batch-report runs_' Mooring.casename '.sim 2>&1 | tee log.' Mooring.casename];
%     run_starccm_command3 = ['starccm+ -batch macros/AMR_Main.java -np ' num2str(Mooring.OptionsCFD.nCPUs) ' -licpath ' lic_server ' -batch-report runs_' Mooring.casename '.sim 2>&1 | tee log.' Mooring.casename];
end


%% INITIALIZE parallel Matlab (tested in R2015b ... it may not work in older versions like R2011b)
% because of reasons, ensure that you have no files open when opening the parallel pool
fclose('all');

delete(gcp('nocreate')); % in case we are re-sizing the pool, or this option deactivated
if OPTIONS.nCPUs > 1           
    parpool('local',OPTIONS.nCPUs);
end

