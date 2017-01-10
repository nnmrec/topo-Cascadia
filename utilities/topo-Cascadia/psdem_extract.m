% psdem_extract.m  9/15/2008 Parker MacCready
% modified: 4/5/2016 Danny Sale
% this extracts a portion of a plaid-gridded NetCDF file

clear all
close all
clc




%% extract the variables from the NetCDF file within the specified lat/lon refinement
lon1        = nc_varget(OPTIONS.ncfile,'lon');
lat1        = nc_varget(OPTIONS.ncfile,'lat');
lonmask     = lon1>=OPTIONS.aa(1) & lon1<=OPTIONS.aa(2);
latmask     = lat1>=OPTIONS.aa(3) & lat1<=OPTIONS.aa(4);
lon         = lon1(lonmask);
lat         = lat1(latmask);
lon_nstart  = find(lon1 == lon(1));
lat_nstart  = find(lat1 == lat(1));
z           = nc_varget(OPTIONS.ncfile,'elev',[lat_nstart-1 lon_nstart-1],[sum(latmask) sum(lonmask)]);

% save(OPTIONS.outname,'z','lon','lat');
save([OPTIONS.dir_case filesep OPTIONS.casename],'z','lon','lat');


%% load the coastline file, and mask it
coastfile = load([OPTIONS.coastdir,'pnw_coast_detailed.mat']);

% this works fine to remove all NaNs
coastfile.lon = inpaint_nans(coastfile.lon,4);
coastfile.lat = inpaint_nans(coastfile.lat,4);

% use a buffer around the domain, to ensure that the new coastlines fall entirely within the refinement box
dbuf = km2deg(OPTIONS.mbuf / 1000, 'earth');

coast_xy   = [coastfile.lon, coastfile.lat];
coast_mask = coast_xy(:,1) >= OPTIONS.aa(1)-dbuf & coast_xy(:,1) <= OPTIONS.aa(2)+dbuf & ...
             coast_xy(:,2) >= OPTIONS.aa(3)-dbuf & coast_xy(:,2) <= OPTIONS.aa(4)+dbuf;
x_coast    = coast_xy(coast_mask,1);
y_coast    = coast_xy(coast_mask,2);


%% create a new coastline suitable for the CFD meshing
%  cut-off the coastline at a specified distance (requires a coastline file)
%  NOTE: coastline files do not change in time, meaning that a
%  drying/wetting model is not active.  Therefore, maybe you should read
%  the tidal elevation directly from the ROMS netcdf output (this could provide
%  an inconvencience if somebody wants to mesh independent of the ocean model, so in 
%  this case should provide user option to use ROMS code or just elevation data, the zero datum)
[coast, z_mod] = plot_coastline_resampled(lat, lon, z, x_coast, y_coast, OPTIONS);



%% convert to North-East-Down (NED) Cartesian coordinate system (note: this undoes the meshgrid)
% maybe also look into converting NAVD88 to ECEF to NED: http://www.mathworks.com/help/aeroblks/directioncosinematrixeceftoned.html
% NOTE: it looks like the using the reference z0 is important to keep as 0,
% gravity-based geodetic datum is NAVD88 originally (for the topo data)
% so converting from NAVD88 to NED coordinate system gives this ~ 0.6 meter difference
% for a domain of ~ 4x4 kilometers

[LON, LAT] = meshgrid(lon,lat);

% define a reference datum, the center of domain seems a reasonable choice
% although, the z0 elevation may change with sea-level, so perhaps
% it is possible to use ROMS output to set z0?
ilat0       = floor( size(LAT,1)/2 );
llon0       = floor( size(LON,2)/2 );
lat0        = LAT(ilat0,llon0);
lon0        = LON(ilat0,llon0);
% also need a reference spheroid
spheroid    = referenceSphere('earth');

% convert topo coordinates to NED system
[xNorth, yEast, zDown] = geodetic2ned(LAT,LON,z,lat0,lon0,OPTIONS.z0,spheroid); % (this undoes the meshgridding)
% [xNorth, yEast, zDown] = geodetic2ned(LAT,LON,z_mod,lat0,lon0,z0,spheroid); % (this undoes the meshgridding)
zDown = -1*zDown; % I like this convention better

% convert the new coastline to NED system
[coast.xNorth, coast.yEast, coast.zDown] = geodetic2ned(coast.y,coast.x,coast.z,lat0,lon0,OPTIONS.z0,spheroid);
coast.zDown = -1*coast.zDown; % I like this convention better


%% plot it all up in the NED system
plot_NED(yEast, xNorth, zDown, coast, OPTIONS)


