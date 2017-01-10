% function [OPTIONS, Coast] = add_Coastline(OPTIONS)
function [OPTIONS, Topo] = add_Coastline(OPTIONS,Topo)
% function [OPTIONS, Coast] = add_Coastline(OPTIONS,lon,lat,zz)
% NOTE: this requires a coastline file, but it could be modified to work
% without a coastline file

% ALL THIS SHOULD BE MOVED INTO SELECT_AREA_INTEREST, and add Coast to Topo.Coast

[LON, LAT] = meshgrid(Topo.lon, Topo.lat);

%% extract the variables from the NetCDF file within the specified lat/lon refinement

% lon1        = nc_varget(OPTIONS.fileTopo,'lon');
% lat1        = nc_varget(OPTIONS.fileTopo,'lat');
% % lon1        = lon;
% % lat1        = lat;
% % lonmask     = lon1>=OPTIONS.aa(1) & lon1<=OPTIONS.aa(2);
% % latmask     = lat1>=OPTIONS.aa(3) & lat1<=OPTIONS.aa(4);
% % lon2         = lon1(lonmask);
% % lat2         = lat1(latmask);
% % lon_nstart  = find(lon1 == lon2(1));
% % lat_nstart  = find(lat1 == lat2(1));
% % z           = nc_varget(OPTIONS.fileTopo,'elev',[lat_nstart-1 lon_nstart-1],[sum(latmask) sum(lonmask)]);
% z           = zz;
% should also get the variables: velocity u,v,w (mex_cdf cannot read for some reason)
% u           = nc_varget(OPTIONS.fileTopo_ROMS,'u',Inf);
% v           = nc_varget(OPTIONS.fileTopo_ROMS,'v',[lat_nstart-1 lon_nstart-1],[sum(latmask) sum(lonmask)]);
% w           = nc_varget(OPTIONS.fileTopo_ROMS,'w',[lat_nstart-1 lon_nstart-1],[sum(latmask) sum(lonmask)]);
% maybe nc_varget only works on the topography files, but the ROMS version
% of NetCDF is different?

% nc_dump(OPTIONS.fileTopo)

% save(OPTIONS.outname,'z','lon','lat');
% save([OPTIONS.dir_case filesep 'extracted_ROMS'],'z','lon','lat');


%% load the coastline file, and mask it
coastfile = load(['inputs' filesep 'bathymetry' filesep 'coast' filesep OPTIONS.dirCoast filesep OPTIONS.fileCoast]);

% this works fine to remove all NaNs (I think, but also causes some
% problems with plotting sometimes?)
coastfile.lon = inpaint_nans(coastfile.lon,4);
coastfile.lat = inpaint_nans(coastfile.lat,4);

% use a buffer around the domain, to ensure that the new coastlines fall entirely within the refinement box
dbuf = km2deg(OPTIONS.mbuf / 1000, 'earth');

coast_xy   = [coastfile.lon, coastfile.lat];
coast_mask = coast_xy(:,1) >= OPTIONS.aa(1)-dbuf & coast_xy(:,1) <= OPTIONS.aa(2)+dbuf & ...
             coast_xy(:,2) >= OPTIONS.aa(3)-dbuf & coast_xy(:,2) <= OPTIONS.aa(4)+dbuf;
x_coast    = coast_xy(coast_mask,1);
y_coast    = coast_xy(coast_mask,2);


Coast = coastline_resampled(LAT,LON,Topo.z,x_coast,y_coast,OPTIONS);


%% convert the coastline to NED coordinates

% also need a reference spheroid
spheroid    = referenceSphere('earth');

% define a reference datum, the center of domain seems a reasonable choice
% although, the z0 elevation may change with sea-level, so perhaps
% it is possible to use ROMS output to set z0?
ilat0       = floor( size(LON,1)/2 );
ilon0       = floor( size(LAT,2)/2 );
lat0        = LAT(ilat0,ilon0);
lon0        = LON(ilat0,ilon0);

