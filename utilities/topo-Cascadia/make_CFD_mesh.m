function OPTIONS = make_CFD_mesh(OPTIONS, Topo)
% NOTE: this requires a coastline file, but it could be modified to work
% without a coastline file

%% extract the variables from the NetCDF file within the specified lat/lon refinement
% % lon1        = nc_varget(OPTIONS.fileTopo,'lon');
% % lat1        = nc_varget(OPTIONS.fileTopo,'lat');
% % lonmask     = lon1>=OPTIONS.aa(1) & lon1<=OPTIONS.aa(2);
% % latmask     = lat1>=OPTIONS.aa(3) & lat1<=OPTIONS.aa(4);
% % lon         = lon1(lonmask);
% % lat         = lat1(latmask);
% % lon_nstart  = find(lon1 == lon(1));
% % lat_nstart  = find(lat1 == lat(1));
% % z           = nc_varget(OPTIONS.fileTopo,'elev',[lat_nstart-1 lon_nstart-1],[sum(latmask) sum(lonmask)]);
% % % should also get the variables: velocity u,v,w (mex_cdf cannot read for some reason)
% % % u           = nc_varget(OPTIONS.fileTopo_ROMS,'u',Inf);
% % % v           = nc_varget(OPTIONS.fileTopo_ROMS,'v',[lat_nstart-1 lon_nstart-1],[sum(latmask) sum(lonmask)]);
% % % w           = nc_varget(OPTIONS.fileTopo_ROMS,'w',[lat_nstart-1 lon_nstart-1],[sum(latmask) sum(lonmask)]);
% % % maybe nc_varget only works on the topography files, but the ROMS version
% % % of NetCDF is different?
% % 
% % % nc_dump(OPTIONS.fileTopo)
% % 
% % % save(OPTIONS.outname,'z','lon','lat');
% % save([OPTIONS.dir_case filesep 'extracted_ROMS'],'z','lon','lat');
% % 
% % 
% % %% load the coastline file, and mask it
% % coastfile = load(['inputs' filesep 'bathymetry' filesep 'coast' filesep OPTIONS.dirCoast filesep 'pnw_coast_detailed.mat']);
% % 
% % % this works fine to remove all NaNs (I think, but also causes some
% % % problems with plotting sometimes?)
% % coastfile.lon = inpaint_nans(coastfile.lon,4);
% % coastfile.lat = inpaint_nans(coastfile.lat,4);
% % 
% % % use a buffer around the domain, to ensure that the new coastlines fall entirely within the refinement box
% % dbuf = km2deg(OPTIONS.mbuf / 1000, 'earth');
% % 
% % coast_xy   = [coastfile.lon, coastfile.lat];
% % coast_mask = coast_xy(:,1) >= OPTIONS.aa(1)-dbuf & coast_xy(:,1) <= OPTIONS.aa(2)+dbuf & ...
% %              coast_xy(:,2) >= OPTIONS.aa(3)-dbuf & coast_xy(:,2) <= OPTIONS.aa(4)+dbuf;
% % x_coast    = coast_xy(coast_mask,1);
% % y_coast    = coast_xy(coast_mask,2);
% % 
% % 
% % %% create a new coastline suitable for the CFD meshing
% % % cut-off the coastline at a specified distance (requires a coastline file)
% % % NOTE: coastline files do not change in time, meaning that a
% % % drying/wetting model is not active.  Therefore, maybe you should read
% % % the tidal elevation directly from the ROMS netcdf output (this could provide
% % % an inconvencience if somebody wants to mesh independent of the ocean model, so in 
% % % this case should provide user option to use ROMS code or just elevation data, the zero datum)
% % Coast = plot_coastline_resampled(lat, lon, z, x_coast, y_coast, OPTIONS);
% % 
% % 
% % 
% % %% convert to North-East-Down (NED) Cartesian coordinate system (note: this undoes the meshgrid)
% % % maybe also look into converting NAVD88 to ECEF to NED: http://www.mathworks.com/help/aeroblks/directioncosinematrixeceftoned.html
% % % NOTE: it looks like the using the reference z0 is important to keep as 0,
% % % gravity-based geodetic datum is NAVD88 originally (for the topo data)
% % % so converting from NAVD88 to NED coordinate system gives this ~ 0.6 meter difference for a domain of ~ 4x4 kilometers
% % [LON, LAT] = meshgrid(lon,lat);
% % 
% % % define a reference datum, the center of domain seems a reasonable choice
% % % although, the z0 elevation may change with sea-level, so perhaps
% % % it is possible to use ROMS output to set z0?
% % ilat0       = floor( size(LAT,1)/2 );
% % llon0       = floor( size(LON,2)/2 );
% % lat0        = LAT(ilat0,llon0);
% % lon0        = LON(ilat0,llon0);
% % 
% % % also need a reference spheroid
% % spheroid    = referenceSphere('earth');
% % 
% % % convert topo coordinates to NED system
% % [xNorth, yEast, zDown] = geodetic2ned(LAT,LON,z,lat0,lon0,OPTIONS.z0,spheroid); % (this undoes the meshgridding)
% % % [xNorth, yEast, zDown] = geodetic2ned(LAT,LON,z_mod,lat0,lon0,z0,spheroid); % (this undoes the meshgridding)
% % zDown = -1*zDown; % prefer this convention better
% % 
% % % convert the new coastline to NED system
% % [Coast.xNorth, Coast.yEast, Coast.zDown] = geodetic2ned(Coast.y,Coast.x,Coast.z,lat0,lon0,OPTIONS.z0,spheroid);
% % Coast.zDown = -1*Coast.zDown; % prefer this convention better
% % 
% % % %% plot it all up in the NED system
% % % OPTIONS = plot_NED(yEast, xNorth, zDown, Coast, OPTIONS);

