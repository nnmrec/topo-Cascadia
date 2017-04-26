function [] = topoCascadia(OPTIONS)
%-----------------------------------------------------------------------------%
% topo-Cascadia
% 
% Purpose of this code:
%   to facilitate extraction of topography data for meshing in CFD software
%
% last modified by Danny Clay Sale in Dec 2016
%-----------------------------------------------------------------------------%
%                         
% Inputs: see the file topoCascadia_UserInputs.m to create the OPTIONS
% structure, which is a miscellaneous set of user choices to run this
% program
%
% Here is some information about the bathymetry set used in this 
% 'minimal working example' of the 'topo-Cascadia' repository:
%
% The only working example at the moment is related to Puget Sound, and
% here is some info about the example bathymetry set:
% 
% Title:
%     Combined bathymetry and topography of the Puget Lowlands, 
%     Washington State (tile: g1230485) 
% Abstract:
%     This dataset represents a composite of the best-available bathymetry and 
%      topography for Puget Sound, Hood Canal, Lake Washington and the surrounding 
%      lowlands as of January 2005. 
% Supplemental_Information:
%     Although a large percentage of the data is derived from state-of-the-art 
%     mapping systems collected as recently as 2004 (including laser altimetry and 
%     swath bathymetry) it was sometimes necessary to rely on very old datasets such as 
%     lead-line from the 1930's to complete the model. Care was taken to ensure that each 
%     dataset was properly projected, resampled and adjusted into a common vertical and 
%     horizontal datum (NAVD88 and NAD83 respectively). Obvious artifacts in the data were 
%     removed where this was easily done, and an effort was made to smooth the transition 
%     between datasets to minimize the number of spurious artifacts along data set margins. 
% How should this topography data set be cited?
%         David Finlayson, School of Oceanography, University of , 20050124, Combined bathymetry and 
%         topography of the Puget Lowlands, Washington State (tile: g1230485).
%         Online Links:
%             <http://www.ocean.washington.edu/data/pugetsound/> 
%            
% How should this Matlab code be cited?
%         Danny Sale, github.com/topoCascadia
%-----------------------------------------------------------------------------%


%% add all the dependencies

% test that this works from a 'clean slate'
% close all
% clear all
% clearvars
% clc

% restoredefaultpath
% this is the newly developed contributions:
addpath(genpath('utilities/topo-Cascadia'))

% lots of these tools were found around the web, especially matlab file
% exchange, some great stuff, thanks world ;)
% more info about MexCDF is here: http://mexcdf.sourceforge.net/downloads/
% addpath(genpath('utilities/mexcdf/R2013a-and-above'))
%     javaaddpath('utilities/mexcdf/R2013a-and-above/netcdfAll-4.3.jar');
%     javaaddpath('utilities/mexcdf/R2013a-and-above/snctools/classes');
% if you have a different version of Matlab you may need a different version of MexCDF
% addpath(genpath('utilities/mexcdf/R2010b-to-R2012b'))
%     javaaddpath('utilities/mexcdf/R2010b-to-R2012b/netcdfAll-4.2.jar');
%     javaaddpath('utilities/mexcdf/R2010b-to-R2012b/snctools/classes');
% addpath(genpath('utilities/mexcdf'))    
addpath('utilities/Inpaint_nans')    
addpath('utilities/interparc')
addpath('utilities/linecurvature_version1b')
addpath('utilities/bezier_')
addpath('utilities/dem')
addpath(genpath('utilities/shadem_v6'))
addpath(genpath('utilities/stlTools'))
addpath(genpath('utilities/pandora'))
addpath(genpath('utilities/Inpaint_nans'))
addpath('utilities/writedxfline')
% addpath('utilities/writedxf')
% addpath('utilities/DXFLib_v0.9.1')
addpath('utilities/circlePlane3D')
addpath('utilities/CsvWriter')
addpath('utilities/vtkwrite')
% csvwrite_with_headers
% addpath(genpath('utilities/Roms_tools'))  note: this has errors related to function 'netcdf', use the mexcdf version included within ROMS_AGRIF
addpath(genpath('utilities/ROMS_AGRIF'))
addpath(genpath('utilities/quiver2'))
addpath(genpath('utilities/arrow'))
addpath('utilities/parfor_progress')
% addpath(genpath('utilities/roms_wilkin'))
% addpath('utilities/Arango_SVN_tools')

