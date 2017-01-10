function [OPTIONS, ROMS] = get_ROMS_fields(OPTIONS)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

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

u = nc{'u'}(tindex,:,:,:);
v = nc{'v'}(tindex,:,:,:);
w = nc{'w'}(tindex,:,:,:);

close(nc)

%% mesh grid information

% uses Pandora toolbox to read (could also use snc_roms_get_grid to get
% similar information, but would need to now change variable names)

% fields are packed as (t,k,j,i) with k increasing upwards
%   G has horizontal grid info including bathymetry
%   S has vertical S-coordinate information
%   T has time information
[ROMS.G, ROMS.S, ROMS.T] = Z_get_basic_info(OPTIONS.fileTopo_ROMS);

%% RHO points

% compute the depth of rho or w points for ROMS
% get the depth at each lat lon index
z_rho = squeeze(zlevs(h,zeta,theta_s,theta_b,hc,ROMS.S.N,'r',ROMS.S.Vtransform));

u_rho = zeros(size(z_rho));
v_rho = zeros(size(z_rho));
w_rho = zeros(size(z_rho));
for n = 1:size(z_rho,1);
    u_rho(n,:,:) = u2rho_2d( squeeze( u(n,:,:) ));
    v_rho(n,:,:) = v2rho_2d( squeeze( v(n,:,:) ));
    % the rho points of the w grid can be found by midpoints of the w points
    w_rho(n,:,:) = (w(n,:,:) + w(n+1,:,:)) ./ 2;
end
spd_rho = sqrt(u_rho.^2 + u_rho.^2 + w_rho.^2);

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
% xNorth = zeros(ROMS.S.N, ROMS.G.M, ROMS.G.L);
% yEast  = zeros(ROMS.S.N, ROMS.G.M, ROMS.G.L);
% zDown  = zeros(ROMS.S.N, ROMS.G.M, ROMS.G.L);
xNorth = nan(ROMS.S.N, ROMS.G.M, ROMS.G.L);
yEast  = nan(ROMS.S.N, ROMS.G.M, ROMS.G.L);
zDown  = nan(ROMS.S.N, ROMS.G.M, ROMS.G.L);
for n = 1:ROMS.S.N;
    % note: this undoes the meshgridding
    [xNorth(n,:,:), yEast(n,:,:), zDown(n,:,:)] = geodetic2ned(ROMS.G.lat_rho, ...
                                                               ROMS.G.lon_rho, ...
                                                               squeeze( z_rho(n,:,:) ), ...
                                                           	   lat0, ...
                                                          	   lon0, ...
                                                               OPTIONS.z0, ...
                                                           	   spheroid);
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

%% DEBUG figure
% figure; hist(xNorth(:), 100);
% figure; hist(yEast(:), 100);
% figure; hist(zDown(:), 100);
% 
% figure; hist(u_rho(:), 100);
% figure; hist(v_rho(:), 100);
% figure; hist(w_rho(:), 100);
% figure; hist(spd_rho(:), 100);
% 
% [max(xNorth(:)) min(xNorth(:))]
% [max(yEast(:))  min(yEast(:))]
% [max(zDown(:))  min(zDown(:))]
% [max(spd_rho(:))  min(spd_rho(:))]
% 
% % plot as a point cloud
% hfig_debug = figure;
% for n = 1
% % for n = 1:20
%     xxx = squeeze( xNorth(n,:,: ));
%     yyy = squeeze( yEast(n,:,: ));
%     zzz = squeeze( zDown(n,:,: ));
%     fff = squeeze( spd_rho(n,:,: ));
%     scatter3(xxx(:), yyy(:), zzz(:), fff(:), 'CData', fff(:))  
% end
% colorbar
% axis equal
% % load the STL file to add to plot
% [vertices, faces, normals, name] = stlReadBinary([OPTIONS.dir_case filesep 'seabed.stl']);
% figure(hfig_debug)
% hold on
% stlPlot(vertices,faces,name);

%%
% over only the area of interest
% the reference point is center of the ROMS area of interest domain
% start/stop index of the area of interest


%
% extract the refinement zone
% round to the nearest neighbor in the topo resolution
% nn_lat    = interp1(lat,lat,y,'nearest','extrap');
% nn_lon    = interp1(lon,lon,x,'nearest','extrap');
% idx_lat_1 = find(lat==nn_lat(1),1);
% idx_lat_2 = find(lat==nn_lat(2),1);
% idx_lon_1 = find(lon==nn_lon(1),1);
% idx_lon_2 = find(lon==nn_lon(2),1);
% 
% a_lat = min(idx_lat_1,idx_lat_2);
% b_lat = max(idx_lat_1,idx_lat_2);
% a_lon = min(idx_lon_1,idx_lon_2);
% b_lon = max(idx_lon_1,idx_lon_2);
% new_lat = lat(a_lat:b_lat);
% new_lon = lon(a_lon:b_lon);
% new_zz  = zz(a_lat:b_lat, a_lon:b_lon);

