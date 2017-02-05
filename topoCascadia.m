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
addpath(genpath('utilities/mexcdf/R2010b-to-R2012b'))
    javaaddpath('utilities/mexcdf/R2010b-to-R2012b/netcdfAll-4.2.jar');
    javaaddpath('utilities/mexcdf/R2010b-to-R2012b/snctools/classes');
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
% csvwrite_with_headers
% addpath(genpath('utilities/Roms_tools'))  note: this has errors related to function 'netcdf', use the mexcdf version included within ROMS_AGRIF
addpath(genpath('utilities/ROMS_AGRIF'))
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
[OPTIONS, ROMS] = get_ROMS_fields(OPTIONS);

% plot the fields, 3D point cloud overlay with topography/turbine map
% OPTIONS = plot_ROMS_fields(OPTIONS, NED, ROMS);

% map the ROMS variables onto the STAR-CCM+ mesh
% interpolate the ROMS rho points onto a higher resolution mesh
% including inlet/outlet/coastline boundaries would be unknown
% at this point, until after the STAR-CCM+ mesh is already built
% so load the mesh directory as an STL file and then 3D interpolate
% onto the vertices of the STL file, or can load the mesh points
% as a point cloud of CSV values with the cell centroids.
% Then 3D interpolate onto this point cloud and load the 
% CSV File Table back into starccm.
% Do this with the velocity field, and turbuluence fields (and pressure?)
% 
% 
% 

% read the CSV for the cell centroids of STARCCM mesh
M      = csvread(['cases' filesep OPTIONS.casename filesep 'mesh_centroids_domain.csv'],2,1);
mesh_x = M(:,1);
mesh_y = M(:,2);
mesh_z = M(:,3);
mesh_n = size(M,1);

% initialize velocities, turbulent kinetic energy, and dissipation rate
mesh_vel_x = zeros(mesh_n,1);
mesh_vel_y = zeros(mesh_n,1);
mesh_vel_z = zeros(mesh_n,1);
% mesh_tke   = zeros(mesh_n,1);
% mesh_eps   = zeros(mesh_n,1);

% build the scattered interpolation functions
F_vel_x = scatteredInterpolant(ROMS.yEast_aa(:), ROMS.xNorth_aa(:), ROMS.zDown_aa(:), ROMS.u_rho_aa(:),'linear','nearest');
F_vel_y = scatteredInterpolant(ROMS.yEast_aa(:), ROMS.xNorth_aa(:), ROMS.zDown_aa(:), ROMS.v_rho_aa(:),'linear','nearest');
F_vel_z = scatteredInterpolant(ROMS.yEast_aa(:), ROMS.xNorth_aa(:), ROMS.zDown_aa(:), ROMS.w_rho_aa(:),'linear','nearest');
% F_tke   = asdf;
% F_eps   = asdf;

for n = 1:mesh_n
    
    mesh_vel_x(n) = F_vel_x(mesh_x(n), mesh_y(n), mesh_z(n));
    mesh_vel_y(n) = F_vel_y(mesh_x(n), mesh_y(n), mesh_z(n));
    mesh_vel_z(n) = F_vel_z(mesh_x(n), mesh_y(n), mesh_z(n));
%     mesh_tke(n)   = F_tke(mesh_x(n), mesh_y(n), mesh_z(n));
%     mesh_eps(n)   = F_eps(mesh_x(n), mesh_y(n), mesh_z(n));
%     n/mesh_n
end

% now write the field data again
% save data in CSV file format, for reading by STAR-CCM+

% over area of interest
csv_filename_aa = [OPTIONS.dir_case filesep 'STARCCM_xyzuvw_area_interest.csv'];
xyzuvw_aa       = [mesh_x(:) mesh_y(:) mesh_z(:) mesh_vel_x(:) mesh_vel_y(:) mesh_vel_z(:)];

% if the file already exists, overwrite
if exist(csv_filename_aa, 'file')==2
  delete(csv_filename_aa);
end

% write the header and then append the data
fid = fopen(csv_filename_aa, 'w');
fprintf(fid, 'X,Y,Z,u,v,w\n');
fclose(fid);
dlmwrite(csv_filename_aa, xyzuvw_aa, '-append', 'precision', '%.6f', 'delimiter', ',');






% make a plot with vfplot, first convert to GRD format
% grdwrite2(lat(:,1),lon(1,:),u,'/mnt/data-RAID-1/danny/topo-cascadia/vfplot_ainlet/u.grd');
% grdwrite2(lat(:,1),lon(1,:),v,'/mnt/data-RAID-1/danny/topo-cascadia/vfplot_ainlet/v.grd');

disp('cool dude')


%% extract solution from the ROMS mesh and map to the CFD mesh

% try to get RSLICE or AGRIF to work here

% try rslice first

%% is it time to interpolate the two meshes together
% try to use RegularizeData3D
% [zgrid,xgrid,ygrid] = RegularizeData3D(x,y,z,xnodes,ynodes,varargin)