%% if all looks good, save a STL file of the topography file
%% save as an STL file for creating CAD geometry
% stlWrite([OPTIONS.outname '.stl'], yEast, xNorth, zDown, 'TRIANGULATION', 'x')
stlWrite([OPTIONS.dir_case filesep 'seabed.stl'], yEast, xNorth, zDown, 'TRIANGULATION', 'x');





%% Lets try OpenSCAD which can read DXF files
%  see here to get started: http://edutechwiki.unige.ch/en/OpenScad_beginners_tutorial 
file_dxf = [OPTIONS.dir_case filesep 'coastline_DXF'];

stl_coast_x = [ coast.yEast;  yEast(end);   coast.yEast(1)];
stl_coast_y = [coast.xNorth; xNorth(end);  coast.xNorth(1)];
writedxf(file_dxf, stl_coast_x, stl_coast_y, OPTIONS.z0.*ones(size(stl_coast_x))) 

heightSTL   = max(zDown(:)) - min(zDown(:));
dx2         = max(yEast(:)) - min(yEast(:));
dy2         = max(xNorth(:)) - min(xNorth(:));
dz2         = 4*heightSTL;
buf_top     = 1.5;      % make it bigger than seabed width, it is only used to boolean subtract at seabed level


cdir = pwd;
cd(OPTIONS.dir_case);   %^ change dir before running OpenSCAD

filescad_coast = fopen([OPTIONS.dir_case filesep 'coastline.scad'],'w');
fprintf(filescad_coast,['dxf_linear_extrude(file="' file_dxf '.dxf", height=' num2str(heightSTL) ', center=true); \n']);
fclose(filescad_coast);
system('openscad -o coastline.stl coastline.scad');

filescad_surface = fopen([OPTIONS.dir_case filesep 'seasurface.scad'],'w');
fprintf(filescad_surface,['translate(' ['[' num2str(-1*buf_top*dx2/2) ', ' num2str(-1*buf_top*dy2/2) ', ' num2str(0) ']'] ') \n']);
fprintf(filescad_surface,['cube(' ['[' num2str(buf_top*dx2) ', ' num2str(buf_top*dy2) ', ' num2str(dz2) '], center=false'] ');']);
fclose(filescad_surface);
system('openscad -o seasurface.stl seasurface.scad');

cd(cdir);

% filescad_seabed = fopen([OPTIONS.dir_case filesep 'seabed-subtract-coastline.scad'],'w');
% fprintf(file_openscad,'difference() { \n');
% fprintf(filescad_seabed,['import("' OPTIONS.outname '.stl"); \n']);
% fprintf(filescad_seabed,['dxf_linear_extrude(file="' file_dxf '.dxf", height=' num2str(2*heightSTL) ', center=true); \n']);
% fprintf(filescad_seabed,'} \n');
% fclose(filescad_seabed);
% system('openscad -o seabed.stl seabed-subtract-coastline.scad');

% for some reason OpenSCAD produces lots of errors in the STL file after
% Boolean stuff (do Booleans in starccm instead)
% NOTE: you may need surface repair, STAR-CCM+, MeshLab, netfabb, or admesh are viable options


%% now use the point & click interface to add turbine locations
turb = placeTurbines(xNorth, yEast, zDown, coast, OPTIONS);





%% now need to extract all the other solution variables from ROMS
%  that will be mapped to the STAR-CCM+ domain
%

%% list and extract some variables from the ROMS netcdf output
OPTIONS.ncfile_ROMS = '/mnt/data-RAID-1/danny/ainlet_2006_3/OUT/ocean_his_0290.nc';
ncdisp(OPTIONS.ncfile_ROMS,'/','min')