% THIS PART MAY HAVE BUG ... THE AREA INTEREST SEEMS TOO SMALL AND WRONG ASPECT RATIO
% lon_a      = find(ROMS.G.lon_rho(1,:) >= OPTIONS.aa(1),1,'first');
% lon_b      = find(ROMS.G.lon_rho(1,:) >= OPTIONS.aa(2),1,'first');    
% lat_a      = find(ROMS.G.lat_rho(:,1) >= OPTIONS.aa(3),1,'first');
% lat_b      = find(ROMS.G.lat_rho(:,1) >= OPTIONS.aa(4),1,'first');
% try this
nn_lat    = interp1(ROMS.G.lat_rho(:,1),ROMS.G.lat_rho(:,1),OPTIONS.aa(3:4),'nearest','extrap');
nn_lon    = interp1(ROMS.G.lon_rho(1,:),ROMS.G.lon_rho(1,:),OPTIONS.aa(1:2),'nearest','extrap');
lon_a      = find(ROMS.G.lon_rho(1,:) >= nn_lon(1),1,'first');
lon_b      = find(ROMS.G.lon_rho(1,:) >= nn_lon(2),1,'first');    
lat_a      = find(ROMS.G.lat_rho(:,1) >= nn_lat(1),1,'first');
lat_b      = find(ROMS.G.lat_rho(:,1) >= nn_lat(2),1,'first');

% NOTE: u_rho and other comonents have NaN values, and not at same indexes,
% so search each component individually and fill-in
u_rho_aa   = u_rho(:, lat_a:lat_b, lon_a:lon_b);
v_rho_aa   = v_rho(:, lat_a:lat_b, lon_a:lon_b);
w_rho_aa   = w_rho(:, lat_a:lat_b, lon_a:lon_b);
spd_rho_aa = spd_rho(:, lat_a:lat_b, lon_a:lon_b);



% Some of these other variables also have NaN that should be dealt with
lon_aa   = ROMS.G.lon_rho(lat_a:lat_b, lon_a:lon_b);
lat_aa   = ROMS.G.lat_rho(lat_a:lat_b, lon_a:lon_b);
ilat0_aa = floor( size(lat_aa,1)/2 );
ilon0_aa = floor( size(lon_aa,2)/2 );
lat0_aa  = lat_aa(ilat0_aa, ilon0_aa);
lon0_aa  = lon_aa(ilat0_aa, ilon0_aa);
h_aa     =    h(lat_a:lat_b, lon_a:lon_b);
zeta_aa  = zeta(lat_a:lat_b, lon_a:lon_b); % has NaN values
    zeta_aa  = inpaint_nans(zeta_aa, 4);
    
z_rho_aa = squeeze(zlevs(h_aa,zeta_aa,theta_s,theta_b,hc,ROMS.S.N,'r',ROMS.S.Vtransform)); % this has NaN
for n = 1:size(z_rho_aa,1)
    % fix the NaN, interpolate horizontally
    z_rho_aa(n,:,:) = inpaint_nans(squeeze( z_rho_aa(n,:,:) ), 4);
    
    % the ROMS fields can have NaN present, so deal with them
    u_rho_aa(n,:,:)   = inpaint_nans(squeeze( u_rho_aa(n,:,:) ), 4);
    v_rho_aa(n,:,:)   = inpaint_nans(squeeze( v_rho_aa(n,:,:) ), 4);
    w_rho_aa(n,:,:)   = inpaint_nans(squeeze( w_rho_aa(n,:,:) ), 4);
    spd_rho_aa(n,:,:) = inpaint_nans(squeeze( spd_rho_aa(n,:,:) ), 4);
    % NOTE: inpaint_nans will extrapolate beyond the coastlines
    % but I think those values will be outside of the starccm
    % domain and will safely be ignored
end
    
    
dx_aa = ROMS.G.DX(lat_a:lat_b, lon_a:lon_b);
dy_aa = ROMS.G.DY(lat_a:lat_b, lon_a:lon_b);

% xNorth_aa = zeros(ROMS.S.N, size(lon_aa,1), size(lat_aa,2));
% yEast_aa  = zeros(ROMS.S.N, size(lon_aa,1), size(lat_aa,2));
% zDown_aa  = zeros(ROMS.S.N, size(lon_aa,1), size(lat_aa,2));
xNorth_aa = nan(ROMS.S.N, size(lon_aa,1), size(lat_aa,2));
yEast_aa  = nan(ROMS.S.N, size(lon_aa,1), size(lat_aa,2));
zDown_aa  = nan(ROMS.S.N, size(lon_aa,1), size(lat_aa,2));
for n = 1:ROMS.S.N;
    % note: this undoes the meshgridding
    [xNorth_aa(n,:,:), yEast_aa(n,:,:), zDown_aa(n,:,:)] = geodetic2ned(lat_aa, ...
                                                                        lon_aa, ...
                                                                        squeeze( z_rho_aa(n,:,:) ), ...
                                                                        lat0_aa, ...
                                                                        lon0_aa, ...
                                                                        OPTIONS.z0, ...
                                                                        spheroid);
end
zDown_aa = -1*zDown_aa; % prefer this convention better


%


% xNorth_aa(abs(xNorth_aa) > outlier_thold) = outlier_value;
% yEast_aa(abs(yEast_aa)   > outlier_thold) = outlier_value;
% zDown_aa(abs(zDown_aa)   > outlier_thold) = outlier_value;
% 
% u_rho_aa(abs(u_rho_aa) > outlier_thold) = outlier_value;
% v_rho_aa(abs(v_rho_aa) > outlier_thold) = outlier_value;
% w_rho_aa(abs(w_rho_aa) > outlier_thold) = outlier_value;