% %% here are a bunch of other codes i tried to incorporate at some stage,
% perhaps later they will be included within the code repository, but I
% have to check all the licenses to make sure it's okay
% 
% % add the Pandora functions to search path (do I really need these? maybe just snctools, in case add my own versions)
% addpath('/mnt/data-RAID-1/danny/marine-star-master/topo-Cascadia/utilities/pandora')
% % addpath('/mnt/data-RAID-1/danny/marine-star-master/topo-Cascadia/utilities/pandora/Z_functions')
% % 
% % addpath(genpath('/mnt/data-RAID-1/danny/marine-star-master/topo-Cascadia/utilities/rslice'))
% addpath(genpath('/mnt/data-RAID-1/danny/marine-star-master/topo-Cascadia/utilities/snc_roms_get_grid'))
% 
% addpath(genpath('/mnt/data-RAID-1/danny/marine-star-master/topo-Cascadia/utilities/shadem_v6/'))
% addpath(genpath('/mnt/data-RAID-1/danny/marine-star-master/topo-Cascadia/utilities/stlTools/'))
% addpath(genpath('/mnt/data-RAID-1/danny/marine-star-master/topo-Cascadia/utilities/linecurvature_version1b/'))
% addpath('/mnt/data-RAID-1/danny/marine-star-master/topo-Cascadia/utilities/nearestneighbour/')
% 
% 
% addpath('/mnt/data-RAID-1/danny/marine-star-master/topo-Cascadia/utilities/bezier_/')
% % addpath('/mnt/data-RAID-1/danny/marine-star-master/topo-Cascadia/utilities/akima/')
% addpath('/mnt/data-RAID-1/danny/marine-star-master/topo-Cascadia/utilities/interparc/')
% addpath(genpath('/mnt/data-RAID-1/danny/marine-star-master/topo-Cascadia/utilities/RegularizeData3D/'))
% addpath(genpath('/mnt/data-RAID-1/danny/marine-star-master/topo-Cascadia/utilities/lldistkm/'))
% addpath(genpath('/mnt/data-RAID-1/danny/marine-star-master/topo-Cascadia/utilities/geodetic297/'))
% addpath(genpath('/mnt/data-RAID-1/danny/marine-star-master/topo-Cascadia/utilities/InterPointDistanceMatrix/'))
% addpath(genpath('/mnt/data-RAID-1/danny/marine-star-master/topo-Cascadia/utilities/geom3d-2016.03.02/'))
% addpath(genpath('/mnt/data-RAID-1/danny/marine-star-master/topo-Cascadia/utilities/surf2solid/'))
% addpath(genpath('/mnt/data-RAID-1/danny/marine-star-master/topo-Cascadia/utilities/writedxfline/'))
% addpath(genpath('/mnt/data-RAID-1/danny/marine-star-master/topo-Cascadia/utilities/DXFLib_v0.9.1/'))

% addpath(genpath('/mnt/data-RAID-1/danny/marine-star-master/topo-Cascadia/utilities/CsvWriter/'))
% % addpath(genpath('/mnt/data-RAID-1/danny/marine-star-master/topo-Cascadia/utilities/Roms_tools/'))
% addpath(genpath('/mnt/data-RAID-1/danny/marine-star-master/topo-Cascadia/utilities/ROMS_AGRIF/'))
% % addpath(genpath('/mnt/data-RAID-1/danny/marine-star-master/topo-Cascadia/utilities/strings/'))
% % addpath('/mnt/data-RAID-1/danny/marine-star-master/topo-Cascadia/utilities/fixgaps/')
% % addpath(genpath('/mnt/data-RAID-1/danny/marine-star-master/topo-Cascadia/utilities/near2/'))
% % addpath(genpath('/mnt/data-RAID-1/danny/marine-star-master/topo-Cascadia/utilities/lla2eceg/'))
% % addpath('/mnt/data-RAID-1/danny/marine-star-master/topo-Cascadia/utilities/haxby/')

%% 

% init the case directory and various data structures
OPTIONS = init_topoCascadia(OPTIONS);

