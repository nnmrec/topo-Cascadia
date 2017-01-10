function [] = basic_bio(Tdir,infile,basename,tt)
%
% plots Salish simulations, a generic plot of the full domain, but for bio
% variables
% 1/26/2012  Parker MacCready

% get file info
[G,S,T]=Z_get_basic_info(infile);

% plot phytoplankton
s0 = nc_varget(infile,'phytoplankton',[0 S.N-1 0 0],[1 1 -1 -1]);
subplot(121)
pcolor(G.lon_rho,G.lat_rho,s0);
shading interp
cvec = [0 10]; caxis(cvec);
colorbar('Eastoutside');
% fix scaling
Z_dar;
% add labels
title('(a) Surface Phytoplankton (mmol N m^{-3})','fontweight','bold')
xlabel('Longitude (deg)')
ylabel('Latitude (deg)')
% add file info
Z_info(basename,tt,T,'lr');
% add coastline
Z_addcoast('combined',Tdir.coast);

% plot nitrate
t0 = nc_varget(infile,'NO3',[0 S.N-1 0 0],[1 1 -1 -1]);
subplot(122)
pcolor(G.lon_rho,G.lat_rho,t0);
shading interp
cvec = [0 20]; caxis(cvec);
colorbar('Eastoutside');
% fix scaling
Z_dar;
% add labels
title('(b) Surface NO_{3} (mmol N m^{-3})','fontweight','bold')
xlabel('Longitude (deg)')
% add coastline
Z_addcoast('combined',Tdir.coast);

