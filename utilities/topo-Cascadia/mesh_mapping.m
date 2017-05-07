function [] = mesh_mapping(OPTIONS, ROMS, csv_filename_aa)


% executed from within the STAR-CCM+ cases directory
% load the ROMS mesh
% load('mesh_ROMS.mat')
% load(['cases' filesep OPTIONS.casename filesep 'mesh_ROMS.mat']);

% pwd

% read the CSV for the cell centroids of STARCCM mesh
% M      = csvread(['cases' filesep OPTIONS.casename filesep 'mesh_centroids_domain.csv'],2,1);
M      = csvread(['cases' filesep OPTIONS.casename filesep 'mesh_centroids_BC.csv'],2,1);
mesh_x = M(:,1);
mesh_y = M(:,2);
mesh_z = M(:,3);
mesh_n = size(M,1);

% initialize velocities, turbulent kinetic energy, and dissipation rate
mesh_vel_x = zeros(mesh_n,1);
mesh_vel_y = zeros(mesh_n,1);
mesh_vel_z = zeros(mesh_n,1);
mesh_tke   = zeros(mesh_n,1);
mesh_eps   = zeros(mesh_n,1);   % k-epsilon eps=turbulent dissipation rate, k-omega omg=specific dissipation rate
mesh_omg   = zeros(mesh_n,1);

% omega is approximately the ratio of epsilon to tke

% build the scattered interpolation functions
F_vel_x = scatteredInterpolant(ROMS.yEast_aa(:), ROMS.xNorth_aa(:), ROMS.zDown_aa(:), ROMS.u_rho_aa(:),'linear','nearest');
F_vel_y = scatteredInterpolant(ROMS.yEast_aa(:), ROMS.xNorth_aa(:), ROMS.zDown_aa(:), ROMS.v_rho_aa(:),'linear','nearest');
F_vel_z = scatteredInterpolant(ROMS.yEast_aa(:), ROMS.xNorth_aa(:), ROMS.zDown_aa(:), ROMS.w_rho_aa(:),'linear','nearest');
F_tke   = scatteredInterpolant(ROMS.yEast_aa(:), ROMS.xNorth_aa(:), ROMS.zDown_aa(:), ROMS.tke_aa(:),'linear','nearest');
F_eps   = scatteredInterpolant(ROMS.yEast_aa(:), ROMS.xNorth_aa(:), ROMS.zDown_aa(:), ROMS.eps_aa(:),'linear','nearest');
F_omg   = scatteredInterpolant(ROMS.yEast_aa(:), ROMS.xNorth_aa(:), ROMS.zDown_aa(:), ROMS.omg_aa(:),'linear','nearest');

init_progress = 5; % 5 percent
% for some reason this is much slower in a parfor loop
% parfor_progress(mesh_n); % Initialize a progress bar that works in a parallel loop                            
for n = 1:mesh_n
% parfor n = 1:mesh_n
    mesh_vel_x(n) = F_vel_x(mesh_x(n), mesh_y(n), mesh_z(n));
    mesh_vel_y(n) = F_vel_y(mesh_x(n), mesh_y(n), mesh_z(n));
    mesh_vel_z(n) = F_vel_z(mesh_x(n), mesh_y(n), mesh_z(n));
    mesh_tke(n)   = F_tke(mesh_x(n), mesh_y(n), mesh_z(n));
    mesh_eps(n)   = F_eps(mesh_x(n), mesh_y(n), mesh_z(n));
    mesh_omg(n)   = F_omg(mesh_x(n), mesh_y(n), mesh_z(n));
    
    progress = n/mesh_n * 100; % progress
    if progress >= init_progress
        disp('mesh mapping completed percent (%)')
        disp(progress)
        init_progress = init_progress + 5;
    end
    
%     parfor_progress; % Count 
end
% parfor_progress(0); % Clean up

xyzuvw_aa = [mesh_x(:) mesh_y(:) mesh_z(:) mesh_vel_x(:) mesh_vel_y(:) mesh_vel_z(:) mesh_tke(:) mesh_eps(:) mesh_omg(:)];


% if the file already exists, overwrite
if exist(csv_filename_aa, 'file')==2
  delete(csv_filename_aa);
end
 
% write the header and then append the data
fid = fopen(csv_filename_aa, 'w');
fprintf(fid, 'X,Y,Z,u,v,w,tke,eps,omg\n');
fclose(fid);
dlmwrite(csv_filename_aa, xyzuvw_aa, '-append', 'precision', '%.6f', 'delimiter', ',');


disp('finished ROMS to STARCCM+ mesh mapping')




