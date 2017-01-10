function [OPTIONS, ROMS] = convert_LatLon_ROMS(OPTIONS,ROMS,Topo)

global nctbx_options
% nctbx_options.theAutoNaN=0;
% nctbx_options.theAutoscale=0;
nctbx_options.theAutoNaN=1;
nctbx_options.theAutoscale=1;

%%
% detect and overwrite outliers
% deal with the "fill values" of NetCDf
% overwrite the outliers, on the landmask ROMS will report "fill values" of like 1e38 ... makes no sense
% outlier_thold = 1e6;
% outlier_value = nan;    % convenient to replace with NAN in Matlab, but STAR-CCM+ has troubles with NAN values

%% extract variables from the ROMS file, get entire domain
tindex = 1;

nc = netcdf(OPTIONS.fileTopo_ROMS);

% Rutgers version
h       = nc{'h'}(:);
zeta    = squeeze(nc{'zeta'}(tindex,:,:));
theta_s = nc{'theta_s'}(:);
theta_b = nc{'theta_b'}(:);
Tcline  = nc{'Tcline'}(:);
hc      = min(min(h(:)), Tcline);

% u = nc{'u'}(tindex,:,:,:);
% v = nc{'v'}(tindex,:,:,:);
% w = nc{'w'}(tindex,:,:,:);

close(nc)

% %% mesh grid information
% 
% % uses Pandora toolbox to read (could also use snc_roms_get_grid to get
% % similar information, but would need to now change variable names)
% 
% % fields are packed as (t,k,j,i) with k increasing upwards
% %   G has horizontal grid info including bathymetry
% %   S has vertical S-coordinate information
% %   T has time information
% [ROMS.G, ROMS.S, ROMS.T] = Z_get_basic_info(OPTIONS.fileTopo_ROMS);

%% RHO points

% compute the depth of rho or w points for ROMS
% get the depth at each lat lon index
z_rho = squeeze(zlevs(h,zeta,theta_s,theta_b,hc,ROMS.S.N,'r',ROMS.S.Vtransform));
z_w   = squeeze(zlevs(h,zeta,theta_s,theta_b,hc,ROMS.S.N,'w',ROMS.S.Vtransform));

% u_rho = zeros(size(z_rho));
% v_rho = zeros(size(z_rho));
% w_rho = zeros(size(z_rho));
% for n = 1:size(z_rho,1);
%     u_rho(n,:,:) = u2rho_2d( squeeze( u(n,:,:) ));
%     v_rho(n,:,:) = v2rho_2d( squeeze( v(n,:,:) ));
%     % the rho points of the w grid can be found by midpoints of the w points
%     w_rho(n,:,:) = (w(n,:,:) + w(n+1,:,:)) ./ 2;
% end
% spd_rho = sqrt(u_rho.^2 + u_rho.^2 + w_rho.^2);

% define a reference datum, the center of domain seems a reasonable choice
% although, the z0 elevation may change with sea-level, so perhaps
% it is possible to use ROMS output to set z0?
% ilat0       = floor( size(LAT,1)/2 );
% llon0       = floor( size(LON,2)/2 );
% lat0        = LAT(ilat0,llon0);
% lon0        = LON(ilat0,llon0);

%% now convert the ROMS into NED coordinates
% define a reference datum, the center of domain seems a reasonable choice
% although, the z0 elevation may change with sea-level, so perhaps
% it is possible to use ROMS output to set z0

% also need a reference spheroid
spheroid    = referenceSphere('earth');

% over the entire ROMS domain
% the reference point is center of the ROMS domain
ilat0       = floor( size(ROMS.G.lat_rho,1)/2 );
ilon0       = floor( size(ROMS.G.lon_rho,2)/2 );
lat0        = ROMS.G.lat_rho(ilat0,ilon0);
lon0        = ROMS.G.lon_rho(ilat0,ilon0);
xNorth = zeros(ROMS.S.N, ROMS.G.M, ROMS.G.L);
yEast  = zeros(ROMS.S.N, ROMS.G.M, ROMS.G.L);
zDown  = zeros(ROMS.S.N, ROMS.G.M, ROMS.G.L);
for n = 1:ROMS.S.N;
    % note: this undoes the meshgridding
    [xNorth(n,:,:), yEast(n,:,:), zDown(n,:,:)] = geodetic2ned(ROMS.G.lat_rho, ...
                                                               ROMS.G.lon_rho, ...
                                                               squeeze( z_w(n,:,:) ), ...
                                                           	   lat0, ...
                                                          	   lon0, ...
                                                               OPTIONS.z0, ...
                                                           	   spheroid);