% test replacing the NaN with different value
% yEast_aa(isnan(yEast_aa)) = 666;
% xNorth_aa(isnan(xNorth_aa)) = 666;
% zDown_aa(isnan(zDown_aa)) = 666;
% spd_rho_aa(isnan(spd_rho_aa)) = -10;
% figure
% scatter3(xNorth_aa(:), yEast_aa(:), zDown_aa(:), spd_rho_aa(:), 'CData', spd_rho_aa(:)) 
% 
% % Y = INPAINTN(X) computes the missing data in the N-D array X
% any(isnan(yEast_aa(:)))
% 
% for n = 1:20
%     any( any(isnan(yEast_aa(n,:,:))) )
% end
% 
% for n = 1
%     figure
%     theNaNs = isnan(squeeze(spd_rho_aa(n,:,:)));
%     pcolor(squeeze(yEast_aa(n,:,:)), squeeze(xNorth_aa(n,:,:)), theNaNs)
% %     pcolor(squeeze(yEast_aa(n,:,:)), squeeze(xNorth_aa(n,:,:)), squeeze(spd_rho_aa(n,:,:)))
%     colorbar
% end


% find the NaN values and then interpolate (this distorts the lat/lon
% coordinates near the boundaries
% for n = 1:20
%     xNorth_aa(n,:,:) = inpaint_nans(squeeze(xNorth_aa(n,:,:)));
%     yEast_aa(n,:,:)  = inpaint_nans(squeeze( yEast_aa(n,:,:)));
%     zDown_aa(n,:,:)  = inpaint_nans(squeeze( zDown_aa(n,:,:)));
%     
%     u_rho_aa(n,:,:)   = inpaint_nans(squeeze(  u_rho_aa(n,:,:)));
%     v_rho_aa(n,:,:)   = inpaint_nans(squeeze(  v_rho_aa(n,:,:)));
%     w_rho_aa(n,:,:)   = inpaint_nans(squeeze(  w_rho_aa(n,:,:)));
%     spd_rho_aa(n,:,:) = inpaint_nans(squeeze(spd_rho_aa(n,:,:)));
% end

%% BUG HERE: why are the NaN only along the East boundary? they must be missing from the convertNED part?

% % find the NaN values and then interpolate (interpolate vertically)
% for m = 1:size(zDown_aa,2)
%     for n = 1:size(zDown_aa,3)
% % for n = 1:ROMS.G.L
% %     for m = 1:ROMS.G.M
%         xNorth_aa(:,m,n) = inpaint_nans(xNorth_aa(:,m,n));
%          yEast_aa(:,m,n) = inpaint_nans( yEast_aa(:,m,n));
%          zDown_aa(:,m,n) = inpaint_nans( zDown_aa(:,m,n));
% 
%           u_rho_aa(:,m,n) = inpaint_nans(  u_rho_aa(:,m,n));
%           v_rho_aa(:,m,n) = inpaint_nans(  v_rho_aa(:,m,n));
%           w_rho_aa(:,m,n) = inpaint_nans(  w_rho_aa(:,m,n));
%         spd_rho_aa(:,m,n) = inpaint_nans(spd_rho_aa(:,m,n));
%     end
% end


%% plot as a point cloud
hfig_debug = figure;
% for n = 1
for n = 1:size(zDown_aa,1)
    xxx = squeeze( yEast_aa(n,:,: ));
    yyy = squeeze( xNorth_aa(n,:,: ));
    zzz = squeeze( zDown_aa(n,:,: ));
%     xxx = lon_aa;
%     yyy = lat_aa;
%     zzz = squeeze( z_rho_aa(n,:,: ));
    fff = squeeze( spd_rho_aa(n,:,: ));
    
    
    % try to shift the domain
%     xxx = xxx - dx_aa;
%     yyy = yyy + dy_aa;
    
    hold on
    scatter3(xxx(:), yyy(:), zzz(:), fff(:), 'CData', fff(:))  
end
colorbar 
box on
axis equal
caxis([0.5 1.5]);

% load the STL file to add to plot
[vertices, faces, normals, name] = stlReadBinary([OPTIONS.dir_case filesep 'seabed.stl']);
stlPlot(vertices,faces,name,hfig_debug);
set(gca,'DataAspectRatio',[1 1 1/10]) % exaggerate the depth axis

% figure; hist(xNorth_aa(:), 100);
% figure; hist(yEast_aa(:), 100);
% figure; hist(zDown_aa(:), 100);
% 
% figure; hist(u_rho_aa(:), 100);
% figure; hist(v_rho_aa(:), 100);
% figure; hist(w_rho_aa(:), 100);
% figure; hist(spd_rho_aa(:), 100);
% 
% [max(xNorth_aa(:)) min(xNorth_aa(:))]
% [max(yEast_aa(:))  min(yEast_aa(:))]
% [max(zDown_aa(:))  min(zDown_aa(:))]
% [max(spd_rho_aa(:))  min(spd_rho_aa(:))]

view([0 90 0])
view([90 0 0])
view([0 0 90])


% This is where I realized that ROMS and the PSDEM2005 datasets have
% different resolutions on the lat/lon grids ... and it is possible that
% the OPTIONS area of interest does not perfectly align between the 
% topography and ROMS meshes.  Can then furthermore truncate the STAR-CCM+
% domain to the areas where lat/lon overlap (the union of the datasets).
% Or the ROMS area interest can be made slightly larger than the 
% Also, ROMS will have different resolution on the seabed, should compare the 
% difference between the PSDEM maps and the ROMS depth.
% z_r is the ROMS actual depths of variables at ρ-points, and it can be 
% computed by the zlevs.m function
%
% Sometime the ROMS depth is either below, or above, the PSDEM topography,
% and it could be possible to extrapolate/interpolate the ROMS domain
% to a higher resolution of the topography ... but the flow may not be
% physical ... it may be better to accept the lower resolution ROMS
% topograhpy.

% 
% 
% % BUG HERE: starccm cannot read the seabed_ROMS.stl for unknown reason
% % (prob because the z_rho field contains NAN)
% % make a STL file from the ROMS depths
% xx     = squeeze( yEast_aa(1,:,:) );
% yy     = squeeze( xNorth_aa(1,:,:) );
% z_roms = squeeze( z_rho_aa(1,:,:) );
% 
% % z_roms(isnan(z_roms)) = 0;
% % xx and yy have zero values at the NaNs ... but need to give the real NED coordinates
% % this sounds like a job for 3D interpolation where we expect NaNs to be on boundaries
% 
% stlWrite([OPTIONS.dir_case filesep 'seabed_ROMS.stl'], xx, yy, z_roms, 'TRIANGULATION', 'x');
% [vertices, faces, normals, name] = stlReadBinary([OPTIONS.dir_case filesep 'seabed_ROMS.stl']);
% stlPlot(vertices,faces,name,hfig_debug);
% set(gca,'DataAspectRatio',[1 1 1/10]) % exaggerate the depth axis

%% save data in CSV file format, for reading by STAR-CCM+

% over entire domain
csv_filename = [OPTIONS.dir_case filesep 'ROMS_xyzuvw.csv'];
xyzuvw       = [xNorth(:) yEast(:) zDown(:) u_rho(:) v_rho(:) w_rho(:)];

% if the file already exists, overwrite
if exist(csv_filename, 'file')==2
  delete(csv_filename);
end

% write the header and then append the data
fid = fopen(csv_filename, 'w');
fprintf(fid, 'X,Y,Z,u,v,w\n');
fclose(fid);
dlmwrite(csv_filename, xyzuvw, '-append', 'precision', '%.6f', 'delimiter', ',');

% over area of interest
csv_filename_aa = [OPTIONS.dir_case filesep 'ROMS_xyzuvw_area_interest.csv'];
xyzuvw_aa       = [xNorth_aa(:) yEast_aa(:) zDown_aa(:) u_rho_aa(:) v_rho_aa(:) w_rho_aa(:)];

% the NaNs do not cause any problems within Matlab for plotting
% but STAR-CCM+ cannot handle a NaN ... so decide how to remove NaNs
% % m = 1;
% % for n = 1:size(xyzuvw_aa,1)
% %     % if any variable contains a NaN, remove it
% %     numNaNs = sum( isnan(xyzuvw_aa(n,:)) );
% %     
% %     if numNaNs > 0
% %         indNaNs(m) = n;
% %         m = m+1;
% % %         xyzuvw_aa(n,:) = [];
% %     end
% % %     
% % %     a = sum( isnan( xyzuvw_aa(n,1) ) );
% % %     b = sum( isnan( xyzuvw_aa(n,2) ) );
% % %     c = sum( isnan( xyzuvw_aa(n,3) ) );
% % %     d = sum( isnan( xyzuvw_aa(n,4) ) );
% % %     e = sum( isnan( xyzuvw_aa(n,5) ) );
% % %     f = sum( isnan( xyzuvw_aa(n,6) ) );
% % 
% % end
% % xyzuvw_aa(indNaNs,:) = [];

% if the file already exists, overwrite
if exist(csv_filename_aa, 'file')==2
  delete(csv_filename_aa);
end

% write the header and then append the data
fid = fopen(csv_filename_aa, 'w');
fprintf(fid, 'X,Y,Z,u,v,w\n');
fclose(fid);
dlmwrite(csv_filename_aa, xyzuvw_aa, '-append', 'precision', '%.6f', 'delimiter', ',');

% figure
% scatter3(xyzuvw_aa(:,1), xyzuvw_aa(:,2), xyzuvw_aa(:,3), xyzuvw_aa(:,4), 'CData', xyzuvw_aa(:,4))

%%
% debug plot velocity profile in center of domain
% figure
% plot(zDown_aa(:,


%% save as a VTK file for visualization with VisIt or ParaView, or VAPOR

% vtkwrite([dir_vectors filesep 'vtk' filesep 'vtk_velocity_instantaneous__' sprintf('%5.5d', n) '.vtk'], ...
% 'structured_grid',x,y,z, 'vectors','velocity',fu,fv,fw) 

%% save data in Matlab format


%% Collect output
% ROMS.xNorth = xNorth;
% ROMS.yEast  = yEast;
% ROMS.zDown  = zDown;
% 
% ROMS.xNorth_aa = xNorth_aa;
% ROMS.yEast_aa  = yEast_aa;
% ROMS.zDown_aa  = zDown_aa;
% 
% ROMS.u_rho   = u_rho;
% ROMS.v_rho   = v_rho;
% ROMS.w_rho   = w_rho;
% ROMS.spd_rho = spd_rho;
% 
% ROMS.u_rho_aa   = u_rho_aa;
% ROMS.v_rho_aa   = v_rho_aa;
% ROMS.w_rho_aa   = w_rho_aa;
% ROMS.spd_rho_aa = spd_rho_aa;
% 
% ROMS.z_rho = z_rho;
% ROMS.z_rho_aa = z_rho_aa;
% 
% ROMS.lon_aa = lon_aa;
% ROMS.lat_aa = lat_aa;
% 
% %% DEBUG plot
% max(ROMS.xNorth(:))
% min(ROMS.xNorth(:))
% max(ROMS.yEast(:))
% min(ROMS.yEast(:))
% 
% max(ROMS.xNorth_aa(:))
% min(ROMS.xNorth_aa(:))
% 
% % plot as a point cloud
% hfig_debug = figure;
% for n = 1
% % for n = 1:20
%     xxx = squeeze( ROMS.xNorth_aa(n,:,: ));
%     yyy = squeeze( ROMS.yEast_aa(n,:,: ));
%     zzz = squeeze( ROMS.zDown_aa(n,:,: ));
%     fff = squeeze( ROMS.spd_rho_aa(n,:,: ));
%     scatter3(xxx(:), yyy(:), zzz(:), fff(:), 'CData', fff(:))  
% end
% colorbar
% axis equal
% % load the STL file to add to plot
% [vertices, faces, normals, name] = stlReadBinary([OPTIONS.dir_case filesep 'seabed.stl']);
% figure(hfig_debug)
% hold on
% stlPlot(vertices,faces,name);
% 
% figure
% for n = 1
% % for n = 1:20
%     xxx = squeeze( ROMS.xNorth(n,:,: ));
%     yyy = squeeze( ROMS.yEast(n,:,: ));
%     zzz = squeeze( ROMS.zDown(n,:,: ));
%     fff = squeeze( ROMS.spd_rho(n,:,: ));
%     scatter3(xxx(:), yyy(:), zzz(:), fff(:), 'CData', fff(:))
% %     scatter3(xxx(:), yyy(:), zzz(:), fff(:), 'filled')
%     
% %     scatter3(xyzuvw_aa(:,1), xyzuvw_aa(:,2), xyzuvw_aa(:,3))    
% end
% colorbar
% axis equal
% 
% 



%% OLD
%% PSI points
% 
% % [~,~,lon_pfield] = rho2uvp( lon_rho );
% % [~,~,lat_pfield] = rho2uvp( lat_rho );
% % [~,~,lon_pfield] = rho2uvp( lon );
% % [~,~,lat_pfield] = rho2uvp( lat );
% 
% u_psi = zeros(size(Z_psi,1), size(u,2)-1, size(v,3)-1);
% v_psi = zeros(size(Z_psi,1), size(u,2)-1, size(v,3)-1);
% for n = 1:size(Z_rho,1)
%     % then to psi
% %     [~,~,u_psi(n,:,:)] = rho2uvp(u_rho(n,:,:));  
% %     [~,~,v_psi(n,:,:)] = rho2uvp(v_rho(n,:,:));
%     [~,~,u_psi(n,:,:)] = rho2uvp( squeeze( u_rho(n,:,:) ) );  
%     [~,~,v_psi(n,:,:)] = rho2uvp( squeeze( v_rho(n,:,:) ) );
% end
% 
%         
%         
% % u_pfield = zeros(size(Z));
% % v_pfield = zeros(size(Z));
% % w_pfield = zeros(size(Z));
% psi_u = zeros(size(Z,1), size(Z,2)-1, size(Z,3)-1);
% psi_v = zeros(size(Z,1), size(Z,2)-1, size(Z,3)-1);
% psi_w = zeros(size(Z,1), size(Z,2)-1, size(Z,3)-1);
% for n = 1:size(Z_psi,1);   
%     % compute the values at u,v and psi points...
%     
%     if n == 1
%         % at the seabed so velocities should remain zero ( or does a
%         % closure model give the velocity in the buffer/outr layer?)
%         psi_u(n,:,:) = 6;
%         psi_v(n,:,:) = 6;
%     else
%         [~,~,u_pfield] = rho2uvp( squeeze( u_rho(n-1,:,:) ));
%         [~,~,v_pfield] = rho2uvp( squeeze( v_rho(n-1,:,:) ));
%         psi_u(n,:,:) = u_pfield;
%         psi_v(n,:,:) = v_pfield;
%         
%     end
%     
%     [~,~,w_pfield] = rho2uvp( squeeze( w(n,:,:) ));
%     psi_w(n,:,:)   = w_pfield;
%     
% end
% 
% % NOTE the 'w' velocity is normal to the cell faces then aligned with
% % gravity, use a different velocity wvel
% % wvel
% %     True vertical velocity component, w ( ? , ? , s ) . It is computed only for output purposes.
%     



%% OLD


%% list and extract some variables from the ROMS netcdf output
% OPTIONS.fileTopo_ROMS = '/mnt/data-RAID-1/danny/ainlet_2006_3/OUT/ocean_his_0290.nc';
% ncdisp(OPTIONS.fileTopo_ROMS,'/','min')

% % extract the variables from the NetCDF file within the specified lat/lon refinement
% his.lon1        = nc_varget(OPTIONS.fileTopo_ROMS,'lon_u');
% his.lat1        = nc_varget(OPTIONS.fileTopo_ROMS,'lat_v');
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
% his.h       = nc_varget(OPTIONS.fileTopo_ROMS,'h',         [his.lat_nstart-1 his.lon_nstart-1],[sum(his.latmask) sum(his.lonmask)]);
% 
% % note .. something '?' with this, originally this is how Parker opened
% % the PSDEM stuff, but the ROMS is probably different ... look into other
% similar other codes or AGRIF, or RSLICE
% his.h       = nc_varget(OPTIONS.fileTopo_ROMS,'h',         [his.lat_nstart-1 his.lon_nstart-1],[sum(his.latmask) sum(his.lonmask)]);
% his.zeta    = nc_varget(OPTIONS.fileTopo_ROMS,'zeta',      [his.lat_nstart-1 his.lon_nstart-1],[sum(his.latmask) sum(his.lonmask)]);
% his.theta_s = nc_varget(OPTIONS.fileTopo_ROMS,'theta_s',   [his.lat_nstart-1 his.lon_nstart-1],[sum(his.latmask) sum(his.lonmask)]);
% his.theta_b = nc_varget(OPTIONS.fileTopo_ROMS,'theta_b',   [his.lat_nstart-1 his.lon_nstart-1],[sum(his.latmask) sum(his.lonmask)]);
% his.hc      = nc_varget(OPTIONS.fileTopo_ROMS,'hc',        [his.lat_nstart-1 his.lon_nstart-1],[sum(his.latmask) sum(his.lonmask)]);

% see Kristen's thesis for more info about correct TKE and Epsilon variables
% gls_m
%     Generic length-scale turbulent kinetic energy exponent
% gls_n
%     Generic length-scale turbulent length scale exponent
% gls_sigk
%     Generic length-scale closure independent constant Schmidt number for turbulent kinetic energy diffusivity    
 
%% inspired by RSLICE
% gridfile = snc_roms_get_grid(OPTIONS.fileTopo_ROMS);
% % excellent this seemed to work perfect, but dont need to load all variables
% 
%      lon_rho: [345x224 double]
%      lat_rho: [345x224 double]
%     mask_rho: [345x224 double]
%      lon_psi: [344x223 double]
%      lat_psi: [344x223 double]
%     mask_psi: [344x223 double]
%        lon_u: [345x223 double]
%        lat_u: [345x223 double]
%       mask_u: [345x223 double]
%        lon_v: [344x224 double]
%        lat_v: [344x224 double]
%       mask_v: [344x224 double]
%           pm: [345x224 double]
%           pn: [345x224 double]
%      theta_s: 4
%      theta_b: 0.5000
%       Tcline: 0
%        s_rho: [20x1 double]
%          s_w: [21x1 double]
%            h: [345x224 double]
%            N: 20
%          z_r: [20x345x224 double]
%          z_w: [21x345x224 double]
%           hc: 0
%         sc_r: [20x1 double]
%         sc_w: [21x1 double]
%         Cs_r: [20x1 double]

% Parker's code returns DX, DY, M, L ... which donts seem useful


%% some DEBUG things

% gridfile.z_w(:,100,100) % note: last index of z is the free surface, 1st is the seabed depth (negative value)

% use NC_DUMP/NC_INFO and NC_VARGET/NC_ATTGET instead
% nc_dump(OPTIONS.fileTopo_ROMS)
% nc_getvarinfo(OPTIONS.fileTopo_ROMS, 'xi_rho')  % I had a NetCDF error when trying to use this
% nc_varget(OPTIONS.fileTopo_ROMS, 'xi_rho')      % I had a NetCDF error when trying to use this

% dimensions
% xi_rho = 224 ;
% xi_u = 223 ;
% xi_v = 224 ;
% xi_psi = 223 ;
% eta_rho = 345 ;
% eta_u = 345 ;
% eta_v = 344 ;
% eta_psi = 344 ;
% s_rho = 20 ;
% s_w = 21 ;
% % 
% %     
% % % NOTE: gridfile mesh is not the same as the ROMS mesh
% % 
% % % convert the entire ROMS domain into the NED coordinate system
% % % now convert into proper z coordinates
% % % [agrif.lat,agrif.lon,agrif.mask,agrif.spd] = get_speed_depth_avg(OPTIONS.fileTopo_ROMS,OPTIONS.fileTopo_ROMS,1,[],1);
% % ROMS = convert_z_NED(OPTIONS,1);  % all variables are transfered to the RHO grid
% % % NED = convert_z_NED(gridfile,1,1);
% % % NED = convert_z_NED(OPTIONS.fileTopo_ROMS,1,1);
% % 
% % [ROMS.G, ROMS.S, ROMS.T] = Z_get_basic_info(OPTIONS.fileTopo_ROMS);
% % ROMS    = convert_z_NED(OPTIONS,1);  % all variables are transfered to the RHO grid
% % 
% % 
% % 
% % u_pandora = nc_varget(OPTIONS.fileTopo_ROMS,'u',[0 ROMS.S.N-1 0 0],[1 1 -1 -1]);
% % v_pandora = nc_varget(OPTIONS.fileTopo_ROMS,'v',[0 ROMS.S.N-1 0 0],[1 1 -1 -1]);
% % w_pandora = nc_varget(OPTIONS.fileTopo_ROMS,'w',[0 ROMS.S.N-1 0 0],[1 1 -1 -1]);
% % 
% % % truncate to the LON - LAT area of interest
% %     lon_a = find(ROMS.lon(1,:) >= OPTIONS.aa(1),1,'first');
% %     lon_b = find(ROMS.lon(1,:) >= OPTIONS.aa(2),1,'first');    
% %     lat_a = find(ROMS.lat(:,1) >= OPTIONS.aa(3),1,'first');
% %     lat_b = find(ROMS.lat(:,1) >= OPTIONS.aa(4),1,'first');
% % %     lon1_aa        = nc_varget(OPTIONS.fileTopo,'lon');
% % %     lat1_aa        = nc_varget(OPTIONS.fileTopo,'lat');
% %     lonmask_aa     = ROMS.lon(:)>=OPTIONS.aa(1) & ROMS.lon(:)<=OPTIONS.aa(2);
% %     latmask_aa     = ROMS.lat(:)>=OPTIONS.aa(3) & ROMS.lat(:)<=OPTIONS.aa(4);
% %     lon_aa         = lon1(lonmask_aa);
% %     lat_aa         = lat1(lonmask_aa);
% %     lon_nstart_aa  = find(ROMS.lon(:) == lon(1));
% %     lat_nstart_aa  = find(ROMS.lat(:) == lat(1));
% % 
% %     u_pandora = nc_varget(OPTIONS.fileTopo_ROMS,'u',[lon_a-1 lon_b-1 lat_b-1 lat_b-1],[1 1 -1 -1]);
% %     v_pandora = nc_varget(OPTIONS.fileTopo_ROMS,'v',[0 ROMS.S.N-1 0 0],[1 1 -1 -1]);
% %     w_pandora = nc_varget(OPTIONS.fileTopo_ROMS,'w',[0 ROMS.S.N-1 0 0],[1 1 -1 -1]);
% % 
% % figure; Z_pcolorcen(ROMS.G.lon_u, ROMS.G.lat_u, u_pandora);

% % deal with the "fill values" of NetCDf
%     % overwrite the outliers, on the landmask ROMS will report values of like 1e38 ... makes no sense
%     outlier_thold = 100;
%     outlier_value = nan;    % convenient to replace with NAN in Matlab, but STAR-CCM+ has troubles with NAN values
%     ROMS.u(abs(ROMS.u) > outlier_thold) = outlier_value;
%     ROMS.v(abs(ROMS.v) > outlier_thold) = outlier_value;
%     ROMS.w(abs(ROMS.w) > outlier_thold) = outlier_value;
%     ROMS.z(    ROMS.z  > outlier_thold) = outlier_value;
    
    
% %     
% %     
% %     
% %     
% %     %% OLD BELOW
% % %%
% % % the ROMS domain is likely larger than the area of interest, keep the
% % % entire ROMS domain for later reference
% % roms.xNorth = zeros(size(NED.z));
% % roms.yEast  = zeros(size(NED.z));
% % roms.zDown  = zeros(size(NED.z));
% % for n = 1:size(NED.z,1);
% %     
% % %     [roms.xNorth(n,:,:), roms.yEast(n,:,:), roms.zDown(n,:,:)] = geodetic2ned(NED.lat,NED.lon,squeeze( NED.z(n,:,:) ),lat0,lon0,OPTIONS.z0,spheroid); % (this undoes the meshgridding)
% %     [roms.xNorth(n,:,:), roms.yEast(n,:,:), roms.zDown(n,:,:)] = geodetic2ned(ROMS.G.lat_rho,ROMS.G.lon_rho,squeeze( NED.z(n,:,:) ),lat0,lon0,OPTIONS.z0,spheroid); % (this undoes the meshgridding)
% % end
% % 
% % 
% % 
% % % ROMS_aa.xNorth = zeros(size(ROMS.z,1), lat_b - lat_a + 1, lon_b - lon_a + 1);
% % % ROMS_aa.yEast  = zeros(size(ROMS.z,1), lat_b - lat_a + 1, lon_b - lon_a + 1);
% % % ROMS_aa.zDown  = zeros(size(ROMS.z,1), lat_b - lat_a + 1, lon_b - lon_a + 1);
% % ROMS_aa.xNorth = zeros(size(ROMS.z,1), lon_b - lon_a + 1, lat_b - lat_a + 1);
% % ROMS_aa.yEast  = zeros(size(ROMS.z,1), lon_b - lon_a + 1, lat_b - lat_a + 1);
% % ROMS_aa.zDown  = zeros(size(ROMS.z,1), lon_b - lon_a + 1, lat_b - lat_a + 1);
% % for n = 1:size(ROMS.z,1);
% % 
% %     ROMS_aa.z = squeeze(ROMS.z(n,lat_a:lat_b,lon_a:lon_b));
% %     
% % %     [LON_aa, LAT_aa] = meshgrid(lon(lon_a,lon_b), lon_a,lon_b);
% %     [LON_aa, LAT_aa] = meshgrid(ROMS.lat(lat_a:lat_b), ROMS.lon(lon_a:lon_b));
% %     
% %     [ROMS_aa.xNorth(n,:,:), ROMS_aa.yEast(n,:,:), ROMS_aa.zDown(n,:,:)] = geodetic2ned(LAT_aa,LON_aa,ROMS_aa.z,lat0,lon0,OPTIONS.z0,spheroid); % (this undoes the meshgridding)
% % end
% % 
% % % now write all the scalar values to a CSV file
% % % will later load into STAR-CCM+ as a point cloud and then
% % % use data mapping to interpolate ROMS on to the unstructured finite-volume mesh
% % 
% % 
% % 
% % % ROMS NED coordinates means positive z is down, negative z is landmass
% % % starccm convention is negative z mean water
% % % roms.zDown(roms.zDown < 0) = 0;     % remove landmass and masked values
% % % roms.zDown(roms.zDown < -100) = nan;     % remove landmass and masked values
% % % roms.zDown = -1 .* roms.zDown;      % make negatoive for starccm convention
% % % roms.zDown = flip(roms.zDown ,1);   % flip the dimensions such that 1st z index is the sea surface
% % % roms.zDown = -1 .* NED.z;
% % roms.zDown = NED.z;
% % 
% % % in ROMS, the first z dimenstion corresponds to the cells on seabed, last index is surface
% % % roms.xNorth = flip(roms.xNorth,1);
% % % roms.xNorth = flip(roms.xNorth,2);
% % % roms.xNorth = flip(roms.xNorth,3);
% % 
% % % roms.yEast = flip(roms.xNorth,1);
% % % roms.yEast = flip(roms.xNorth,2);
% % % roms.yEast = flip(roms.xNorth,3);
% % 
% % % NED.u_rho = flip(NED.u_rho,1);
% % % NED.u_rho = flip(NED.u_rho,2);
% % % NED.u_rho = flip(NED.u_rho,3);
% % 
% % % NED.v_rho = flip(NED.v_rho,1);
% % % NED.v_rho = flip(NED.v_rho,2);
% % % NED.v_rho = flip(NED.v_rho,3);
% % 
% % % NED.w_rho = flip(NED.w_rho,1);
% % % NED.w_rho = flip(NED.w_rho,2);
% % % NED.w_rho = flip(NED.w_rho,3);
% % 
% % %% debug plot
% % % note: NED has the entire domain
% % % yEast, xNorth, zDown is the subset domain of the topography file
% % % need to create the subdomain of a ROMS file
% % 
% % figure
% % pcolor(yEast, xNorth, zDown)
% % shading flat
% % 
% % figure
% % pcolor(yEast, xNorth, squeeze(NED.z(1,:,:)))
% % shading flat
% % 
% % figure
% % pcolor(ROMS.yEast, ROMS.xNorth, squeeze(ROMS.zDown(1,:,:)))
% % shading flat
% % 
% % figure
% % zLevel = 2;
% % % pcolor(roms.yEast, roms.xNorth, squeeze(NED.u(zLevel,:,:)))
% % pcolor(squeeze(roms.yEast(zLevel,:,:)), squeeze(roms.xNorth(zLevel,:,:)), squeeze(NED.u(zLevel,:,:)))
% % shading flat
% % caxis([-1 1])
% % %%
% % % xyz = [roms.xNorth(:) roms.yEast(:) roms.zDown(:)];
% % 
% % 
% % % csvwrite([OPTIONS.dir_case filesep 'roms_rho_xyz.csv'],    [xyz roms.u]);
% % % csvwrite([OPTIONS.dir_case filesep 'roms_rho_xyzuvw.csv'], xyzuvw);
% % 
% % csv_filename = [OPTIONS.dir_case filesep 'roms_rho_xyzuvw.csv'];
% % xyzuvw       = [roms.xNorth(:) roms.yEast(:) roms.zDown(:) NED.u(:) NED.v(:) NED.w(:)];
% % 
% % % if the file already exists, overwrite
% % if exist(csv_filename, 'file')==2
% %   delete(csv_filename);
% % end
% % 
% % % write the header and then append the data
% % fid = fopen(csv_filename, 'w');
% % fprintf(fid, 'X,Y,Z,u,v,w\n');
% % fclose(fid);
% % dlmwrite(csv_filename, xyzuvw, '-append', 'precision', '%.6f', 'delimiter', ',');
% % 
% % 
% % %% debug
% % figure
% % plot(roms.zDown(:,100,100), NED.spd(:,100,100))
% % 
% % roms.zDown(1,100,100)
% % roms.zDown(20,100,100)
% % NED.spd(1,100,100)
% % NED.spd(20,100,100)
% % 
% % %
% % figure; 
% % nn = 1 + ceil( 100.*rand(10) );
% % for n = 1:nn
% %     subplot(1,2,1)
% %         hold on
% %         plot(NED.u(:,nn(n),nn(n)), roms.zDown(:,nn(n),nn(n)))
% %         ylabel('zDown')
% %         xlabel('velocity, u')
% %     subplot(1,2,2)
% %         hold on
% %         plot(NED.v(:,nn(n),nn(n)), roms.zDown(:,nn(n),nn(n)))
% %         xlabel('velocity, v')
% % end
% % 
% % 
% % figure
% % 345/2
% % 224/2
% % plot(NED.spd(:,112,172), roms.zDown(:,112,172))
% % 
% % NED.z(:,112,172)
% % roms.zDown(:,112,172)
% % 
% % %
% % figure
% % zLev = 20;
% % pcolor(squeeze(roms.xNorth(zLev,:,:)), squeeze(roms.yEast(zLev,:,:)), squeeze(NED.spd(zLev,:,:)))
% % shading flat
% % 
% % figure
% % zLev = 20;
% % pcolor(squeeze(roms.xNorth(zLev,:,:)), squeeze(roms.yEast(zLev,:,:)), squeeze(NED.spd(zLev,:,:)))
% % shading flat

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
% transforms, then export the vel/turbulence fields on the nested domain boundaries

% roms_gui
% 
% % get the depths, properly computed
% % z = zlevs(h,zeta,theta_s,theta_b,hc,N,type,vtransform)
% Z=squeeze(zlevs(h,zeta,theta_s,theta_b,hc,Nr,type,s_coord));



% h,zeta,theta_s,theta_b,hc















%% save as a VTK file for visualization with VisIt or ParaView, or VAPOR


%% now use RSLICE to extract the flow fields at this bounding box


end

