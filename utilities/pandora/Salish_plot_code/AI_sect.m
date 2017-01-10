%function [] = AI_sect(Tdir,infile,basename,tt)
%
% plots Salish simulations with a section in AI
%
% 6/22/2012  Parker MacCready

[G,S,T]=Z_get_basic_info(infile);

s0 = nc_varget(infile,'salt',[0 S.N-1 0 0],[1 1 -1 -1]);

% define the vector for the section
slon = [-122.685 -122.75]; slat = [48.166 48.133];

cvec = [28 33];

subplot(2,3,[1 4])
%pcolorcen(G.lon_rho,G.lat_rho,s0);
pcolor(G.lon_rho,G.lat_rho,s0); shading flat;
caxis(cvec);
title('Surface Salinity','fontweight','bold')
xlabel('Longitude (deg)')
ylabel('Latitude (deg)')
[xt,yt]=Z_lab('lr');
% add file info
Z_info(basename,tt,T,'ll');
% add coastline
Z_addcoast('combined',Tdir.coast);
Z_dar;
% add the section line
hold on
plot(slon,slat,'-m','linewidth',3)
plot(slon,slat,'-k','linewidth',1)

% make some sections

nn = 50;
sect_lon = [];
sect_lat = [];
for ii = 1:length(slon)-1
    sect_lon = [sect_lon linspace(slon(ii),slon(ii+1),nn)];
    sect_lat = [sect_lat linspace(slat(ii),slat(ii+1),nn)];
end

% Salinity Section
[sect] = Z_make_sect(infile,sect_lon,sect_lat,'salt');
subplot(2,3,[2 3])
pcolor(sect.dist/1e3,sect.z,sect.var);
shading interp
caxis(cvec);
colorbar('eastoutside')
hold on
contour(sect.dist/1e3,sect.z,sect.var,[1:.5:38],'-k');
plot(sect.dist/1e3,sect.z(1,:),'-k','linewidth',2);
title('Salinity section')
ylabel('Z (m)');
%save sect; % for estuary summit paper 1/17/2012

% Velocity Section
[sect] = Z_make_sect(infile,sect_lon,sect_lat,'uv');
% get the normal velocity
ca = cos(sect.ang_rad); sa = sin(sect.ang_rad);
us = ca.*real(sect.var) + sa.*imag(sect.var);
un = ca.*imag(sect.var) - sa.*real(sect.var);
%
subplot(2,3,[5 6])
pcolor(sect.dist/1e3,sect.z,un);
shading interp
vlims = [-2 2];
caxis(vlims);
hold on
plot(sect.dist/1e3,sect.z(1,:),'-k','linewidth',2);
title('Along-section Velocity (m s^{-1})')
colorbar('eastoutside')
xlabel('Distance from JdF mouth (km)');
ylabel('Z (m)');