% select the area of interest
% choose the extent of the gridded data set
% psdem_nc_plot           % should probably put any of this into the "extract" stage
% psdem_extract           % extracts a region of interest from the gridded data set (avoid loading all data at once)
% psdem_extraction_plot   % will do some plotting routines of the data set

[OPTIONS, ROMS, Topo] = select_area_interest(OPTIONS);
% select_area_interest() returns info about the 
% ROMS grid, 
% Topography in lat/lon/elevation
% and Coastline coordinates (in lat/lon and NED)


% convert Topography data to NED coordinate system, include coastline here
[OPTIONS, Topo] = convert_LatLon_Topo(OPTIONS,Topo);
% OPTIONS = plot_coastline_resampled(Topo.lat,Topo.lon,Topo.z,Topo, OPTIONS)
OPTIONS = plot_NED(Topo.yEast, Topo.xNorth, Topo.zDown, Topo.Coast, OPTIONS);

%
% interesting if SeabedSource='ROMS' the above and below plots should be
% identical ... why is there a difference? both load the same .nc file
% Topo gets zDown at W points. ROMS gets zDown at W points. both get horz
% grid on rho points.
% BUG: there is a 1 index difference between how each function selects the
% aa box
%
% convert ROMS variables to NED coordinate system
[OPTIONS, ROMS] = convert_LatLon_ROMS(OPTIONS,ROMS);

% add coastline to the topography, in Lat-Lon 
% OPTIONS = addCoastline_addTurbines(OPTIONS);
% [OPTIONS, Coast] = add_Coastline(OPTIONS, Coast);
% [OPTIONS, Coast, Topo] = add_Coastline(OPTIONS, Coast);


% convert Topography data to the NED coordinate system, include the ROMS
% data here too
% [OPTIONS, NED] = convert_LatLon_NED(OPTIONS, Topo, Coast);

% OPTIONS = plot_NED(NED.Topo.yEast, NED.Topo.xNorth, NED.Topo.zDown, NED.Coast, OPTIONS);

% this will plot the entire ROMS domain in NED coordinates
roms_x = squeeze(ROMS.yEast(1,:,:));
roms_y = squeeze(ROMS.xNorth(1,:,:));
roms_z = -1 .* squeeze(ROMS.zDown(1,:,:));
OPTIONS = plot_NED(roms_x,roms_y,roms_z, Topo.Coast, OPTIONS);
% this will plot the area-of-interest ROMS domain in NED coordinates
roms_x_aa = squeeze(ROMS.yEast_aa(1,:,:));
roms_y_aa = squeeze(ROMS.xNorth_aa(1,:,:));
roms_z_aa = squeeze(ROMS.zDown_aa(1,:,:));
OPTIONS = plot_NED(roms_x_aa,roms_y_aa,roms_z_aa, Topo.Coast, OPTIONS);


% now use the point & click interface to add turbine locations
% [OPTIONS, TURBS] = placeTurbines(xNorth, yEast, zDown, Coast, OPTIONS);
OPTIONS = placeTurbines(Topo.xNorth, Topo.yEast, Topo.zDown, OPTIONS); % this requires the figure handle as input
% OPTIONS = placeTurbines(ROMS.xNorth, ROMS.yEast, ROMS.zDown, OPTIONS);

% now make the STL geometry used to build the STAR-CCM+ mesh
%export STL files for starccm+ meshing
OPTIONS = make_CFD_mesh(OPTIONS, Topo);

% now can make a system call to STAR-CCM+, running the macros to make the
% mesh, or start the solver

% extract solution from the ROMS mesh and map to the CFD mesh
% builds upon ROMS_AGRIF tools to manipulate the ROMS variables
% profile on
[OPTIONS, ROMS] = get_ROMS_fields(OPTIONS.fileTopo_ROMS,OPTIONS,ROMS,true);
% profile viewer

save(['cases' filesep OPTIONS.casename filesep 'mesh_ROMS.mat'], ...
     'OPTIONS','ROMS')

%%
% select_times_interest(OPTIONS, ROMS);

   
%%

% Run STARCCM to create the mesh and then import into Matlab
% see examples to run STARCCM like here https://github.com/nnmrec/UWMooringDynamics/blob/master/CFD/utilities/run_starccm.m

