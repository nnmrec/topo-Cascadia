function [] = basic(Tdir,infile,basename,tt)
%
% plots Salish simulations, a generic plot of the full domain
% 10/4/2012  Parker MacCready

% get file info
[G,S,T]=Z_get_basic_info(infile);

cbl = 'Eastoutside';
scvec = [23 33];
tcvec = [8 16];

% plot salinity
s0 = nc_varget(infile,'salt',[0 S.N-1 0 0],[1 1 -1 -1]);
subplot(121)
Z_pcolorcen(G.lon_rho,G.lat_rho,s0);
caxis(scvec);
colorbar(cbl);
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

% plot temperature
t0 = nc_varget(infile,'temp',[0 S.N-1 0 0],[1 1 -1 -1]);
subplot(122)
Z_pcolorcen(G.lon_rho,G.lat_rho,t0);
caxis(tcvec);
colorbar(cbl);
% fix scaling
Z_dar;
% add labels
title('(b) Surface Temperature','fontweight','bold')
xlabel('Longitude (deg)')
% add coastline
Z_addcoast('combined',Tdir.coast);
% and velocity vectors
Z_velvec(infile,G,S,'lr')

