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

% create a new empty file and then save it ... it will always have the same name
% then rename the empty file with a meaningful filename (weird, but I could not figure out how improve starccm about this)
% system(['starccm+ -batch macros/init_EmptySimFile.java -np 1 -licpath ' lic_server ' -new']);
% system(['mv empty_case.sim runs_' Mooring.casename '.sim']);

% the actual command to run starccm+
if OPTIONS.runOnHPC
    % qsub already been called and Matlab will already be running (waiting
    % for starccm to complete), so instead assume we are already in an active batch session
    % meaning the PBS variables will be available to use
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

%% now run starccm
% 
% % note: this initial run will not have run all the rotor-speed update stages 
% system(run_starccm_command1);
% ['starccm+ -batch macros/init_EmptySimFile.java -np 1 -licpath ' lic_server ' -new']);
% system(['mv empty_case.sim runs_' Mooring.casename '.sim']);
% 
% % the actual command to run starccm+
% if Mooring.OptionsCFD.runOnHPC
%     % qsub already been called and Matlab will already be running (waiting
%     % for starccm to complete), so instead assume we are already in an active batch session
%     % meaning the PBS variables will be available to use
%     run_starccm_command1 = ['starccm+ -batch macros/_main.java -np ${PBS_NP} -machinefile ${PBS_NODEFILE} -licpath ' lic_server ' -batch-report runs_' Mooring.casename '.sim 2>&1 | tee log.' Mooring.casename];
%     run_starccm_command2 = ['starccm+ -batch macros/AMR_Initialize.java -np ${PBS_NP} -machinefile ${PBS_NODEFILE} -licpath ' lic_server ' -batch-report runs_' Mooring.casename '.sim 2>&1 | tee log.' Mooring.casename];
%     run_starccm_command3 = ['starccm+ -batch macros/AMR_Main.java -np ${PBS_NP} -machinefile ${PBS_NODEFILE} -licpath ' lic_server ' -batch-report runs_' Mooring.casename '.sim 2>&1 | tee log.' Mooring.casename];
% else
%     % if on your local workstation, PBS variables are not used, and the license server is different
%     run_starccm_command1 = ['starccm+ -batch macros/_main.java -np ' num2str(Mooring.OptionsCFD.nCPUs) ' -licpath ' lic_server ' -batch-report runs_' Mooring.casename '.sim 2>&1 | tee log.' Mooring.casename];
%     run_starccm_command2 = ['starccm+ -batch macros/AMR_Initialize.java -np ' num2str(Mooring.OptionsCFD.nCPUs) ' -licpath ' lic_server ' -batch-report runs_' Mooring.casename '.sim 2>&1 | tee log.' Mooring.casename];
%     run_starccm_command3 = ['starccm+ -batch macros/AMR_Main.java -np ' num2str(Mooring.OptionsCFD.nCPUs) ' -licpath ' lic_server ' -batch-report runs_' Mooring.casename '.sim 2>&1 | tee log.' Mooring.casename];
% end
% 
% %% now run starccm
% 
% % note: this initial run will not have run all the rotor-speed update stages 
% system(run_starccm_command1);


