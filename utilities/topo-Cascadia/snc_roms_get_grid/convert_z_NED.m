function NED = convert_z_NED(OPTIONS,tindex)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  Get the speed of the currents
%
%  Further Information:  
%  http://www.brest.ird.fr/Roms_tools/
%  
%  This file is part of ROMSTOOLS
%
%  ROMSTOOLS is free software; you can redistribute it and/or modify
%  it under the terms of the GNU General Public License as published
%  by the Free Software Foundation; either version 2 of the License,
%  or (at your option) any later version.
%
%  ROMSTOOLS is distributed in the hope that it will be useful, but
%  WITHOUT ANY WARRANTY; without even the implied warranty of
%  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%  GNU General Public License for more details.
%
%  You should have received a copy of the GNU General Public License
%  along with this program; if not, write to the Free Software
%  Foundation, Inc., 59 Temple Place, Suite 330, Boston,
%  MA  02111-1307  USA
%
%  Copyright (c) 2002-2006 by Pierrick Penven 
%  e-mail:Pierrick.Penven@ird.fr
% 
% modified September 2015 by Danny Sale to convert Z to North-East-Down
% coordinate system
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% just loop through this at each depth index
% hisfile = OPTIONS.fileTopo_ROMS;
% for n = 1:2
%     if vlevel==0
%       u=u2rho_2d(get_hslice(hisfile,gridfile,'ubar',...
%                  tindex,vlevel,'u'));
%       v=v2rho_2d(get_hslice(hisfile,gridfile,'vbar',...
%                  tindex,vlevel,'v'));
%     else
%       u=u2rho_2d(get_hslice(hisfile,gridfile,'u',...
%                  tindex,vlevel,'u'));
%       v=v2rho_2d(get_hslice(hisfile,gridfile,'v',...
%                  tindex,vlevel,'v'));
%     end
%     
%     
% end




%%
% nc = netcdf(gridfile);
nc = netcdf(OPTIONS.fileTopo_ROMS);
% nc = gridfile;
% nc = netcdf(ncid);
% 
% OPTIONS

% using the modern Matlab API
% ncid  = netcdf.open(OPTIONS.fileTopo_ROMS,'NOWRITE');
% varid = netcdf.inqVarID(ncid,'u');
% uuu   = netcdf.getVar(ncid,varid)

% [lat, lon, mask] = read_latlonmask(gridfile, 'r');
[lat, lon, mask] = read_latlonmask(OPTIONS.fileTopo_ROMS, 'r');     % in rho points


% if (isempty(theta_s))
%  disp('Rutgers version')
%   angle=nc{'angle'}(:);
  theta_s = nc{'theta_s'}(:);
  theta_b = nc{'theta_b'}(:);
  Tcline  = nc{'Tcline'}(:);
  

  zeta    = squeeze(nc{'zeta'}(tindex,:,:));
  h       = nc{'h'}(:);
  hmin    = min(min(h));
  hc      = min(hmin,Tcline);

% else
%     disp('Sorry not implemented yet, only "Rutgers version" for now')
%     return
% end

Nr = length(nc('s_rho'));
s_coord = 1;
VertCoordType = nc.VertCoordType(:);
if isempty(VertCoordType)
    vtrans = nc{'Vtransform'}(:);
    if ~isempty(vtrans)
        s_coord = vtrans;
    end
elseif VertCoordType == 'NEW'
    s_coord = 2;
    hc      = Tcline;
end


% compute the depth of rho or w points for ROMS
% get the depth at each lat lon index
Z_rho = squeeze(zlevs(h,zeta,theta_s,theta_b,hc,Nr,'r',s_coord));
% % Z_psi = squeeze(zlevs(h,zeta,theta_s,theta_b,hc,Nr,'w',s_coord));


%% Collect the output
%  this is only the mesh information at the rho points, and converted to
%  North East Down

% get the velocity at psi points, which are the mesh nodes
% from ncdisp:
%     u          
%            Size:       223x345x20x1
%            Dimensions: xi_u,eta_u,s_rho,ocean_time
%            Datatype:   single
%            Attributes:
%                        long_name   = 'u-momentum component'
%                        units       = 'meter second-1'
%                        time        = 'ocean_time'
%                        coordinates = 'lon_u lat_u s_rho ocean_time'
%                        field       = 'u-velocity, scalar, series'
%                        _FillValue  = 9.999999933815813e+36

