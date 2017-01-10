function [] = basic_ps(Tdir,infile,basename,tt)
%
% plots Salish simulations, a generic plot of the full domain
% with an inset of Puget Sound
% 8/28/2013  Parker MacCready

% get file info
[G,S,T]=Z_get_basic_info(infile);

% plot salinity
s0 = nc_varget(infile,'salt',[0 S.N-1 0 0],[1 1 -1 -1]);
subplot(121)
Z_pcolorcen(G.lon_rho,G.lat_rho,s0);
%shading flat
cvec = [26 32]; caxis(cvec);
%colorbar('Eastoutside');
% fix scaling
Z_dar;
% add labels
title('(a) Surface Salinity','fontweight','bold')
xlabel('Longitude (deg)')
ylabel('Latitude (deg)')
% add file info
Z_info(basename,tt,T,'lr');
% add coastline
Z_addcoast('combined',Tdir.coast);

% plot salinity
s0 = nc_varget(infile,'salt',[0 S.N-1 0 0],[1 1 -1 -1]);
subplot(122)
Z_pcolorcen(G.lon_rho,G.lat_rho,s0);
axis([-123.6 -122 47 49]);
%shading interp
%cvec = [26 32];
caxis(cvec);
colorbar('Eastoutside');
% fix scaling
Z_dar;
% add labels
title('(b) Puget Sound','fontweight','bold')
xlabel('Longitude (deg)')
ylabel('Latitude (deg)')
% add coastline
Z_addcoast('combined',Tdir.coast);

