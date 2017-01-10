% function [OPTIONS, TURBS] = placeTurbines(xNorth,yEast,zDown,Coast,OPTIONS)
function OPTIONS = placeTurbines(xNorth,yEast,zDown,OPTIONS)


%%
nTurbines = OPTIONS.nRotors / OPTIONS.nRpT;


%%
% plot_NED(yEast, xNorth, zDown, coast, OPTIONS)
figure(OPTIONS.hfig_NED)
set(0, 'currentfigure', OPTIONS.hfig_NED);  % for figures

%% now point and click the turbine locations and headings
%  Note: for the DOE RM1 dual rotors, this is just placing 1 of the rotors
%  (the partner rotor will be created automatically)

disp('Now place the turbine locations.  On the map, press mouse click, click, click ... ')
[turb.x1, turb.y1] = ginput(nTurbines);

switch OPTIONS.typeDEM
    case 'dem'
        % put into kilomaters
        turb.x1 = turb.x1./1000;
        turb.y1 = turb.y1./1000;

    case 'shadem'
      
        
end
% % put into kilomaters
% turb.x1 = turb.x1./1000;
% turb.y1 = turb.y1./1000;

% the turbine headings (degrees from north)
% turb.heading = 315 .* ones(nTurbines, 1);
% turb.heading = 135 .* ones(nTurbines, 1);
turb.heading = OPTIONS.heading .* ones(nTurbines, 1);

% the partner rotors (are offset but have same heading)
na      = [cosd(turb.heading - 180), sind(turb.heading - 180)];  % convert heading to something easier for the maths
nb      = na*[cosd(90) -sind(90); sind(90) cosd(90)];
ang     = rad2deg( atan2(nb(2), nb(1)) );
turb.x2	= turb.x1 + OPTIONS.spacingRot*cosd(ang);
turb.y2 = turb.y1 + OPTIONS.spacingRot*sind(ang);


%% now compute the proper depths for "hub height" reference

% make coorections to any turbine near the free surface limit
turb.z1 = zeros(nTurbines,1);
turb.z2 = zeros(nTurbines,1);
for n = 1:nTurbines

    r1 = sqrt((turb.x1(n) -  yEast).^2 + ...
              (turb.y1(n) - xNorth).^2);
          
    [~, r1_index] = min(r1(:));
    
    turb.z1(n) = zDown(r1_index) + OPTIONS.hubHeight;
    turb.z2(n) = turb.z1(n);
    
    if turb.z1(n) > -10 - OPTIONS.diaRotor/2  % coast guard clearance 10m
        fprintf(1, 'WARNING: blade tip of turbine ccw: %g is too close to surface by %g meters \n', n, abs(-10 - (turb.z1(n) + OPTIONS.diaRotor/2)));
    end

    hold on;
    circlePlane3D([turb.x1(n), turb.y1(n), turb.z1(n)], ...
                  [na(n,1), na(n,2), 0], ...
                  OPTIONS.diaRotor/2, ...
                  0.1, 1, 'g', '-');
    circlePlane3D([turb.x2(n), turb.y2(n), turb.z2(n)], ...
                  [na(n,1), na(n,2), 0], ...
                  OPTIONS.diaRotor/2, ...
                  0.1, 1, 'm', '-');
end

hold on;
plot3(turb.x1, turb.y1, turb.z1, 'og', 'MarkerSize', 8, 'LineWidth', 2)
plot3(turb.x2, turb.y2, turb.z2, 'om', 'MarkerSize', 8, 'LineWidth', 2)

 
%% format the coordinates for easy copy-paste into a STAR-CCM+ macro
% X   = [turb.x1; turb.x2];
% Y   = [turb.y1; turb.y2];
% Z   = [turb.z1; turb.z2];
% xyz = [X Y Z];

% csvwrite([OPTIONS.dir_case filesep 'turbine-coordinates-xyz.csv'], xyz);


%%
fprintf(1, 'Writing the turbine input file, please enjoy \n');

% some bookkeeping
% filesIO.dir_input      = [pwd filesep 'inputs'];
% filesIO.dir_output     = [pwd filesep 'outputs'];
% filesIO.fileIn_probes  = [filesIO.dir_output filesep 'probes.csv'];
% filesIO.fileIn_rotors  = [filesIO.dir_output filesep 'rotors.csv'];             
% filesIO.fileOut_probes = [filesIO.dir_output filesep 'probes-velocity.csv'];
% filesIO.fileOut_rotors = [filesIO.dir_output filesep 'rotors-velocity.csv'];  
% filesIO.fileOut_thrust = [filesIO.dir_output filesep 'rotors-thrust.csv'];  
% filesIO.fileOut_torque = [filesIO.dir_output filesep 'rotors-torque.csv'];  
      