% u = squeeze(nc{'u'}(tindex,:,:,:));
% v = squeeze(nc{'v'}(tindex,:,:,:));
% w = squeeze(nc{'w'}(tindex,:,:,:));

% THIS WORKS AS OF DEC 7
u = nc{'u'}(tindex,:,:,:);
v = nc{'v'}(tindex,:,:,:);
w = nc{'w'}(tindex,:,:,:);
% THIS WORKS AS OF DEC 7, try PANDORA
% [G, S, T] = Z_get_basic_info(OPTIONS.fileTopo_ROMS);
% u = nc_varget(OPTIONS.fileTopo_ROMS,'u',[0 S.N-1 0 0],[1 1 -1 -1]);
% v = nc_varget(OPTIONS.fileTopo_ROMS,'v',[0 S.N-1 0 0],[1 1 -1 -1]);
% w = nc_varget(OPTIONS.fileTopo_ROMS,'w',[0 S.N-1 0 0],[1 1 -1 -1]);

% wvel = nc{'wvel'}(tindex,:,:,:);

% u=nc_read([dir filename],'u');
% v=nc_read([dir filename],'v');
% w=nc_read([dir filename],'w');

% both the same size
% % rho_lon = nc{'lon_rho'};
% % rho_lat = nc{'lat_rho'};
% % psi_lon = nc{'lon_psi'};
% % psi_lat = nc{'lat_psi'};
% for n = 1:size(rho_lon, 1)
%     rho_lon_fix = rho_lon;
%     rho_lat_fix = rho_lat;
% end

% rho_lon = nc{'lon_rho'}(tindex,:,:,:);
% rho_lat = nc{'lat_rho'}(tindex,:,:,:);
% psi_lon = nc{'lon_psi'};
% psi_lat = nc{'lat_psi'};
% [PSI_lon, PSI_lat] = meshgrid(psi_lon, psi_lat); % this step crashes my compy, uses like 96 Gib of memory, when I have 64 + swap



close(nc)



%% test the vertical levels of w ... how to put w on the psi points?

  
% %% need to select the Area of Interest now
% % 
% % lonmask     = lon>=OPTIONS.aa(1) & lon<=OPTIONS.aa(2);
% % latmask     = lat>=OPTIONS.aa(3) & lat<=OPTIONS.aa(4);
% % 
% % mask_aa = lonmask & latmask;
% % for n = 1:size(u,1)
% %     uu = u(:,lonmask,latmask)
% %     
% % end
% % 
% % 
% % 
% % % lon1        = nc_varget(OPTIONS.fileTopo_ROMS,'lon');
% % % lat1        = nc_varget(OPTIONS.fileTopo_ROMS,'lat');
% % lonmask     = lon>=OPTIONS.aa(1) & lon<=OPTIONS.aa(2);
% % latmask     = lat>=OPTIONS.aa(3) & lat<=OPTIONS.aa(4);
% % lon_aa      = lon(lonmask);
% % lat_aa      = lat(latmask);
% % lon_nstart  = find(lon == lon_aa(1));
% % lat_nstart  = find(lat == lat_aa(1));
% % 
% % 
% % 
% % lon1        = nc_varget(OPTIONS.fileTopo,'lon');
% % lat1        = nc_varget(OPTIONS.fileTopo,'lat');
% % % lon1        = nc_varget(OPTIONS.fileTopo_ROMS,'lon');
% % % lat1        = nc_varget(OPTIONS.fileTopo_ROMS,'lat');
% % lonmask     = lon1>=OPTIONS.aa(1) & lon1<=OPTIONS.aa(2);
% % latmask     = lat1>=OPTIONS.aa(3) & lat1<=OPTIONS.aa(4);
% % lon_aa      = lon1(lonmask);
% % lat_aa      = lat1(latmask);
% % lon_nstart  = find(lon1 == lon_aa(1));
% % lat_nstart  = find(lat1 == lat_aa(1));
% % 
% % data = nc_varget('example.nc',        'peaks',[0 0], [20 30]);
% % u    = nc_varget(OPTIONS.fileTopo_ROMS,'u_bar',   [0 0],  [5 10]);
% % hh = nc_varget(OPTIONS.fileTopo_ROMS,'zeta',[lat_nstart-1 lon_nstart-1],[sum(latmask) sum(lonmask)]);
% % 
% % % uu = u(:,lat_nstart-1:lon_nstart-1,sum(latmask):sum(lonmask))
% % % vv = 
% % % ww = 
% % 
% % figure
% % % pcolor(x,y,psi_u)
% % z_level = 1;
% % pcolor(lat,lon,squeeze( u(z_level,:,:) ))