%% deal with all the NAN stuff
% Matlab can handle the NaNs, but starccm does not like them, so try to
% remove them
% x-y-z will all have NAN at the same places, interpolate them
% coastfile.lon = inpaint_nans(coastfile.lon,4);

topo_x = inpaint_nans(Topo.yEast,4);
topo_y = inpaint_nans(Topo.xNorth,4);
topo_z = inpaint_nans(Topo.zDown,4);

%% if all looks good, save a STL file of the topography file
% save as an STL file for creating CAD geometry
% stlWrite([OPTIONS.outname '.stl'], yEast, xNorth, zDown, 'TRIANGULATION', 'x')
% stlWrite([OPTIONS.dir_case filesep 'seabed.stl'], Topo.yEast, Topo.xNorth, Topo.zDown, 'TRIANGULATION', 'x');
stlWrite([OPTIONS.dir_case filesep 'seabed.stl'], topo_x, topo_y, topo_z, 'TRIANGULATION', 'x');


%% Lets try OpenSCAD which can read DXF files
%  see here to get started: http://edutechwiki.unige.ch/en/OpenScad_beginners_tutorial 
% file_dxf = [OPTIONS.dir_case filesep 'coastline_DXF'];
file_dxf = [pwd filesep OPTIONS.dir_case filesep 'coastline_DXF'];

% add square corners to the coastline, making "a square with coastline (water part) subtracted"
% can add a buffer length around the coastline part, this coastline part is
% Boolean subtracted from the seabed STL file, so to be safe make coastline part larger
% to decide which direction to apply the offset, determine if the coastline
% intersect the North East South and/or West boundaries.
%
stl_coast_x = [Topo.Coast.yEast ; Topo.Coast.yEast(end) ;  Topo.Coast.yEast(1)];
stl_coast_y = [Topo.Coast.xNorth; Topo.Coast.xNorth(1);  Topo.Coast.xNorth(1)];
% stl_coast_y = [Topo.Coast.xNorth; Topo.Coast.xNorth(end);  Topo.Coast.xNorth(1)];
% figure; 
% plot(stl_coast_x, stl_coast_y, 'o-k')

% NOTE: writedxf and dxf_open did not write compatible files with latest
% OpenSCAD, but writedxfline works
% writedxf(file_dxf, stl_coast_x, stl_coast_y, OPTIONS.z0.*ones(size(stl_coast_x))) 

% FID = dxf_open([file_dxf '.dxf']);
% dxf_polyline(FID, stl_coast_x, stl_coast_y, OPTIONS.z0.*ones(size(stl_coast_x)))
% dxf_close(FID)

writedxfline(file_dxf, stl_coast_x, stl_coast_y, OPTIONS.z0.*ones(size(stl_coast_x))) 

% heightSTL   = max(Topo.zDown(:))  - min(Topo.zDown(:));
% dx2         = max(Topo.yEast(:))  - min(Topo.yEast(:));
% dy2         = max(Topo.xNorth(:)) - min(Topo.xNorth(:));
heightSTL   = max(topo_z(:)) - min(topo_z(:));
dx2         = max(topo_x(:)) - min(topo_x(:));
dy2         = max(topo_y(:)) - min(topo_y(:));
dz2         = 4*heightSTL;                      % make it bigger to ease the boolean ops
buf_top     = 1.5;                              % make it bigger than seabed width, it is only used to boolean subtract at seabed level

filescad_coast = fopen([OPTIONS.dir_case filesep 'coastline.scad'],'w');
% filescad_coast = fopen(['../../utilities/_topo-Cascadia' filesep 'coastline.scad'],'w');
% fprintf(filescad_coast,['dxf_linear_extrude(file="' file_dxf '.dxf", height=' num2str(heightSTL) ', center=true); \n']);
fprintf(filescad_coast,['dxf_linear_extrude(file="' file_dxf '.dxf", height=' num2str(dz2) ', center=true); \n']);
fclose(filescad_coast);


filescad_surface = fopen([OPTIONS.dir_case filesep 'seasurface.scad'],'w');
fprintf(filescad_surface,['translate(' ['[' num2str(-1*buf_top*dx2/2) ', ' num2str(-1*buf_top*dy2/2) ', ' num2str(0) ']'] ') \n']);
fprintf(filescad_surface,['cube(' ['[' num2str(buf_top*dx2) ', ' num2str(buf_top*dy2) ', ' num2str(dz2) '], center=false'] ');']);
fclose(filescad_surface);


% change dir before running OpenSCAD
cdir = pwd;
cd(OPTIONS.dir_case);   
system('openscad -o coastline.stl coastline.scad');
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

% %% now use the point & click interface to add turbine locations
% % [OPTIONS, TURBS] = placeTurbines(xNorth, yEast, zDown, Coast, OPTIONS);
% OPTIONS = placeTurbines(xNorth, yEast, zDown, Coast, OPTIONS);
% 
% 
% %% Collect OUTPUT
% OPTIONS = make_STARCCM_mesh(OPTIONS)

end

