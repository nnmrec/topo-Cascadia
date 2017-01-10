function [] = PS_JdF_sect(Tdir,infile,basename,tt)
%
% plots Salish simulations with a section down the middle of JdF and
% through the Main Basin of PS and into South Sound to Budd Inlet
%
% 1/17/2012  Parker MacCready

[G,S,T]=Z_get_basic_info(infile);

s0 = nc_varget(infile,'salt',[0 S.N-1 0 0],[1 1 -1 -1]);

% define the vector for the section
load([Tdir.pan_results,'sections/jdf_ps_thalweg.mat']);
slon = x; slat = y;

cvec = [28 33];

subplot(2,3,[1 4])
%pcolorcen(G.lon_rho,G.lat_rho,s0);
pcolor(G.lon_rho,G.lat_rho,s0); shading flat;
axis([-125 -122 46.5 48.9]); 
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

nn = 10;
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
pcolor(sect.dist/1e3,sect.z,us);
shading interp
vlims = [-.2 .2];
caxis(vlims);
hold on
plot(sect.dist/1e3,sect.z(1,:),'-k','linewidth',2);
title('Along-section Velocity (m s^{-1})')
colorbar('eastoutside')
xlabel('Distance from JdF mouth (km)');
ylabel('Z (m)');