% load the options for this case
% system(['cp ' filesIO.dir_input filesep optionsFile ' ' filesIO.dir_input filesep 'options.m']);
% run([filesIO.dir_input filesep 'options.m'])
% run('options.m')

%% this section should be within OPTIONS ... add this later similar to the Mezzanine code
% coordinates of turbines (center of rotor), and other properties
rotors.names  = {'ccw_turbine-1'; ...
                 'ccw_turbine-2'; ...
                 'ccw_turbine-3'; ...
                 'ccw_turbine-4'; ...
                 'ccw_turbine-5'; ...
                 'ccw_turbine-6'; ...
                 'ccw_turbine-7'; ...
                 'ccw_turbine-8'; ...
                 'ccw_turbine-9'; ...
                 'ccw_turbine-10'; ...
                 'cw_turbine-1'; ...
                 'cw_turbine-2'; ...
                 'cw_turbine-3'; ...
                 'cw_turbine-4'; ...
                 'cw_turbine-5'; ...
                 'cw_turbine-6'; ...
                 'cw_turbine-7'; ...
                 'cw_turbine-8'; ...
                 'cw_turbine-9'; ...
                 'cw_turbine-10'; ...
                 };


rotors.tables = {'DOE_RM-1'; ...
                 'DOE_RM-1'; ...
                 'DOE_RM-1'; ...
                 'DOE_RM-1'; ...
                 'DOE_RM-1'; ...
                 'DOE_RM-1'; ...
                 'DOE_RM-1'; ...
                 'DOE_RM-1'; ...
                 'DOE_RM-1'; ...
                 'DOE_RM-1'; ...
                 'DOE_RM-1'; ...
                 'DOE_RM-1'; ...
                 'DOE_RM-1'; ...
                 'DOE_RM-1'; ...
                 'DOE_RM-1'; ...
                 'DOE_RM-1'; ...
                 'DOE_RM-1'; ...
                 'DOE_RM-1'; ...
                 'DOE_RM-1'; ...
                 'DOE_RM-1'; ...
                 };

rotor_rpm       = 11.5 .* ones(2*nTurbines,1);
rotor_radius    = 10 .* ones(2*nTurbines,1);
hub_radius      = 0 .* ones(2*nTurbines,1);
rotor_thick     = 2 .* ones(2*nTurbines,1);

% from user mouse input, or could read from a file
x               = [turb.x1; turb.x2];
y               = [turb.y1; turb.y2];
z               = [turb.z1; turb.z2];
nx              = [na(:,1); na(:,1)];
ny              = [na(:,2); na(:,2)];
nz              = 0 .* ones(2*nTurbines,1);

rotors.data = [rotor_rpm, x, y, z, nx, ny, nz, rotor_radius, hub_radius, rotor_thick];

% writeInputsProbes(filesIO,probes);
writeInputsRotors([OPTIONS.dir_case filesep 'rotors.csv'],rotors);

%% collect the output
% ... maybe dont need an output here
% TURBS.asdf = asdf;

end % function