%     [xNorth(n,:,:), yEast(n,:,:), zDown(n,:,:)] = geodetic2ned(ROMS.G.lat_rho, ...
%                                                                ROMS.G.lon_rho, ...
%                                                                squeeze( z_rho(n,:,:) ), ...
%                                                            	   lat0, ...
%                                                           	   lon0, ...
%                                                                OPTIONS.z0, ...
%                                                            	   spheroid);
end
% zDown = -1*zDown; % prefer this convention better

% overwrite any outliers (DONT NEED TO DO THIS IF MEXCDF options are set to ignore the fill values)
% xNorth(abs(xNorth) > outlier_thold) = outlier_value;
% yEast(abs(yEast)   > outlier_thold) = outlier_value;
% zDown(abs(zDown)   > outlier_thold) = outlier_value;
% 
% u_rho(abs(u_rho)   > outlier_thold) = outlier_value;
% v_rho(abs(v_rho)   > outlier_thold) = outlier_value;
% w_rho(abs(w_rho)   > outlier_thold) = outlier_value;
% spd_rho(abs(spd_rho) > outlier_thold) = outlier_value;



% THIS PART MAY HAVE BUG ... THE AREA INTEREST SEEMS TOO SMALL AND WRONG ASPECT RATIO
% lon_a      = find(ROMS.G.lon_rho(1,:) >= OPTIONS.aa(1),1,'first');
% lon_b      = find(ROMS.G.lon_rho(1,:) >= OPTIONS.aa(2),1,'first');    
% lat_a      = find(ROMS.G.lat_rho(:,1) >= OPTIONS.aa(3),1,'first');
% lat_b      = find(ROMS.G.lat_rho(:,1) >= OPTIONS.aa(4),1,'first');
% try this:
% remember OPTIONS.aa is the user selected box, and not guaranteed to align with topo/ROMS mesh
nn_lat    = interp1(ROMS.G.lat_rho(:,1),ROMS.G.lat_rho(:,1),OPTIONS.aa(3:4),'nearest','extrap');
nn_lon    = interp1(ROMS.G.lon_rho(1,:),ROMS.G.lon_rho(1,:),OPTIONS.aa(1:2),'nearest','extrap');
lon_a      = find(ROMS.G.lon_rho(1,:) >= nn_lon(1),1,'first');
lon_b      = find(ROMS.G.lon_rho(1,:) >= nn_lon(2),1,'first');    
lat_a      = find(ROMS.G.lat_rho(:,1) >= nn_lat(1),1,'first');
lat_b      = find(ROMS.G.lat_rho(:,1) >= nn_lat(2),1,'first');

% u_rho_aa   = u_rho(:, lat_a:lat_b, lon_a:lon_b);
% v_rho_aa   = v_rho(:, lat_a:lat_b, lon_a:lon_b);
% w_rho_aa   = w_rho(:, lat_a:lat_b, lon_a:lon_b);
% spd_rho_aa = spd_rho(:, lat_a:lat_b, lon_a:lon_b);

lon_aa   = ROMS.G.lon_rho(lat_a:lat_b, lon_a:lon_b);
lat_aa   = ROMS.G.lat_rho(lat_a:lat_b, lon_a:lon_b);
ilat0_aa = floor( size(lat_aa,1)/2 );
ilon0_aa = floor( size(lon_aa,2)/2 );
lat0_aa  = lat_aa(ilat0_aa, ilon0_aa);
lon0_aa  = lon_aa(ilat0_aa, ilon0_aa);
h_aa     =    h(lat_a:lat_b, lon_a:lon_b);
zeta_aa  = zeta(lat_a:lat_b, lon_a:lon_b);
z_rho_aa = squeeze(zlevs(h_aa,zeta_aa,theta_s,theta_b,hc,ROMS.S.N,'r',ROMS.S.Vtransform));
z_w_aa   = squeeze(zlevs(h_aa,zeta_aa,theta_s,theta_b,hc,ROMS.S.N,'w',ROMS.S.Vtransform));

% dx_aa = ROMS.G.DX(lat_a:lat_b, lon_a:lon_b);
% dy_aa = ROMS.G.DY(lat_a:lat_b, lon_a:lon_b);