% convert topo coordinates to NED system
% [xNorth, yEast, zDown] = geodetic2ned(LAT,LON,z,lat0,lon0,OPTIONS.z0,spheroid); % (this undoes the meshgridding)
% [xNorth, yEast, zDown] = geodetic2ned(LAT,LON,z_mod,lat0,lon0,z0,spheroid); % (this undoes the meshgridding)
% zDown = -1*zDown; % prefer this convention better

% convert the new coastline to NED system
[coast_xNorth, coast_yEast, coast_zDown] = geodetic2ned(Coast.lat,Coast.lon,Coast.z,lat0,lon0,OPTIONS.z0,spheroid);
coast_zDown = -1*coast_zDown; % prefer this convention better

Topo.Coast.xNorth = coast_xNorth;
Topo.Coast.yEast  = coast_yEast;
Topo.Coast.zDown  = coast_zDown;

Topo.Coast.lon_aa = Coast.lon;
Topo.Coast.lat_aa = Coast.lat;

% 
% %% create a new coastline suitable for the CFD meshing
% % cut-off the coastline at a specified distance (requires a coastline file)
% % NOTE: coastline files do not change in time, meaning that a
% % drying/wetting model is not active.  Therefore, maybe you should read
% % the tidal elevation directly from the ROMS netcdf output (this could provide
% % an inconvencience if somebody wants to mesh independent of the ocean model, so in 
% % this case should provide user option to use ROMS code or just elevation data, the zero datum)
% Coast = plot_coastline_resampled(lat, lon, z, x_coast, y_coast, OPTIONS);
% 
% 
% 
% % convert to North-East-Down (NED) Cartesian coordinate system (note: this undoes the meshgrid)
% % maybe also look into converting NAVD88 to ECEF to NED: http://www.mathworks.com/help/aeroblks/directioncosinematrixeceftoned.html
% % NOTE: it looks like the using the reference z0 is important to keep as 0,
% % gravity-based geodetic datum is NAVD88 originally (for the topo data)
% % so converting from NAVD88 to NED coordinate system gives this ~ 0.6 meter difference for a domain of ~ 4x4 kilometers
% [LON, LAT] = meshgrid(lon,lat);
% 
% % define a reference datum, the center of domain seems a reasonable choice
% % although, the z0 elevation may change with sea-level, so perhaps
% % it is possible to use ROMS output to set z0?
% ilat0       = floor( size(LAT,1)/2 );
% llon0       = floor( size(LON,2)/2 );
% lat0        = LAT(ilat0,llon0);
% lon0        = LON(ilat0,llon0);
% 
% % also need a reference spheroid
% spheroid    = referenceSphere('earth');
% 
% % convert topo coordinates to NED system
% % [xNorth, yEast, zDown] = geodetic2ned(LAT,LON,z,lat0,lon0,OPTIONS.z0,spheroid); % (this undoes the meshgridding)
% % [xNorth, yEast, zDown] = geodetic2ned(LAT,LON,z_mod,lat0,lon0,z0,spheroid); % (this undoes the meshgridding)
% zDown = -1*zDown; % prefer this convention better
% 
% % convert the new coastline to NED system
% [coast_xNorth, coast_yEast, coast_zDown] = geodetic2ned(y_coast,x_coast,Coast.z,lat0,lon0,OPTIONS.z0,spheroid);
% coast_zDown = -1*coast_zDown; % prefer this convention better
% % % 
% % % %% plot it all up in the NED system
% % % % OPTIONS = plot_NED(yEast, xNorth, zDown, Coast, OPTIONS);
% % % 
% % % NED.Topo.yEast        = yEast;
% % % NED.Topo.xNorth       = xNorth;
% % % NED.Topo.zDown        = zDown;
% % % NED.Coast.yEast  = coast_yEast;
% % % NED.Coast.xNorth = coast_xNorth;
% % % NED.Coast.zDown  = coast_zDown;

end
