function [OPTIONS, Topo] = convert_LatLon_Topo(OPTIONS, Topo)



%% convert to North-East-Down (NED) Cartesian coordinate system (note: this undoes the meshgrid)
% maybe also look into converting NAVD88 to ECEF to NED: http://www.mathworks.com/help/aeroblks/directioncosinematrixeceftoned.html
% NOTE: it looks like the using the reference z0 is important to keep as 0,
% gravity-based geodetic datum is NAVD88 originally (for the topo data)
% so converting from NAVD88 to NED coordinate system gives this ~ 0.6 meter difference for a domain of ~ 4x4 kilometers
[LON, LAT] = meshgrid(Topo.lon, Topo.lat);

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
[xNorth, yEast, zDown] = geodetic2ned(LAT,LON,Topo.z,lat0,lon0,OPTIONS.z0,spheroid); % (this undoes the meshgridding)
% [xNorth, yEast, zDown] = geodetic2ned(LAT,LON,z_mod,lat0,lon0,z0,spheroid); % (this undoes the meshgridding)
zDown = -1*zDown; % prefer this convention better



% %% plot it all up in the NED system
% % OPTIONS = plot_NED(yEast, xNorth, zDown, Coast, OPTIONS);
% 
% 
% if ~isempty(OPTIONS.fileCoast)
%     % convert the new coastline to NED system
%     [coast_xNorth, coast_yEast, coast_zDown] = geodetic2ned(Topo.Coast.y_resample,Topo.Coast.x_resample,Topo.Coast.z_resample,lat0,lon0,OPTIONS.z0,spheroid);
%     coast_zDown = -1*coast_zDown; % prefer this convention better
%     
%     Topo.Coast.yEast  = coast_yEast;
%     Topo.Coast.xNorth = coast_xNorth;
%     Topo.Coast.zDown  = coast_zDown;
% else
%     % attempt to make the coastline without a coastline file
%     % possiblt to just the same offset interpolation from the
%     % z=0 elevation ... although using a coastline file
%     % is probably better comparision to other ocean modeling codes
%     
% end

%% Collect the output
Topo.yEast   = yEast;
Topo.xNorth  = xNorth;
Topo.zDown   = zDown;

% if ~isempty(OPTIONS.fileCoast)
%     % convert the new coastline to NED system
%     [coast_xNorth, coast_yEast, coast_zDown] = geodetic2ned(Coast.y,Coast.x,Coast.z,lat0,lon0,OPTIONS.z0,spheroid);
%     coast_zDown = -1*coast_zDown; % prefer this convention better
%     
%     Topo.Coast.yEast  = coast_yEast;
%     Topo.Coast.xNorth = coast_xNorth;
%     Topo.Coast.zDown  = coast_zDown;
% else
%     Topo.Coast = [];
% end


%% plot the coastline

if ~OPTIONS.runHeadless
    % overlay the coastline
    hold on
    plot(Topo.Coast.lon_aa,Topo.Coast.lat_aa,'-y','LineWidth',2)
    % plot_coastline_resampled(lat,lon,z,x_coast, y_coast, OPTIONS)
end

end