xNorth_aa = zeros(ROMS.S.N, size(lon_aa,1), size(lat_aa,2));
yEast_aa  = zeros(ROMS.S.N, size(lon_aa,1), size(lat_aa,2));
zDown_aa  = zeros(ROMS.S.N, size(lon_aa,1), size(lat_aa,2));
for n = 1:ROMS.S.N;
    % note: this undoes the meshgridding
    [xNorth_aa(n,:,:), yEast_aa(n,:,:), zDown_aa(n,:,:)] = geodetic2ned(lat_aa, ...
                                                                        lon_aa, ...
                                                                        squeeze( z_w_aa(n,:,:) ), ...
                                                                        lat0_aa, ...
                                                                        lon0_aa, ...
                                                                        OPTIONS.z0, ...
                                                                        spheroid);
%     [xNorth_aa(n,:,:), yEast_aa(n,:,:), zDown_aa(n,:,:)] = geodetic2ned(lat_aa, ...
%                                                                         lon_aa, ...
%                                                                         squeeze( z_rho_aa(n,:,:) ), ...
%                                                                         lat0_aa, ...
%                                                                         lon0_aa, ...
%                                                                         OPTIONS.z0, ...
%                                                                         spheroid);
end
zDown_aa = -1*zDown_aa; % prefer this convention better





%% Collect the output
ROMS.yEast   = yEast;
ROMS.xNorth  = xNorth;
ROMS.zDown   = zDown;

ROMS.yEast_aa   = yEast_aa;
ROMS.xNorth_aa  = xNorth_aa;
ROMS.zDown_aa   = zDown_aa;

% if ~isempty(OPTIONS.fileCoast)
%     % convert the new coastline to NED system
%     [coast_xNorth, coast_yEast, coast_zDown] = geodetic2ned(Topo.Coast.y,Topo.Coast.x,Topo.Coast.z,lat0,lon0,OPTIONS.z0,spheroid);
%     coast_zDown = -1*coast_zDown; % prefer this convention better
%     
%     ROMS.Coast.yEast  = coast_yEast;
%     ROMS.Coast.xNorth = coast_xNorth;
%     ROMS.Coast.zDown  = coast_zDown;
% else
%     ROMS.Coast = [];
% end

% % OLD below from topo conversion 
% % 
% % %% convert to North-East-Down (NED) Cartesian coordinate system (note: this undoes the meshgrid)
% % % maybe also look into converting NAVD88 to ECEF to NED: http://www.mathworks.com/help/aeroblks/directioncosinematrixeceftoned.html
% % % NOTE: it looks like the using the reference z0 is important to keep as 0,
% % % gravity-based geodetic datum is NAVD88 originally (for the topo data)
% % % so converting from NAVD88 to NED coordinate system gives this ~ 0.6 meter difference for a domain of ~ 4x4 kilometers
% % [LON, LAT] = meshgrid(Topo.lon, Topo.lat);
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
% % [xNorth, yEast, zDown] = geodetic2ned(LAT,LON,Topo.z,lat0,lon0,OPTIONS.z0,spheroid); % (this undoes the meshgridding)
% % % [xNorth, yEast, zDown] = geodetic2ned(LAT,LON,z_mod,lat0,lon0,z0,spheroid); % (this undoes the meshgridding)
% % zDown = -1*zDown; % prefer this convention better
% % 
% % 
% % 
% % %% plot it all up in the NED system
% % % OPTIONS = plot_NED(yEast, xNorth, zDown, Coast, OPTIONS);
% % 
% % 
% % 
% % %% Collect the output
% % NED.Topo.yEast   = yEast;
% % NED.Topo.xNorth  = xNorth;
% % NED.Topo.zDown   = zDown;
% % 
% % if ~isempty(OPTIONS.fileCoast)
% %     % convert the new coastline to NED system
% %     [coast_xNorth, coast_yEast, coast_zDown] = geodetic2ned(Coast.y,Coast.x,Coast.z,lat0,lon0,OPTIONS.z0,spheroid);
% %     coast_zDown = -1*coast_zDown; % prefer this convention better
% %     
% %     NED.Coast.yEast  = coast_yEast;
% %     NED.Coast.xNorth = coast_xNorth;
% %     NED.Coast.zDown  = coast_zDown;
% % else
% %     NED.Coast = [];
% % end




end