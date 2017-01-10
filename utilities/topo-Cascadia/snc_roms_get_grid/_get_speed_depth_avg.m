function [lat,lon,mask,spd]=get_speed_depth_avg(hisfile,gridfile,tindex,vlevel,coef)
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
% modified September 2015 by Danny Sale to add depth averaged speed
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% just loop through this at each depth index
nc = netcdf(gridfile);



[lat, lon, mask] = read_latlonmask(gridfile, 'r');

zeta = squeeze(nc{'zeta'}(tindex,:,:));
h    = nc{'h'}(:);

% if (isempty(theta_s))
%  disp('Rutgers version')
  theta_s = nc{'theta_s'}(:);
  theta_b = nc{'theta_b'}(:);
  Tcline  = nc{'Tcline'}(:);
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


% get the depth at each lat lon index
Z = squeeze(zlevs(h,zeta,theta_s,theta_b,hc,Nr,'w',s_coord));

% get the velocity at rho point

u = squeeze(nc{'u'}(tindex,:,:,:));
v = squeeze(nc{'v'}(tindex,:,:,:));


spd_horz = zeros(size(Z));
% var = zeros(size(Z));
for k = 1:size(Z, 1)-1;

    u_slice = squeeze(nc{'u'}(tindex,k,:,:));
    v_slice = squeeze(nc{'v'}(tindex,k,:,:));

    u_rho = u2rho_2d(u_slice);
    v_rho = v2rho_2d(v_slice);

    spd_horz(k,:,:) = coef.*sqrt(u_rho.^2 + v_rho.^2); 
    
end


% now integrate the speeds to get the depth averaged speed
% only loop over the lat long masked variables
nPts = 1 .* size(Z,1);

spd = zeros(size(Z,2), size(Z,3));
for j = 1:size(Z, 2);
    for i = 1:size(Z, 3);

        d_max = abs( min(Z(:,j,i)) );
        
        zq = linspace(0, d_max, nPts) .* mask(j,i);
        
        spd(j,i) = trapz(zq, spd_horz(:,j,i)) ./ d_max;

    end
end

spd = spd .* mask;

close(nc)

% save a .mat binary file to test the "vfplot" code:
% http://soliton.vm.bytemark.co.uk/pub/vfplot/index.html
u = u_rho;
v = v_rho;
% save(['/mnt/data-RAID-1/danny/topo-cascadia/vfplot_ainlet'],'u','v')
% 
% % write into the simple ASCII format http://soliton.vm.bytemark.co.uk/pub/vfplot/manual-sag.html
% file = '/mnt/data-RAID-1/danny/topo-cascadia/vfplot_ainlet/vfplot_ascii.txt';
% fid = fopen(file,'w+');
% fprintf(fid, '#sag 1 %g %g %g %g %g %g %g %g 0.01 \n',2,2,i,j,lat(1,1),lat(end,1),lon(1,1),lon(1,end));
% vf_lat = lat(:);
% vf_lon = lon(:);
% vf_u   = u(:);
% vf_v   = v(:);
% % overwrite bad values
% vf_u(vf_u > 10) = 0;
% vf_v(vf_v > 10) = 0;
% for n = 1:numel(u)
%     fprintf(fid, '%g %g %g %g \n',vf_lat(n),vf_lon(n),vf_u(n),vf_v(n));
% end
% fclose(fid)
grdwrite2(lat(:,1),lon(1,:),u,'/mnt/data-RAID-1/danny/topo-cascadia/vfplot_ainlet/u.grd');
grdwrite2(lat(:,1),lon(1,:),v,'/mnt/data-RAID-1/danny/topo-cascadia/vfplot_ainlet/v.grd');


% 
% u=mean(squeeze(nc{'u'}(tindex,:,J,I-1:I)),2);
% v=mean(squeeze(nc{'v'}(tindex,:,J-1:J,I)),2);
% var=coef.*sqrt(u.^2+v.^2);  
    
%% got this from the vertical profile code
% strcmp(vname,'*Speed')
%     u=mean(squeeze(nc{'u'}(tindex,:,J,I-1:I)),2);
%     v=mean(squeeze(nc{'v'}(tindex,:,J-1:J,I)),2);
%     var=coef.*sqrt(u.^2+v.^2);
% 
%     u   = mean(squeeze(nc{'u'}(tindex,:,J,I-1:I)),2);
%     v   = mean(squeeze(nc{'v'}(tindex,:,J-1:J,I)),2);
%     var = coef.*sqrt(u.^2+v.^2);
% 
%     
%     zeta = squeeze(nc{'zeta'}(tindex,:,:));
% h    = nc{'h'}(:);
% 
%   theta_s=nc{'theta_s'}(:);
%   theta_b=nc{'theta_b'}(:);
%   
% Nr   = length(nc('s_rho'));    
% type = 'w';
% Z    = squeeze(zlevs(h,zeta,theta_s,theta_b,hc,Nr,type,s_coord));
% 
% 
% 
% close(nc)