cwd = pwd;

% run the starccm meshing ... NOTE: this does NOT include any turbines in this mesh yet
cd(OPTIONS.dir_case)
status_mesh = system(OPTIONS.run_starccm_Meshing);
cd(cwd)


% optionally, can run the solver for all cases without turbines now


% now add the turbines and re-mesh
cd(OPTIONS.dir_case)
status_turbines = system(OPTIONS.run_starccm_Turbines);
cd(cwd)




% % perform interpolation from ROMS RHO points to the STAR-CCM+ cell
% % centroids, need to re-map at every time in the tidal cycle
% csv_filename_aa = [OPTIONS.dir_case filesep 'STARCCM_tables_ROMS_area_interest.csv'];
% mesh_mapping(OPTIONS, ROMS, csv_filename_aa)
% 
% % load ROMS boundary conditions to starccm and then run solver
% cd(OPTIONS.dir_case)
% status2 = system(OPTIONS.run_starccm_command2);
% cd(cwd)

 



% make a plot with vfplot, first convert to GRD format
% grdwrite2(lat(:,1),lon(1,:),u,'/mnt/data-RAID-1/danny/topo-cascadia/vfplot_ainlet/u.grd');
% grdwrite2(lat(:,1),lon(1,:),v,'/mnt/data-RAID-1/danny/topo-cascadia/vfplot_ainlet/v.grd');

disp('all done. cool dude.')


%%  NOW, all the above was to create the mesh
% here, we can use the same mesh, but apply different boundary conditions
% from different ROMS files
% loop through the ROMS files you want to use

% keep a copy of the STARCCM sim file before boundary conditions are applied
oldName  = [OPTIONS.dir_case filesep OPTIONS.casename '.sim'];          % the original file is setup always for Flood Tide
initName = [OPTIONS.dir_case filesep OPTIONS.casename '__init.sim'];    % this file is temporary

% nesting_times = [1812 1840 1912 1936];
% nesting_tide  = {'flood' 'ebb' 'flood' 'ebb'};
nesting_times = [1812 1840];
nesting_tide  = {'flood' 'ebb'};

for n = 1:numel(nesting_times)
    
    % get the ROMS fields for current timestep
    file_ROMS                = [OPTIONS.dir_ROMS filesep 'ocean_his_' sprintf('%4.4d',nesting_times(n)) '.nc'];
    [OPTIONS, ROMS_snapshot] = get_ROMS_fields_v2(file_ROMS,OPTIONS,true);
    
    % write the ROMS field variables at mesh locations of the STARCCM mesh
    csv_filename_aa = [OPTIONS.dir_case filesep 'STARCCM_tables_ROMS-ocean_his_' sprintf('%4.4d',nesting_times(n)) '.csv'];
    mesh_mapping(OPTIONS, ROMS_snapshot, csv_filename_aa)
    
    % copy this mesh file and rename since the starccm macros always looks for the same temporary filename
    system(['cp ' csv_filename_aa ' ' OPTIONS.dir_case filesep 'STARCCM_tables_ROMS.csv']);
    system(['cp ' oldName ' ' initName]);
    
    % Mapping between ROMS and STARCCM meshes, swap the inlets/outlets if needed   
    switch nesting_tide{n}
        case 'flood'
            cd(OPTIONS.dir_case)
            status_map = system(OPTIONS.run_starccm_Mapping_Flood);
            cd(cwd)
            
        case 'ebb'
            cd(OPTIONS.dir_case)
            status_map = system(OPTIONS.run_starccm_Mapping_Ebb);
            cd(cwd)
    end
    
%     % Now add the turbines and re-mesh
%     cd(OPTIONS.dir_case)
% 	status_map = system(OPTIONS.run_starccm_AddTurbines);
% 	cd(cwd)
    
    % now for each ROMS timestep, rename the file for corresponding timestep
    newName = [OPTIONS.dir_case filesep OPTIONS.casename '__ocean_his_' sprintf('%4.4d',nesting_times(n)) '.sim'];
    system(['mv ' initName ' ' newName]);
    
end

         
    
% % run the solver on each time
% for n = 1:numel(nesting_times)
%     
%     
% end