% %% coordinates of the coastline elevations
% % probably easiest to hardcode these value from "topo-cascadia" scripts
% % no ... try to read the STL file mesh and figure out the coordinates
% % in a more programmatic way
% % this stl takes wayyy too much RAM for an STL file of about ~30 megabytes
% 
% % this should be a binary file (should update to an absolute path)
% % file_mesh = 'mesh_seabed-smooth-no-sill_coastlines-vertical_v1.stl';
% % casename = 'mesh_seabed-smooth-no-sill_coastlines-vertical_v1';
% casename = 'Admiralty_10turbines';
% 
% 
% %%
% file_mesh = [pwd filesep casename '.mat'];
% 
% % [v, f, n, c, stltitle] = stlread(file_mesh);
% 
% % read in the coordinates used to make the STL as Matlab format (less memory) 
% load(file_mesh)
% 
% 
% 
% %% set coordinates for turbine placement
% % these are somewhat specific to the DOE Ref Model dual-rotor turbine
% 
% 
% 
% x1 = 10000 .* ones(1, nTurbines);
% x2 = 10000 .* ones(1, nTurbines);
% y1 = linspace(660, 2500, nTurbines);
% y2 = y1 + OPTIONS.spacingRot;
% 
% x1 = linspace(660, 2500, 2*nTurbines);
% x2 = linspace(660, 2500, 2*nTurbines);
% y1 = linspace(660, 2500, 2*nTurbines);
% y2 = y1 + OPTIONS.spacingRot;
% 
% 
% % for a uniform grid
% % x1 = [660, 1120, 1580, 2040, 2500, ...
% %       660, 1120, 1580, 2040, 2500, ...
% %       660, 1120, 1580, 2040, 2500, ...
% %       660, 1120, 1580, 2040, 2500];
% % y1 = [660, 1120, 1580, 2040, 2500, ...
% %       660, 1120, 1580, 2040, 2500, ...
% %       660, 1120, 1580, 2040, 2500, ...
% %       660, 1120, 1580, 2040, 2500];
%   
% %% make coorections to any turbine near the free surface limit
% z1 = zeros(1, nTurbines);
% z2 = zeros(1, nTurbines);
% for n = 1:nTurbines
% 
%     [x_value x_index] = min(abs(x_dom - x1(n)));
%     [y_value y_index] = min(abs(y_dom - y1(n)));
% 
%     
%     z1(n) = zz_total(y_index, x_index) + 30;
%     z2(n) = zz_total(y_index, x_index) + 30;
%     
%     if z1(n) > -10
%         fprintf(1, 'WARNING: turbine %g is too close to surface', n);
%     end
%     
% end
%   
% %% normal vector for each turbine
% na = [-1; 1];
% % from "point & click" on Admiralty map, a staggered grid
% x1 = [570, ...
%       610, ...
%       660, ...   
%       790, ...
%       720, ...   
%       850, ...
%       880, ...
%       920, ...	     
%       1040, ...	
%       1020];
% y1 = [720, ...
%       830, ...
%       930, ...    
%       800, ...
%       690, ...    
%       620, ...
%       720, ...
%       800, ...
%       610, ...
%       690];
% 
%   
% nb  = [cosd(-90) -sind(-90); sind(-90) cosd(-90)]*na;
% ang = rad2deg( atan2(nb(2), nb(1)) );
% x2  = x1 + OPTIONS.spacingRot*cosd(ang);
% y2  = y1 + OPTIONS.spacingRot*sind(ang);
% 
% 
% file_depths = '/mnt/data-RAID-1/danny/star-ccm+/Admiralty-Inlet/depths_for_turbine_coordinates.csv';
% M = csvread(file_depths,1,0); 
% 
% x_dom    = M(:,2);
% y_dom    = M(:,3);
% zz_total = M(:,4);
% 
% % make coorections to any turbine near the free surface limit
% z1 = zeros(1, nTurbines);
% z2 = zeros(1, nTurbines);
% for n = 1:nTurbines
% 
% %     [x_value x_index] = min(abs(x_dom - x1(n)));
% %     [y_value y_index] = min(abs(y_dom - y1(n)));
%     r1 = sqrt((x1(n) - x_dom).^2 + ...
%               (y1(n) - y_dom).^2);
%     r2 = sqrt((x2(n) - x_dom).^2 + ...
%               (y2(n) - y_dom).^2);
%     
%     [r1_value r1_index] = min(r1);
%     [r2_value r2_index] = min(r2);
%     
%     z1(n) = zz_total(r1_index) + 30;
%     z2(n) = z1(n);
%     
%     if z1(n) > -10
%         fprintf(1, 'WARNING: turbine %g is too close to surface', n);
%     end
%     
% end
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% %% format the coordinates for easy copy-paste into a STAR-CCM+ macro
% X = [x1, x2];
% Y = [y1, y2];
% Z = [z1, z2];
% 
% xyz = [X' Y' Z'];
% 
% csvwrite(['turbine-coordinates_' casename '.csv'], xyz);
% 
% %% Plots
% figure()
% 
% exaggerate_z = 1;
% 
% [xx, yy] = meshgrid(x_dom, y_dom);
% 
% surf(xx, yy, zz_total .* exaggerate_z, ...
%     'EdgeColor','none');
% 
% hold on
% nlevels = 21;
% contour3(xx, yy, zz_total .* exaggerate_z, nlevels-1,'r')
% 
% % add labels
% xlabel('streamwise, x (meters)')
% ylabel('crossflow, y (meters)')
% zlabel('depth, z (meters)')
% 
% % adjust appearance
% % demcmap(zz_total, 32)
% % cmap = haxby(nlevels);
% % colormap(cmap);
% colorbar
% shading interp
% % camlight headlight
% camlight left
% camlight right
% lighting gouraud
% % camproj('perspective')
% % axis vis3d
% set(gcf, 'renderer', 'zbuffer')
% 
% 
% 
% 
% % point and click
% view(0,90)
% 
% [xt, yt] = ginput();
% 
% % round to nearest accuracy
% accuracy = 50;  
% xt = round(xt ./ accuracy).*accuracy;
% yt = round(yt ./ accuracy).*accuracy;
% 
% 
% hold on
% scatter3(x1, y1, z1, 'filled')
% scatter3(x2, y2, z2, 'filled')