%% RHO points

% % lon_rho = u2rho_2d(lon);
% % lat_rho = v2rho_2d(lat);

% [n3dvars,varcell,L,M,N]=get_3dvars(nc);

%  [ur,vr,lonr,latr,spd]=uv_vec2rho(u,v,lon,lat,0,mask,1,[0 0 0 0]);
 
% u_rho = zeros(size(w));
% v_rho = zeros(size(w));
u_rho = zeros(size(Z_rho));
v_rho = zeros(size(Z_rho));
w_rho = zeros(size(Z_rho));
for n = 1:size(Z_rho,1);
    % first to rho
    u_rho(n,:,:) = u2rho_2d( squeeze( u(n,:,:) ));
    v_rho(n,:,:) = v2rho_2d( squeeze( v(n,:,:) ));

    % the rho points of the w grid can be found by midpoints
    w_rho(n,:,:) = (w(n,:,:) + w(n+1,:,:)) ./ 2;
end




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
%%
% % % plot for debugging
% % figure
% % hold on
% % % pcolor(PSI_lon, PSI_lat, psi_u)         % why does this use so much memory, like 96 GiB!?
% % % pcolor(psi_lon, psi_lat, psi_u(1,:,:))
% % % surf(psi_lon, psi_lat, psi_u(1,:,:))
% % [~,~,lon_pfield] = rho2uvp( lon_rho );
% % [~,~,lat_pfield] = rho2uvp( lat_rho );
% % % pcolor(lon_pfield, lat_pfield, psi_u);
% % pcolor(lon_pfield, lat_pfield, psi_u);
% % shading interp
% 
% % figure
% % % pcolor(x,y,psi_u)
% % z_level = 1
% % pcolor(psi_u(z_level,:,:))

%% collect output
% this include the entire ROMS domain

NED.lat  = lat;
NED.lon  = lon;
NED.mask = mask;    
NED.z    = Z_rho;

NED.u = u_rho;
NED.v = v_rho;
NED.w = w_rho;

NED.spd  = sqrt( u_rho.^2 + v_rho.^2 + w_rho.^2);

% % 
% % NED.u_psi = psi_u;
% % NED.v_psi = psi_v;
% % NED.w_psi = psi_w;
% % 
% % % NED.u_rho = zeros(size(Z));
% % % NED.v_rho = zeros(size(Z));
% % % for n = 1:size(w,1)
% % %     NED.u_rho(n,:,:) = u2rho_2d(u);
% % %     NED.v_rho(n,:,:) = u2rho_2d(v);
% % % end
% % 
% % 
% % NED.w_u3d = rho2u_3d(w);
% % % NED.w_v3d = rho2v_3d(w);
% % NED.w_rho = zeros(size(NED.u_rho));
% % for n = 1:size(NED.u_rho)
% %     NED.w_rho(n,:,:) = u2rho_2d( squeeze( NED.w_u3d(n,:,:) ) );
% % end

%% need to clip to the area of interest
% OPTIONS.aa















