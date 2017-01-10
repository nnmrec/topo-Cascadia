function [] = dye(Tdir,infile,basename,tt)
%
% plots Salish simulations, a generic plot of the full domain with dyes (5)
% 3/30/2011  Parker MacCready

% get file info
[G,S,T]=Z_get_basic_info(infile);
scvec = [23 33];

% plot salinity
s0 = nc_varget(infile,'salt',[0 S.N-1 0 0],[1 1 -1 -1]);
subplot(231)
Z_pcolorcen(G.lon_rho,G.lat_rho,s0);
caxis(scvec);
colorbar('Eastoutside');
% fix scaling
Z_dar;
% add labels
title('Surface Salinity','fontweight','bold')
xlabel('Longitude (deg)')
ylabel('Latitude (deg)')
% add file info
Z_info(basename,tt,T,'lr');
% add coastline
Z_addcoast('combined',Tdir.coast);

for ii = 1:5
    % plot dye
    t0 = nc_varget(infile,['dye_0',num2str(ii)],[0 S.N-1 0 0],[1 1 -1 -1]);
    subplot(2,3,ii+1)
    Z_pcolorcen(G.lon_rho,G.lat_rho,t0);
    % fix scaling
    Z_dar;
    % add labels
    title(['dye 0',num2str(ii)],'fontweight','bold')
    xlabel('Longitude (deg)')
    % add coastline
    Z_addcoast('combined',Tdir.coast);
end