% % extract the variables from the NetCDF file within the specified lat/lon refinement
% his.lon1        = nc_varget(OPTIONS.ncfile_ROMS,'lon_u');
% his.lat1        = nc_varget(OPTIONS.ncfile_ROMS,'lat_v');
% his.lonmask     = his.lon1 >= OPTIONS.aa(1) & his.lon1 <= OPTIONS.aa(2);
% his.latmask     = his.lat1 >= OPTIONS.aa(3) & his.lat1 <= OPTIONS.aa(4);
% his.lon         = his.lon1(his.lonmask);
% his.lat         = his.lat1(his.latmask);
% his.lon_nstart  = find(his.lon1 == his.lon(1));
% his.lat_nstart  = find(his.lat1 == his.lat(1));
% 
% 
% % h          
% %            Size:       224x345
% %            Dimensions: xi_rho,eta_rho
% %            Datatype:   double
% his.h       = nc_varget(OPTIONS.ncfile_ROMS,'h',         [his.lat_nstart-1 his.lon_nstart-1],[sum(his.latmask) sum(his.lonmask)]);
% 
% % note .. something wrong with this, originally this is how Parker opened
% % the PSDEM stuff, but the ROMS is probably different ... look into his
% % other codes or AGRIF, or RSLICE
% his.h       = nc_varget(OPTIONS.ncfile_ROMS,'h',         [his.lat_nstart-1 his.lon_nstart-1],[sum(his.latmask) sum(his.lonmask)]);
% his.zeta    = nc_varget(OPTIONS.ncfile_ROMS,'zeta',      [his.lat_nstart-1 his.lon_nstart-1],[sum(his.latmask) sum(his.lonmask)]);
% his.theta_s = nc_varget(OPTIONS.ncfile_ROMS,'theta_s',   [his.lat_nstart-1 his.lon_nstart-1],[sum(his.latmask) sum(his.lonmask)]);
% his.theta_b = nc_varget(OPTIONS.ncfile_ROMS,'theta_b',   [his.lat_nstart-1 his.lon_nstart-1],[sum(his.latmask) sum(his.lonmask)]);
% his.hc      = nc_varget(OPTIONS.ncfile_ROMS,'hc',        [his.lat_nstart-1 his.lon_nstart-1],[sum(his.latmask) sum(his.lonmask)]);

% see Kristen's thesis for more info about correct TKE and Epsilon variables
% gls_m
%     Generic length-scale turbulent kinetic energy exponent
% gls_n
%     Generic length-scale turbulent length scale exponent
% gls_sigk
%     Generic length-scale closure independent constant Schmidt number for turbulent kinetic energy diffusivity    
 
%% inspired by RSLICE
grd = snc_roms_get_grid(OPTIONS.ncfile_ROMS);
% excellent this seemed to work perfect

% now convert into proper z coordinates
% [agrif.lat,agrif.lon,agrif.mask,agrif.spd] = get_speed_depth_avg(OPTIONS.ncfile_ROMS,OPTIONS.ncfile_ROMS,1,[],1);
NED = convert_z_NED(OPTIONS.ncfile_ROMS,1,1);

roms.xNorth = zeros(size(NED.Z));
roms.yEast  = zeros(size(NED.Z));
roms.zDown  = zeros(size(NED.Z));
for n = 1:size(NED.Z,1);
    
%     % compute the values at u,v and psi points...
%     [w_ufield,w_vfield,w_pfield]=rho2uvp(u);
%     [w_ufield,w_vfield,w_pfield]=rho2uvp(v);
%     [w_ufield,w_vfield,w_pfield]=rho2uvp(w);


    [roms.xNorth(n,:,:), roms.yEast(n,:,:), roms.zDown(n,:,:)] = geodetic2ned(NED.lat,NED.lon,squeeze( NED.Z(n,:,:) ),lat0,lon0,OPTIONS.z0,spheroid); % (this undoes the meshgridding)
end

% now write all the scalar values to a CSV file
% will later load into STAR-CCM+ as a point cloud and then
% use data mapping to interpolate ROMS on to the unstructured finite-volume mesh
%
% X   = [turb.x1; turb.x2];
% Y   = [turb.y1; turb.y2];
% Z   = [turb.z1; turb.z2];
% xyz = [X Y Z];
xyz = [roms.xNorth(:) roms.yEast(:) roms.zDown(:)];

csvwrite([OPTIONS.dir_case filesep 'roms_u.csv'], [xyz roms.u]);


%% my idea for the data mapping ... 
%  export from matlab the entire 3D grid in the NED coordinate system
%  if not directly in ccm format, what other format can STAR-CCM+ easily import?
%  import



%%

% try the ROMS AGRIF codes
% basic idea how to hack this:
% figure out how to make a plot without clicking through the GUI,
% or at least hack a way to refresh the plot by cycling through a directory
% of ROMS output files.  Add the nice plotting and NED coordinate
% transforms, then export the vel field on the nested domain boundaries

roms_gui

% get the depths, properly computed
% z = zlevs(h,zeta,theta_s,theta_b,hc,N,type,vtransform)
Z=squeeze(zlevs(h,zeta,theta_s,theta_b,hc,Nr,type,s_coord));



h,zeta,theta_s,theta_b,hc















%% save as a VTK file for visualization with VisIt or ParaView, or VAPOR


%% now use RSLICE to extract the flow fields at this bounding box