% %% Brad's method
% %% Obtain flow field in physical coordinates (you may have a different way of doing this)
% 
% dir = '/home/bperfect/ROMS/fieberling/';
% filename = 'ocean_his.nc';
% 
% dir = '';
% filename = OPTIONS.fileTopo_ROMS; 
% 
% %field variables
% u=nc_read([dir filename],'u');
% v=nc_read([dir filename],'v');
% w=nc_read([dir filename],'w');
% % rho=nc_read([dir filename],'rho');  % this variable is not found in the ainlet_2006 ROMS dataset
% rho=nc_read([dir filename],'rho0');  % this variable is not found in the ainlet_2006 ROMS dataset
% zeta = nc_read([dir filename],'zeta');
% temp=nc_read([dir filename], 'temp');
% 
% %vertical grid variables
% h=nc_read([dir filename],'h');
% s_w=nc_read([dir filename],'s_w');
% s_rho=nc_read([dir filename],'s_rho');
% 
% %y-coordinate grid variables
% y_rho=nc_read([dir filename],'y_rho');
% y_u=nc_read([dir filename],'y_u');
% y_v=nc_read([dir filename],'y_v');
% y_psi=nc_read([dir filename],'y_psi');
% %x-coordinate grid variables
% x_rho=nc_read([dir filename],'x_rho');
% x_v=nc_read([dir filename],'x_v');
% x_psi=nc_read([dir filename],'x_psi');
% x_u=nc_read([dir filename],'x_u');
% 
% 
% %% create the master grid that everything will be expressed in terms of
% hLevels = length(s_rho);
% rho_grid_z = zeros(length(x_rho(:,1)),length(x_rho(1,:)),length(s_rho));
% rho_grid_x = repmat(x_rho,1,1,hLevels);
% rho_grid_y = repmat(y_rho,1,1,hLevels);
% 
% %% Generate our z-dimension variables
% % Express height function as a 3D tensor in u and v coordinates for later interpolation
% h_in = griddedInterpolant(x_rho,y_rho,h); %interpolate h (given in rho coords)
% h_u_2d = h_in(x_u(:,:,1),y_u(:,:,1));
% h_v_2d = h_in(x_v(:,:,1),y_v(:,:,1));
% 
% h_u_3d = zeros(length(h_u_2d(:,1)),length(h_u_2d(1,:)),hLevels);
% h_v_3d = zeros(length(h_v_2d(:,1)),length(h_v_2d(1,:)),hLevels);
% h_w_3d = zeros(length(h(:,1)),length(h(1,:)),length(s_w));
% 
% %give our z-coordinate grids vertical variation
% for i=1:hLevels
%     h_u_3d(:,:,i) = h_u_2d*s_rho(i);
%     h_v_3d(:,:,i) = h_v_2d*s_rho(i);
%     rho_grid_z(:,:,i) = h*s_rho(i);
% end
% 
% for i = 1:length(s_w)
%     h_w_3d(:,:,i) = h*s_w(i);
% end
% 
% %% Generate our x and y-dimension variables
% x_u = repmat(x_u,1,1,hLevels);
% y_u = repmat(y_u,1,1,hLevels);
% x_v = repmat(x_v,1,1,hLevels);
% y_v = repmat(y_v,1,1,hLevels);
% x_w = repmat(x_rho,1,1,length(s_w));
% y_w = repmat(y_rho,1,1,length(s_w));
% 
% %% Grab our flow field at a given time
% timeIndex = 100;
% u_time = u(:,:,:,timeIndex);
% v_time = v(:,:,:,timeIndex);
% w_time = w(:,:,:,timeIndex);
% 
% %% Generate interpolation functions and interpolate
% %u interpolation
% u_in = scatteredInterpolant(x_u(:),y_u(:),h_u_3d(:),u_time(:));
% u_rho = u_in(rho_grid_x,rho_grid_y,rho_grid_z);
% %v interpolation
% v_in = scatteredInterpolant(x_v(:),y_v(:),h_v_3d(:),v_time(:));
% v_rho = v_in(rho_grid_x,rho_grid_y,rho_grid_z);
% %w interpolation
% w_in = scatteredInterpolant(x_w(:),y_w(:),h_w_3d(:),w_time(:));
% w_rho = w_in(rho_grid_x,rho_grid_y,rho_grid_z);
% 
% %Confirm that everything is in the same dimensions
% size(u_rho)
% size(v_rho)
% size(w_rho)
% size(rho)









